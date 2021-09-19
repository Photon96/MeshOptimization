clear all
close all
addpath('../src')
mesh = load('../structures/3D/real structures/d_Filtr_DDM.mat');
mesh_initial = load('../structures/3D/real structures/d_Filtr_DDM.mat');

d_cylinder = 5.1;

all_nodes_changed = [];
cylinder_surfaces = [];
% 1. z lewej
z_start = (19.05-9)/2 + 2.31;
z_end = z_start + 2.31;
x_start = 20 + (9.5 - d_cylinder)/2;
x_end = x_start + d_cylinder;
y_start = (9.52 - 6.91)/2 + (6.91 - d_cylinder)/2;
y_end = y_start + d_cylinder;

cylinder_pos = [x_start x_end; y_start y_end; z_start z_end];

params.c1 = 0.9;
params.c2 = 0.9;
params.c3 = 1;
% promien, w ktorym sa wybierane wierzcholki
params.R = 4;
debug = 0;
[mesh, nodes_changed, cylinder_surface] = ExtendIris(mesh, cylinder_pos, params, debug);
all_nodes_changed = [all_nodes_changed;nodes_changed];
cylinder_surfaces = [cylinder_surfaces; cylinder_surface];
% 2. krazek
x_start = 30 + (9.5 - d_cylinder)/2;
x_end = x_start + d_cylinder;

y_start = (9.52 - 7.93)/2 + (6.91 - d_cylinder)/2;
y_end = y_start + d_cylinder;

z_start = (19.05-9)/2 + 2.31;
z_end = z_start + 2.31;
cylinder_pos = [x_start x_end; y_start y_end; z_start z_end];


params.c1 = 0.9;
params.c2 = 0.8;
params.c3 = 0.8;
params.R = 4;
debug = 0;
[mesh, nodes_changed, cylinder_surface] = ExtendIris(mesh, cylinder_pos, params, debug);
all_nodes_changed = [all_nodes_changed;nodes_changed];
cylinder_surfaces = [cylinder_surfaces; cylinder_surface];

% 3. krazek
x_start = 39.5 + (9.5 - d_cylinder)/2;
x_end = x_start + d_cylinder;

y_start = (9.52 - 7.93)/2 + (6.91 - d_cylinder)/2;
y_end = y_start + d_cylinder;

z_start = (19.05-9)/2 + 2.31;
z_end = z_start + 2.31;
cylinder_pos = [x_start x_end; y_start y_end; z_start z_end];


params.c1 = 0.9;
params.c2 = 0.8;
params.c3 = 0.8;
params.R = 4;
debug = 0;
[mesh, nodes_changed, cylinder_surface] = ExtendIris(mesh, cylinder_pos, params, debug);
all_nodes_changed = [all_nodes_changed;nodes_changed];
cylinder_surfaces = [cylinder_surfaces; cylinder_surface];

% ostatni krazek
x_start = 49 + (9.5 - d_cylinder)/2;
x_end = x_start + d_cylinder;

y_start = (9.52 - 6.91)/2 + (6.91 - d_cylinder)/2;
y_end = y_start + d_cylinder;

z_start = (19.05-9)/2 + 2.31;
z_end = z_start + 2.31;
cylinder_pos = [x_start x_end; y_start y_end; z_start z_end];

params.c1 = 0.9;
params.c2 = 0.9;
params.c3 = 1;
% promien, w ktorym sa wybierane wierzcholki
params.R = 4;
debug = 0;
[mesh, nodes_changed, cylinder_surface] = ExtendIris(mesh, cylinder_pos, params, debug);
all_nodes_changed = [all_nodes_changed;nodes_changed];
cylinder_surfaces = [cylinder_surfaces; cylinder_surface];

optimized_qualities = CalcQualityTetraVLrms(mesh.tetrahedra, mesh.vertices);
initial_qualities = CalcQualityTetraVLrms(mesh_initial.tetrahedra, mesh_initial.vertices);
figure()
DrawQualityGraph(initial_qualities, optimized_qualities, '');
poor_tets = optimized_qualities < 1/3;

tetramesh(mesh.tetrahedra(poor_tets,:), mesh.vertices, 'facecolor', 'none')


vertices = mesh.vertices;
changed_vertices = all_nodes_changed;
tetrahedra = mesh.tetrahedra;
surface = mesh.surface;
free_vertices = mesh.free_vertices;

pathname=fileparts('..\structures\3D\real structures\');
matfile = fullfile(pathname, "d_Filtr_DDM_extended_irises.mat");
save(matfile,...
    'vertices', 'changed_vertices', 'tetrahedra', 'surface', 'free_vertices', 'cylinder_surfaces');
