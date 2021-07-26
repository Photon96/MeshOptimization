addpath('../src')
mesh_name = 'd_Filtr_DDM.mat';
mesh_name = 'cube_3k_el.mat';
save_mesh = 0;
mesh = load(sprintf('../structures/3D/%s', mesh_name));

quality_treshold = 1/3;
tetras = mesh.tetrahedra;
positions = mesh.vertices;
free_nodes = mesh.free_vertices;
surface = mesh.surface;
% ind_x = (positions(:, 1) == 0 | positions(:, 1) == 1);
% ind_y = (positions(:, 2) == 0 | positions(:, 2) == 1);
% ind_z = (positions(:, 3) == 0 | positions(:, 3) == 1);
% free_nodes = find(~(ind_x | ind_y | ind_z));

positions = mesh.vertices;
% for i=1:10
tets_to_change = rand(length(free_nodes), 1) > 0.3;
tets_to_change = free_nodes(tets_to_change);
a = -0.05;
b = 0.05;
min_quality = 0;
prev_positions = positions;
while (min_quality <= 0)
    positions = prev_positions;
    r = a + (b-a).*rand(length(tets_to_change), 3);
    positions(tets_to_change, :) = positions(tets_to_change,:) + r;
    min_quality = min(CalcQualityTetraVLrms(tetras, positions));
% end
end
qualities = CalcQualityTetraVLrms(tetras, positions);
poor_tetras = qualities < quality_treshold;
fprintf("Liczba elementow: %i\n", length(tetras));
fprintf("Liczba elementow o jakosci < %.2f: %i\n", quality_treshold, sum(poor_tetras));

% figure()
% tetramesh(mesh.tetrahedra, positions, 'facecolor','none');
% hold on
% tetramesh(mesh.tetrahedra(poor_tetras,:), positions, 'facecolor', 'red');
% figure()
DrawQualityHistogram(qualities, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')

vertices = positions;
free_vertices = free_nodes;
tetrahedra = tetras;

if save_mesh
    save_mesh_name = sprintf('../structures/3D/deformed_%s', mesh_name);
    save(save_mesh_name, 'vertices', 'free_vertices', 'tetrahedra', 'surface')
end

