clear all
close all
mesh = load('../structures/3D/real structures/d_Filtr_DDM.mat');
x_max = max(mesh.vertices(:,1));
y_max = max(mesh.vertices(:,2));
z_max = max(mesh.vertices(:,3));
[corner_vertices, segment_vertices, facet_vertices] = GroupSurfaceVertices(mesh);

surface_nodes = unique(mesh.surface(:));
z_end = (19.05-9)/2 + 2.3 + 2.31;
d_cylinder = 5.1;
x_start = 20 + (9.5 - d_cylinder)/2;
x_end = x_start + d_cylinder;
y_start = (9.52 - 6.91)/2 + (6.91 - d_cylinder)/2;
y_end = y_start + d_cylinder;


cylinder_x_nodes = (mesh.vertices(surface_nodes,1) > x_start) & (mesh.vertices(surface_nodes,1) < x_end)... 
                        | ismembertol(mesh.vertices(surface_nodes, 1), x_start, 0.01) | ismembertol(mesh.vertices(surface_nodes, 1), x_end, 0.01); 

cylinder_y_nodes = (mesh.vertices(surface_nodes,2) > y_start) & (mesh.vertices(surface_nodes, 2) < y_end)... 
                        | ismembertol(mesh.vertices(surface_nodes, 2), y_start, 0.01) | ismembertol(mesh.vertices(surface_nodes, 2), y_end, 0.01); 
         

% cylinder_z_nodes = ismembertol(mesh.vertices(surface_nodes, 3), z_end_cylinder, 0.0001);
cylinder_z_nodes = ismembertol(mesh.vertices(surface_nodes, 3), z_end, 0.01);
% cylinder_z_nodes(cylinder_z_nodes) = abs(mesh.vertices(cylinder_z_nodes,3) - z_end) < 0.1;
cylinder_nodes = cylinder_x_nodes & cylinder_y_nodes & cylinder_z_nodes;

cylinder_z_nodes = surface_nodes(cylinder_nodes);

plot3(mesh.vertices(surface_nodes,1), mesh.vertices(surface_nodes,2), mesh.vertices(surface_nodes,3), 'r.')
hold on
plot3(mesh.vertices(cylinder_z_nodes,1), mesh.vertices(cylinder_z_nodes,2), mesh.vertices(cylinder_z_nodes,3), 'g.')
axis equal


% gaussian

x_s = -1:0.1:1;
y_s = -1:0.1:1;
z_s = -1:0.1:1;
grid_points = length(z_s);
[X, Y, Z] = ndgrid(x_s,y_s,z_s);
grid_positions = [reshape(X, grid_points^3, 1), reshape(Y, grid_points^3, 1), reshape(Z, grid_points^3, 1)];
distances = abs(1-grid_positions);
(1 - (grid_positions(distances(:,1)~=0, 1)./distances(distances(:,1)~=0, 1)).^2).^(3/2)
