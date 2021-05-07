clear all
addpath('../src')
addpath('../poblano_toolbox')
load('../structures/deformed_cube_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;
quality_treshold = 0.35;


global_qualities = CalcQualityTetraVLrms(tetras, positions);
nodes_optimize = GetNodesToOptimize(...
    free_nodes, tetras, global_qualities, quality_treshold);

node = nodes_optimize(1);
adjacent_tetras = GetAdjacentTetras(node, tetras);

% x0 = positions(node, :);
% f = @(x)FunctionMetric(x, node, adjacent_tetras, positions);
% out = ncg(f, x0');

tic
prev_qualities = CalcQualityTetraVLrms(tetras, positions);
nodes_optimize = GetNodesToOptimize(...
  free_nodes, tetras, prev_qualities, quality_treshold);
params = ncg('defaults');
% params = lbfgs('defaults');
params.Display = "off";
params.MaxIters = 1;
params.RestartIters = 5;
params.Update = 'PR';
for i=1:length(nodes_optimize)
    adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
    node = nodes_optimize(i);
    x0 = positions(node, :);
    f = @(x)FunctionMetric(x, node, adjacent_tetras, positions);
    
    out = ncg(f, x0', params);
%     out = lbfgs(f, x0', params);

    positions(node, :) = out.X';
end
duration = toc;

global_qualities = CalcQualityTetraVLrms(tetras, positions);
duration
min(global_qualities)
mean(global_qualities)