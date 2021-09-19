function [selected_tets,selected_tets_indexes] = GetSelectedTets(mesh, selected_vertices)
    selected_tets = [];
    selected_tets_indexes = [];
    for i=1:length(mesh.tetrahedra)
        if (length(setdiff(mesh.tetrahedra(i,:), selected_vertices)) < 4)
            selected_tets = [selected_tets;mesh.tetrahedra(i,:)];
            selected_tets_indexes = [selected_tets_indexes; i];
        end
    end
end

