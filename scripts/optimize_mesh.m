clear all
addpath('../src')
load('../structures/example_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;

max_k = 1;
resolution = 1/50; 
quality_treshold = 0.35;

prev_qualities1 = CalcQualityTetraVLrms(tetras, positions);

opts.max_k = max_k;
opts.quality_treshold = quality_treshold;
opts.resolution = resolution;
opts.diagnostics = false;

tic
positions = OptimizeMesh(tetras, positions, free_nodes, @CalcQualityTetraVLrms, opts);
info.duration = toc;

current_qualities1 = CalcQualityTetraVLrms(tetras, positions);

info.quality_treshold = quality_treshold;
info.nr_iterations = max_k;
info.min_prev_quality = min(prev_qualities1);
info.mean_prev_quality = mean(prev_qualities1);
info.min_current_quality = min(current_qualities1);
info.mean_current_quality = mean(current_qualities1);

sprintf("Optimization info:")
info

figure(1);
DrawQualityGraph(prev_qualities1, current_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$');
