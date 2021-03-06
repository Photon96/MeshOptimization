function [grad, grad_Lrms] = VLrmsGradient(vertex, tetras, positions, min_tetr, quality_function_handle)
    % przekazanie quality_function_handle tylko w celu zachowania spójności
    % z interfejsem do FiniteDifference
    i = min_tetr;
    tetras_current = tetras(i, :);
    positions_current = positions(tetras_current, :);
    vertex_current = tetras_current == vertex;
    vertex_current_pos = positions_current(vertex_current, :);
    fixed_vertices = positions_current(~vertex_current, :);


    t = fixed_vertices(1,:) - vertex_current_pos;
    u = fixed_vertices(2,:) - vertex_current_pos;
    v = fixed_vertices(3,:) - vertex_current_pos;
    V = det([t; u; v])/6;
    if V < 0
        fixed_vertices([2,3],:) = fixed_vertices([3,2],:);
        t = fixed_vertices(1,:) - vertex_current_pos;
        u = fixed_vertices(2,:) - vertex_current_pos;
        v = fixed_vertices(3,:) - vertex_current_pos;
        V = det([t; u; v])/6;
    end
    lad = norm(t); 
    lbd = norm(u);
    lcd = norm(v);
    lab = norm(fixed_vertices(1,:) - fixed_vertices(2,:));
    lbc = norm(fixed_vertices(2,:) - fixed_vertices(3,:));
    lac = norm(fixed_vertices(3,:) - fixed_vertices(1,:));

    Lrms = sqrt(sum([lab, lac, lad, lbc, lbd, lcd].^2)/6);

    grad_Lrms = -1/(6*Lrms) * (t + u + v);

    grad_V = cross(u - v,t - v)/6;

    grad = 6*sqrt(2)*(grad_V./(Lrms^3) - (3*V*grad_Lrms)./(Lrms^4));
    
end