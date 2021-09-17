clear all
addpath('../src')
load('../structures/deformed_cube_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;

new_free_nodes = [];
for i=1:size(tetras, 1)
    tet = tetras(i,:);
    pos = positions(tet,:);
    for k=1:size(pos, 2)
        val = unique(pos(:,k));
        if length(val) == 2
            for j=1:length(val)
                if sum(val(j) == pos(:,k)) == 3
                   free_node = tet(pos(:,k) ~= val(j));
                   new_free_nodes = [new_free_nodes; free_node];
                   break
                end
            end
        end
    end
end 