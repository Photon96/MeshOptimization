function [selected_surface_tri,selected_surface_tri_indexes] = GetSelectedSurfaceTriangles(mesh, selected_vertices)
    selected_surface_tri = [];
    selected_surface_tri_indexes = [];
    for i=1:length(mesh.surface)
        if (isempty(setdiff(mesh.surface(i,:), selected_vertices)))
            selected_surface_tri = [selected_surface_tri;mesh.surface(i,:)];
            selected_surface_tri_indexes = [selected_surface_tri_indexes; i];
        end
    end
end
