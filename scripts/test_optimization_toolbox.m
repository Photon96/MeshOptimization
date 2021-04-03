clear all
addpath('../src')
load('../structures/example_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;

quality_treshold = 0.35;
prev_qualities1 = CalcQualityTetraVLrms(tetras, positions);


% options = optimoptions(...
%     'fminunc','Algorithm','quasi-newton', 'SpecifyObjectiveGradient', true, 'HessUpdate', 'dfp', 'Display', 'off');
options = optimoptions(...
    'fminunc','Algorithm','quasi-newton', 'SpecifyObjectiveGradient', true, 'HessUpdate', 'steepdesc', 'Display', 'off', 'MaxIterations', 10);
% options = optimoptions(...
%     'fminunc','Algorithm','trust-region', 'SpecifyObjectiveGradient', true, 'Display', 'off', 'HessianFcn', 'objective');
tic
global_qualities = CalcQualityTetraVLrms(tetras, positions);
nodes_optimize = GetNodesToOptimize(...
  free_nodes, tetras, global_qualities, quality_treshold);

for i=1:length(nodes_optimize)
    adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
    node = nodes_optimize(i);
    x0 = positions(node, :);
    f = @(x)FunctionMetric(x, node, adjacent_tetras, positions);
    [x, fval] = fminunc(f,x0,options);
    positions(node, :) = x;
end
toc
current_qualities1 = CalcQualityTetraVLrms(tetras, positions);
figure(1);
DrawQualityGraph(prev_qualities1, current_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$');

% options = optimoptions('fminunc','Algorithm','quasi-newton', 'SpecifyObjectiveGradient', true);



