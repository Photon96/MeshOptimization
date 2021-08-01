clear all
addpath('../src')

% user settings
mesh_name = 'd_Filtr_DDM';
available_quality_metrics = ["Mean-Ratio", "Volume-Length"];
quality_metric_name = available_quality_metrics(2);
opts.max_sweeps = 3;
opts.resolution = 1/100; 
opts.quality_treshold = 1/3;
opts.algorithm = 'DMO';
opts.grid_points = 2;
opts.diagnostics = false;
save_optimized_mesh = 0;

mean_ratio_label = '$\frac{3\left| det\left( AW^{-1}\right)\right|^{\frac{2}{3}}}{\| AW^{-1}\|_{F}^2 }$';
vlrms_label = '$6 \sqrt{2}\frac{V}{L_{rms}^3}$';

if strcmp(quality_metric_name, "Mean-Ratio")
    quality_functions{1} = @CalcQualityTetraMeanRatio;
    quality_functions{2} = @FiniteDifference;
    quality_metric_label = mean_ratio_label;
elseif strcmp(quality_metric_name, "Volume-Length")
    quality_functions{1} = @CalcQualityTetraVLrms;
    quality_functions{2} = @VLrmsGradient;
    quality_metric_label = vlrms_label;
end
quality_metric = quality_functions{1};


mesh_initial = load(sprintf('../structures/3D/real structures/deformed_%s.mat', mesh_name));
mesh_initial.tetrahedra = SetTetrahedraInCorrectOrientation(mesh_initial.tetrahedra, mesh_initial.vertices);


initial_qualities = quality_metric(mesh_initial.tetrahedra, mesh_initial.vertices);

PrintMeshInfo(mesh_initial)
fprintf("\n\n------- Before optimization -------\n\n")
PrintMeshQualityStats(initial_qualities, quality_metric_name)

tic
[mesh_optimized, processed_nodes] = OptimizeMesh(mesh_initial, quality_functions, opts);
duration = toc;

optimized_qualities = quality_metric(mesh_optimized.tetrahedra, mesh_optimized.vertices);

opt_info = SetOptimizationInfo(opts, initial_qualities, optimized_qualities, processed_nodes, duration);

fprintf("\n\n------- After %s optimization -------\n\n", opts.algorithm)
PrintMeshQualityStats(optimized_qualities, quality_metric_name)
PrintOptimizationInfo(opt_info)

figure()
DrawQualityGraph(initial_qualities, optimized_qualities, quality_metric_name);

figure()
subplot(2,1,1)
DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh_initial))
title('Siatka przed poprawą')

subplot(2,1,2)

DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh_optimized))
title('Siatka po poprawie')

if save_optimized_mesh
    tetrahedra = mesh_optimized.tetrahedra;
    vertices = mesh_optimized.vertices;
    free_vertices = mesh_optimized.free_vertices;
    surface = mesh_optimized.surface;
    save(sprintf('../structures/3D/real structures/optimized_%s_%s.mat', opts.algorithm, mesh_name),...
        'tetrahedra', 'vertices', 'free_vertices', 'surface');
end



