function [mesh, nodes_changed, cylinder_surface] = ExtendIris(mesh, cylinder_pos, params, debug)

    c1 = params.c1;
    c2 = params.c2;
    c3 = params.c3;
    R = params.R;
    x_start = cylinder_pos(1,1);
    x_end = cylinder_pos(1,2);
    y_start = cylinder_pos(2,1);
    y_end = cylinder_pos(2,2);
    z_start = cylinder_pos(3,1);
    z_end = cylinder_pos(3,2);
    d_cylinder = x_end - x_start;
    
    
    
    
    surface_nodes = unique(mesh.surface(:));

    cylinder_x_nodes = (mesh.vertices(surface_nodes,1) > x_start) & (mesh.vertices(surface_nodes,1) < x_end)... 
                            | ismembertol(mesh.vertices(surface_nodes, 1), x_start, 0.01) | ismembertol(mesh.vertices(surface_nodes, 1), x_end, 0.01); 

    cylinder_y_nodes = (mesh.vertices(surface_nodes,2) > y_start) & (mesh.vertices(surface_nodes, 2) < y_end)... 
                            | ismembertol(mesh.vertices(surface_nodes, 2), y_start, 0.01) | ismembertol(mesh.vertices(surface_nodes, 2), y_end, 0.01); 


    cylinder_z_nodes = ismembertol(mesh.vertices(surface_nodes, 3), z_end, 0.01);
    cylinder_nodes = cylinder_x_nodes & cylinder_y_nodes & cylinder_z_nodes;

    %wybor wezlow na wierzchu cylindra
    cylinder_z_nodes = surface_nodes(cylinder_nodes);

    % rzeczywisty środek
    x_center = min(mesh.vertices(cylinder_z_nodes, 1)) + (max(mesh.vertices(cylinder_z_nodes,1)) - min(mesh.vertices(cylinder_z_nodes, 1)))/2;
    y_center = min(mesh.vertices(cylinder_z_nodes, 2)) + (max(mesh.vertices(cylinder_z_nodes,2)) - min(mesh.vertices(cylinder_z_nodes, 2)))/2;

    % oś cylindra
    iris_axis = [x_center, y_center];
    
%     if debug
%         plot3(mesh.vertices(surface_nodes,1), mesh.vertices(surface_nodes,2), mesh.vertices(surface_nodes,3), 'r.')
%         hold on
%         plot3(mesh.vertices(mesh.free_vertices,1), mesh.vertices(mesh.free_vertices,2), mesh.vertices(mesh.free_vertices,3), 'b.')
%         axis equal
%     end


    % 1) przesunac wezly na krawedzi cylindra
    % 2) wyznaczyc odleglosci wezlow wolnych od osi
    % 3) wybrac te ktorych odleglosc < R
    % 4) podzielic je na lezace w promieniu walca i poza promieniem walca
    % 5) odpowiednio je przesunac

    delta_z = 1;
    % 
    % iris_axis = [x_start + d_cylinder/2,y_start + d_cylinder/2];

    % mesh.vertices(cylinder_z_nodes,3) = mesh.vertices(cylinder_z_nodes,3) + delta_z;

    % plot3(mesh.vertices(cylinder_z_nodes,1), mesh.vertices(cylinder_z_nodes,2), mesh.vertices(cylinder_z_nodes,3), 'g.')

    % wybór węzłów tworzących cylinder
    surface_nodes = unique(mesh.surface(:));
    dist = sqrt(sum((mesh.vertices(surface_nodes,[1,2]) - iris_axis([1,2])).^2,2));
    cylinder_surface = surface_nodes(ismembertol(dist, d_cylinder/2, 0.01) == 1);
    between_z = find(mesh.vertices(surface_nodes,3) > (z_start + 0.1) & mesh.vertices(surface_nodes,3)< z_end); 
    cylinder_surface = intersect(cylinder_surface,between_z);
    cylinder_surface = [cylinder_surface; cylinder_z_nodes];
%     plot3(mesh.vertices(cylinder_surface,1), mesh.vertices(cylinder_surface,2), mesh.vertices(cylinder_surface,3), 'g.')

    nodes_inside_cylinder = setdiff(GetNodesInCylinder(mesh, [z_start z_end], iris_axis, d_cylinder/2), cylinder_surface);
%     selected_nodes = [nodes_inside_cylinder; cylinder_surface];
    [~, tets_indexes] = GetSelectedTets(mesh, nodes_inside_cylinder);
    tetramesh(mesh.tetrahedra(tets_indexes,:), mesh.vertices, 'facecolor', 'none')
    mesh = SanitizeMesh(mesh, tets_indexes);
    
    

    % odleglosci od srodka osi cylindra
    distances = sqrt(sum((mesh.vertices(mesh.free_vertices,[1,2]) - iris_axis).^2,2));
    z_distance = mesh.vertices(mesh.free_vertices, 3) > z_start;

    inside = distances <= d_cylinder/2 & z_distance;
    outside = distances > d_cylinder/2 & distances <= R & z_distance;

    nodes_inside_radius_of_cylinder = mesh.free_vertices(inside)';
    nodes_outside_radius_of_cylinder = mesh.free_vertices(outside)';
    nodes_outside_radius_of_cylinder = setdiff(nodes_outside_radius_of_cylinder, nodes_inside_cylinder);
    nodes_changed = [nodes_inside_radius_of_cylinder; nodes_outside_radius_of_cylinder];

    if debug
        figure()
        plot3(mesh.vertices(nodes_inside_radius_of_cylinder,1), mesh.vertices(nodes_inside_radius_of_cylinder,2), mesh.vertices(nodes_inside_radius_of_cylinder,3), 'r.')
        hold on
        plot3(mesh.vertices(nodes_outside_radius_of_cylinder,1), mesh.vertices(nodes_outside_radius_of_cylinder,2), mesh.vertices(nodes_outside_radius_of_cylinder,3), 'g.')
        plot3(mesh.vertices(nodes_inside_cylinder,1), mesh.vertices(nodes_inside_cylinder,2), mesh.vertices(nodes_inside_cylinder,3), 'k.')

        [X,Y,Z] = cylinder(d_cylinder/2);
        Z = z_start + (z_end-z_start)*Z;
        X = X + x_center;
        Y = Y + y_center;
%         figure()
        surf(X,Y,Z);
    end
    % niektore z wierzcholkow z nodes_moved moga byc wewnątrz cylindra
    % jako ze tety odpowiadajace tym wierzcholkom zostaly wczesniej wyrzucone z
    % siatki, to nie musze sie martwic czy zostana przesuniete w kolejnym kroku
    % bo i tak nic to nie zmieni
    % te wierzcholki sa usuwane z nodes_moved tylko w celu wyswietlenia
    % przesunietych wierzcholkow wplywajacych na tety
    nodes_changed = setdiff(nodes_changed, nodes_inside_cylinder);

    move_inside = delta_z * exp(-c1 * abs(z_end - mesh.vertices(nodes_inside_radius_of_cylinder,3)));
    move_outside = delta_z * exp(-c1 * abs(z_end - mesh.vertices(nodes_outside_radius_of_cylinder,3))).*exp(-c2*(distances(outside) - d_cylinder/2));

    mesh.vertices(cylinder_surface,3) = mesh.vertices(cylinder_surface,3) + delta_z*exp(-c3*abs(mesh.vertices(cylinder_surface,3) - z_end));

    mesh.vertices(nodes_outside_radius_of_cylinder,3) = mesh.vertices(nodes_outside_radius_of_cylinder,3) + move_outside;

    mesh.vertices(nodes_inside_radius_of_cylinder,3) = mesh.vertices(nodes_inside_radius_of_cylinder,3) + move_inside;

    quality = CalcQualityTetraVLrms(mesh.tetrahedra, mesh.vertices);
    sum((quality < 0) == 1)
    if debug
%         cylinder_surface = [cylinder_surface;nodes_changed];
%         figure()
%         plot3(mesh.vertices(cylinder_surface,1),mesh.vertices(cylinder_surface,2),mesh.vertices(cylinder_surface,3), 'r.')
%         hold on
        nodes_in_box = GetNodesInBox(mesh,[20,0,0;30,10,20]);
        [~, tets_indexes] = GetSelectedTets(mesh, nodes_in_box);
        
        poor_tets = zeros(length(quality),1);
        
        poor_tets(tets_indexes) = quality(tets_indexes) < 1/3;
        
        tetramesh(mesh.tetrahedra(logical(poor_tets),:), mesh.vertices, 'facecolor', 'none')
%         tetramesh(mesh.tetrahedra(tets_indexes,:), mesh.vertices, 'facecolor', 'none')
    end
    
    
    
end

