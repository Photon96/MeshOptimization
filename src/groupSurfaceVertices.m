corner_vertices = [];
segment_vertices = [];
facet_vertices = [];
surface_vertices = unique(mesh.surface);
for j=1:length(surface_vertices)
    
    surface_vertex = surface_vertices(j);
    adjacent_triangles = GetAdjacentTetras(surface_vertex, mesh.surface);
    %get all normals
    normals = zeros(size(adjacent_triangles,1),3);
    for i=1:size(adjacent_triangles,1)
        normals(i,:) = NormalToTriangle(mesh.vertices, adjacent_triangles(i,:));
    end
    distinct_normals_direction = length(find(any(normals ~= 0)));
    if distinct_normals_direction == 3
        corner_vertices = [corner_vertices; surface_vertex];
    elseif distinct_normals_direction == 2
        segment_vertices = [segment_vertices; surface_vertex];
    else
        facet_vertices = [facet_vertices; surface_vertex];
    end
end


