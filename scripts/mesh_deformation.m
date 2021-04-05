addpath('../src')
m = load('../structures/cube_mesh.mat');
tetras = m.tetras;
positions = m.positions;

ind_x = (positions(:, 1) == 0 | positions(:, 1) == 1);
ind_y = (positions(:, 2) == 0 | positions(:, 2) == 1);
ind_z = (positions(:, 3) == 0 | positions(:, 3) == 1);
free_nodes = find(~(ind_x | ind_y | ind_z));


a = -0.01;
b = 0.01;
min_quality = 0;
while (min_quality <= 0)
    r = a + (b-a).*rand(size(free_nodes, 1), 3);
    positions(free_nodes, :) = positions(free_nodes,:) + r;
    min_quality = min(CalcQualityTetraVLrms(tetras, positions));
end

mesh.positions = positions;
mesh.free_nodes = free_nodes;
mesh.tetrahedrons = tetras;
save('../structures/deformed_cube_mesh', 'mesh')
