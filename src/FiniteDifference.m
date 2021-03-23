function [J] = FiniteDifference(vertex, tetras, positions, quality_function_handle)
    
    positions_prev = positions(vertex, :);
    steps = [0.01, 0.01, 0.01];
    
    positions(vertex, 1) = positions(vertex, 1) + steps(1);
    f_dx = min(quality_function_handle(tetras, positions));
    positions(vertex, 1) = positions(vertex, 1) - 2*steps(1);
    f_minus_dx = min(quality_function_handle(tetras, positions));
    fx = (f_dx - f_minus_dx)/(2*steps(1));
    
    positions(vertex, :) = positions_prev;
    
    positions(vertex, 2) = positions(vertex, 2) + steps(2);
    f_dy = min(quality_function_handle(tetras, positions));
    positions(vertex, 2) = positions(vertex, 2) - 2*steps(2);
    f_minus_dy = min(quality_function_handle(tetras, positions));
    fy = (f_dy - f_minus_dy)/(2*steps(2));
    
    positions(vertex, :) = positions_prev;
    
    positions(vertex, 3) = positions(vertex, 3) + steps(3);
    f_dz = min(quality_function_handle(tetras, positions));
    positions(vertex, 3) = positions(vertex, 3) - 2*steps(3);
    f_minus_dz = min(quality_function_handle(tetras, positions));
    fz = (f_dz - f_minus_dz)/(2*steps(3));
    
    J = [fx, fy, fz];
    
end

