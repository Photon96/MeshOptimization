function [new_surface] = RemoveFace(mesh, borders)
    x_start = borders(1);
    x_end = borders(2);
    y_start = borders(3);
    
    surface_nodes = unique(mesh.surface(:));
    X = (mesh.vertices(surface_nodes, 1) > x_start) & (mesh.vertices(surface_nodes, 1) < x_end) ...
        | (ismembertol(mesh.vertices(surface_nodes, 1), x_start, 0.01)) | ismembertol(mesh.vertices(surface_nodes, 1), x_end, 0.01);
    Y = ismembertol(mesh.vertices(surface_nodes, 2), y_start, 0.01); 
    iris_1_front_face = X & Y;
    iris_1_front_face = surface_nodes(iris_1_front_face);
    new_surface = [];
    for i=1:length(mesh.surface)
        if (~isempty(setdiff(mesh.surface(i,:), iris_1_front_face)))
            new_surface = [new_surface; mesh.surface(i,:)];
        end
    end
end

