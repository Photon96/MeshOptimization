clear all
addpath('../src')

% user config
config_file = "../configs/test_GD.json";
config = ReadConfig(config_file);

quality_metric_name = config.quality_metric;

alg_options = SetAlgOptions(config);

if isfield(config, 'mesh_save')
    save_optimized_mesh = true;
else
    save_optimized_mesh = false;
end

if strcmp(quality_metric_name, "Mean-Ratio")
    quality_functions{1} = @CalcQualityTetraMeanRatio;
    quality_functions{2} = @FiniteDifference;
elseif strcmp(quality_metric_name, "Volume-Length")
    quality_functions{1} = @CalcQualityTetraVLrms;
    quality_functions{2} = @VLrmsGradient;
end

quality_metric = quality_functions{1};

mesh_initial = load(config.mesh_file);
mesh_initial.tetrahedra = SetTetrahedraInCorrectOrientation(mesh_initial.tetrahedra, mesh_initial.vertices);


initial_qualities = quality_metric(mesh_initial.tetrahedra, mesh_initial.vertices);

PrintMeshInfo(mesh_initial)
fprintf("\n\n------- Before optimization -------\n\n")
PrintMeshQualityStats(initial_qualities, quality_metric_name)

if config.real_structure
    tmp_free_vertices = mesh_initial.free_vertices;
    mesh_initial.free_vertices = mesh_initial.changed_vertices;
end

tic
[mesh_optimized, processed_nodes] = OptimizeMesh(mesh_initial, quality_functions, alg_options);
duration = toc;

optimized_qualities = quality_metric(mesh_optimized.tetrahedra, mesh_optimized.vertices);

opt_info = SetOptimizationInfo(alg_options, initial_qualities, optimized_qualities, processed_nodes, duration);

fprintf("\n\n------- After %s optimization -------\n\n", alg_options.algorithm)
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
    free_vertices = tmp_free_vertices;
    surface = mesh_optimized.surface;
    save(config.mesh_save, 'tetrahedra', 'vertices', 'free_vertices', 'surface');
end
