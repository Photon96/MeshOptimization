function [] = PrintMeshInfo(mesh)
    fprintf('------- Mesh information -------\n')
    fprintf('Number of tetrahedron elements: %i\n', size(mesh.tetrahedra, 1))
    fprintf('Number of vertices: \t\t\t%i\n', size(mesh.vertices, 1))
    fprintf('Number of free vertices: \t\t%i\n\n', length(mesh.free_vertices))
end

