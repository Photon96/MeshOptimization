% clear all
addpath('../src')
mesh = load('../structures/3D/deformed_cube_3k_el.mat');
% positions = mesh.positions;
tetras = mesh.tetrahedra;
% tetras(:,[2,3]) = tetras(:,[3,2]);
free_nodes = mesh.free_vertices;
positions = mesh.vertices;
quality_metric = @CalcQualityTetraMeanRatio;
% tetras = mesh.tetrahedra;

% positions = mesh.nodes;
% tetras = mesh.volume_elements;
% free_nodes = mesh.free_nodes;

max_k = 3;
resolution = 1/100; 
quality_treshold = 1/3;

prev_qualities1 = quality_metric(tetras, positions);
nodes_optimize_prev = GetNodesToOptimize(...
          free_nodes, tetras, prev_qualities1, quality_treshold);
      
opts.max_k = 3;
opts.quality_treshold = quality_treshold;
opts.diagnostics = 0;
tic
positions = DMOOptimizeMesh(tetras, positions, free_nodes, quality_metric, opts);
info.duration = toc;

current_qualities1 = quality_metric(tetras, positions);
nodes_optimize_curr = GetNodesToOptimize(...
          free_nodes, tetras, current_qualities1, opts.quality_treshold);
      
info.quality_treshold = quality_treshold;
info.nr_iterations = max_k;
info.min_prev_quality = min(prev_qualities1);
info.mean_prev_quality = mean(prev_qualities1);
info.min_current_quality = min(current_qualities1);
info.mean_current_quality = mean(current_qualities1);
info.improved_tetras = sum(prev_qualities1 < current_qualities1);
info.nodes_per_sec = round((length(nodes_optimize_prev) - length(nodes_optimize_curr) )/info.duration); 
    
sprintf("Optimization info:")
info

figure(1);
DrawQualityGraph(prev_qualities1, current_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$');
figure(2)
subplot(2,1,1)
mean_ratio_label = '$\frac{3\| det\left( AW^{-1}\right)\|^{\frac{2}{3}}}{\| AW^{-1}\|_{F}^2 }$';
VLrms_label = '$6 \sqrt{2}\frac{V}{L_{rms}^3}$';
DrawQualityBar(prev_qualities1, mean_ratio_label)
title("Siatka przed poprawą")
subplot(2,1,2)
DrawQualityBar(current_qualities1, mean_ratio_label)
title("DMO (3x3x3)")