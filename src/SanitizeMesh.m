function [mesh] = SanitizeMesh(mesh, selected_tets)
    
    keep_tets = ones(length(mesh.tetrahedra),1);
    keep_tets(selected_tets) = 0;
    mesh.tetrahedra = mesh.tetrahedra(logical(keep_tets), :);
    
end

