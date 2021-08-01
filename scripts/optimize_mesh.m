clear all
addpath('../src')
mesh_name = 'mesquite comparison/deformed_cube_3k_el_alg_comparison.mat';
sd_mesh_name = 'mesquite comparison/optimized_steepest_descent_3k_el_alg_comparison';
laplacian_mesh_name = 'mesquite comparison/optimized_smart_laplacian_cube_3k_el_alg_comparison.mat';
mesquite = 0;

mesh = load(sprintf('../structures/3D/%s', mesh_name));
mesh.tetrahedra = SetTetrahedraInCorrectOrientation(mesh.tetrahedra, mesh.vertices);

%user settings
available_quality_metrics = ["Mean-Ratio", "VLrms"];
display_tetramesh = 0;
quality_metric_name = available_quality_metrics(2);
max_sweeps = 3;
resolution = 1/100; 
quality_treshold = 1;
opts.algorithm = 'GD';
opts.grid_points = 2;
opts.diagnostics = false;

mean_ratio_label = '$\frac{3\left| det\left( AW^{-1}\right)\right|^{\frac{2}{3}}}{\| AW^{-1}\|_{F}^2 }$';
vlrms_label = '$6 \sqrt{2}\frac{V}{L_{rms}^3}$';

mean_ratio_label = '';
vlrms_label = '';
max_ys = [];
if strcmp(quality_metric_name, "Mean-Ratio")
    quality_metric_label = mean_ratio_label;
    quality_functions{1} = @CalcQualityTetraMeanRatio;
    quality_functions{2} = @FiniteDifference;
elseif strcmp(quality_metric_name, "VLrms")
    quality_metric_label = vlrms_label;
    quality_functions{1} = @CalcQualityTetraVLrms;
    quality_functions{2} = @VLrmsGradient;
end

%do rysowania subplotow
if mesquite
    cols = 2;
else
    cols = 1;
end
rows = 2;
quality_metric = quality_functions{1};
prev_qualities = quality_metric(mesh.tetrahedra, mesh.vertices);

fig = figure();

subplot(2,1,1)
DrawQualityHistogram(prev_qualities, quality_metric_label)

subplot(2,1,2)

DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh))
fig1 = figure();
fig2 = figure();

PrintMeshInfo(mesh)
fprintf("\n\n------- Before optimization -------\n\n")
PrintMeshQualityStats(prev_qualities, quality_metric_name)


if display_tetramesh
    figure()
    poor_tetras = prev_qualities < 1/3;
%     subplot(2,1,1)
    tetramesh(mesh.tetrahedra, mesh.vertices, 'facecolor','none');
    hold on
    tetramesh(mesh.tetrahedra(poor_tetras,:), mesh.vertices, 'facecolor', 'red');
end

opts.max_sweeps = max_sweeps;
opts.quality_treshold = quality_treshold;
opts.resolution = resolution;

tic
[mesh, processed_nodes] = OptimizeMesh(mesh, quality_functions, opts);
duration = toc;

current_qualities = quality_metric(mesh.tetrahedra, mesh.vertices);
      
opt_info = SetOptimizationInfo(opts, prev_qualities, current_qualities, processed_nodes, duration);

fprintf("\n\n------- After GD optimization -------\n\n")
PrintMeshQualityStats(current_qualities, quality_metric_name)
PrintOptimizationInfo(opt_info)

if display_tetramesh
    poor_tetras = current_qualities < 1/3;
    subplot(2,1,2)
%     tetramesh(tetras, positions, 'facecolor','none');
%     hold on
    tetramesh(mesh.tetrahedra(tetras(poor_tetras,:)), mesh.vertices, 'facecolor', 'red');
%     hold off
end

% figure();
% DrawQualityGraph(prev_qualities, current_qualities, quality_metric_label);

figure(fig1)
subplot(rows,cols,1)
max_y = DrawQualityHistogram(current_qualities, quality_metric_label);
max_ys = [max_ys; max_y];
title(opts.algorithm)

figure(fig2)
subplot(rows,cols,1)
DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh))
title(opts.algorithm)

mesh = load(sprintf('../structures/3D/%s', mesh_name));
mesh.tetrahedra = SetTetrahedraInCorrectOrientation(mesh.tetrahedra, mesh.vertices);

opts.algorithm = 'DMO';

tic
[mesh, processed_nodes] = OptimizeMesh(mesh, quality_functions, opts);
duration = toc;

current_qualities = quality_metric(mesh.tetrahedra, mesh.vertices);
      
opt_info = SetOptimizationInfo(opts, prev_qualities, current_qualities, processed_nodes, duration);

fprintf("\n\n------- After DMO optimization -------\n\n")
PrintMeshQualityStats(current_qualities, quality_metric_name)
PrintOptimizationInfo(opt_info)

figure(fig1)
subplot(rows,cols,2)
max_y = DrawQualityHistogram(current_qualities, quality_metric_label);
max_ys = [max_ys; max_y];
title(opts.algorithm)

figure(fig2)
subplot(rows,cols,2)
DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh))
title(opts.algorithm)

if mesquite
    mesh = load(sprintf('../structures/3D/%s', sd_mesh_name));
    mesh.tetrahedra = SetTetrahedraInCorrectOrientation(mesh.tetrahedra, mesh.vertices);
    current_qualities = quality_metric(mesh.tetrahedra, mesh.vertices);
    improved_tets = sum(prev_qualities < current_qualities) - sum(prev_qualities > current_qualities);

    figure(fig1)
    subplot(rows,cols,3)
    max_y = DrawQualityHistogram(current_qualities, quality_metric_label);
    max_ys = [max_ys; max_y];
    title("Mesquite Steepest Descent")

    figure(fig2)
    subplot(rows,cols,3)
    DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh))
    title("Mesquite Steepest Descent")

    fprintf("\n\n------- After SD optimization -------\n\n")
    PrintMeshQualityStats(quality_metric(mesh.tetrahedra, mesh.vertices), quality_metric_name)
    fprintf("Improved tets: %i\n", improved_tets)
    fprintf("Tets < 0.33: %i\n", sum(current_qualities < 0.33));

    mesh = load(sprintf('../structures/3D/%s', laplacian_mesh_name));
    mesh.tetrahedra = SetTetrahedraInCorrectOrientation(mesh.tetrahedra, mesh.vertices);

    current_qualities = quality_metric(mesh.tetrahedra, mesh.vertices);
    improved_tets = sum(prev_qualities < current_qualities) - sum(prev_qualities > current_qualities);
    figure(fig1)
    subplot(rows,cols,4)
    max_y = DrawQualityHistogram(current_qualities, quality_metric_label);
    max_ys = [max_ys; max_y];
    title("Mesquite Smart Laplacian")

    figure(fig2)
    subplot(rows,cols,4)
    DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh))
    title("Mesquite Smart Laplacian")

    fprintf("\n\n------- After Smart Laplacian optimization -------\n\n")
    PrintMeshQualityStats(quality_metric(mesh.tetrahedra, mesh.vertices), quality_metric_name)
    fprintf("Improved tets: %i\n", improved_tets)
    fprintf("Tets < 0.33: %i\n", sum(current_qualities < 1/3));
end

% wyrownaj ylim w subplotach QualityHistogram
if mesquite
    nr_subplots = 4;
else
    nr_subplots = 2;
end

max_y = max(max_ys);

for i=1:nr_subplots
    figure(fig1);
    subplot(rows, cols, i);
    ylim([0, max_y]);
end
