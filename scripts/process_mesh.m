mesh_name = "../structures/cube.mat";
addpath('../src')
mesh = load(mesh_name);

volume_elements = mesh.volume_elements;
surface_elements = mesh.surface_elements;
nodes = mesh.nodes;
surface_info = mesh.surface_info;
volume_info = mesh.volume_info;

unique_nodes_surface = unique(surface_elements(:));
unique_nodes_volume = unique(volume_elements(:));
free_nodes = setdiff(unique_nodes_volume, unique_nodes_surface);

subplot(2,1,1)
tetramesh(volume_elements, nodes, 'facecolor','none');
hold on
plot3(nodes(free_nodes, 1), nodes(free_nodes, 2), nodes(free_nodes, 3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r')
% tetramesh(volume_elements(10,:), nodes, 'facecolor', 'green');

a = -0.1;
b = 0.1;

tmp = nodes;
tmp(free_nodes, :) = nodes(free_nodes, :) + (b - a).*rand(size(free_nodes, 1), 3) + a;
min_quality = min(CalcQualityTetraVLrms(volume_elements, tmp));
while min_quality < 0
    tmp = nodes;
    tmp(free_nodes, :) = nodes(free_nodes, :) + (b - a).*rand(size(free_nodes, 1), 3) + a;
    min_quality = min(CalcQualityTetraVLrms(volume_elements, tmp));
end
nodes = tmp;
qualities = CalcQualityTetraVLrms(volume_elements, tmp);
poor_tetras = qualities < 1/3;
subplot(2,1,2)
tetramesh(volume_elements, tmp, 'facecolor','none');
hold on
% plot3(tmp(free_nodes, 1), tmp(free_nodes, 2), tmp(free_nodes, 3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r')
tetramesh(volume_elements(poor_tetras,:), nodes, 'facecolor', 'red');
% mesh.nodes = nodes;
% mesh.free_nodes = free_nodes;
save('../structures/cube_deformed.mat', 'nodes', 'surface_elements', 'surface_info', 'volume_elements', 'volume_info', 'free_nodes');
