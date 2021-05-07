clear all
addpath('../src')
load('../structures/deformed_cube_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;

max_k = 3;
resolution = 1/100; 
quality_treshold = 1/3;

prev_qualities1 = CalcQualityTetraVLrms(tetras, positions);
nodes_optimize_prev = GetNodesToOptimize(...
          free_nodes, tetras, prev_qualities1, quality_treshold);
      
opts.max_k = max_k;
opts.quality_treshold = quality_treshold;
opts.resolution = resolution;
opts.diagnostics = false;

tic
positions = OptimizeMesh(tetras, positions, free_nodes, @CalcQualityTetraVLrms, opts);
info.duration = toc;

current_qualities1 = CalcQualityTetraVLrms(tetras, positions);
nodes_optimize_curr = GetNodesToOptimize(...
          free_nodes, tetras, current_qualities1, opts.quality_treshold);
      
info.quality_treshold = quality_treshold;
info.nr_iterations = max_k;
info.min_prev_quality = min(prev_qualities1);
info.mean_prev_quality = mean(prev_qualities1);
info.min_current_quality = min(current_qualities1);
info.mean_current_quality = mean(current_qualities1);
info.improved_tetras = ....
        sum(prev_qualities1 < quality_treshold) - sum(current_qualities1 < quality_treshold);
info.nodes_per_sec = round((length(nodes_optimize_prev) - length(nodes_optimize_curr) )/info.duration); 
    
sprintf("Optimization info:")
info

figure(1);
DrawQualityGraph(prev_qualities1, current_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$');
figure(2)
subplot(2,1,1)
DrawQualityBar(prev_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
title("Siatka przed poprawą")
subplot(2,1,2)
DrawQualityBar(current_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
title("Siatka po poprawie")