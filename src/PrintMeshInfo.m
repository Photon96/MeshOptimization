function [] = PrintMeshInfo(mesh)
    fprintf('\n------- Mesh information -------\n')
    fprintf('Number of tetrahedron elements: %i\n', size(mesh.tetrahedra, 1))
    fprintf('Number of vertices:             %i\n', size(mesh.vertices, 1))
    fprintf('Number of free vertices:        %i\n', length(mesh.free_vertices))
end

