function [J, H] = FiniteDifferenceTest(vertex, tetras, positions, quality_function_handle)
    
    positions_prev = positions(vertex, :);
    steps = [0.001, 0.001, 0.001];
    
    %%%% JACOBIAN
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
    
    J = [fx; fy; fz];
    
    positions(vertex, :) = positions_prev;
    
    %%% HESSIAN
    if nargout > 1
        f_xyz = min(quality_function_handle(tetras, positions));
        fxx = (f_dx - 2*f_xyz + f_minus_dx)/(steps(1)*2);
        fyy = (f_dy - 2*f_xyz + f_minus_dy)/(steps(2)*2);
        fzz = (f_dz - 2*f_xyz + f_minus_dz)/(steps(3)*2);

        positions(vertex, [1,2]) = positions(vertex, [1,2]) + steps([1,2]);
        f_dxdy = min(quality_function_handle(tetras, positions));
        positions(vertex, :) = positions_prev;
        positions(vertex, [1,2]) = positions(vertex, [1,2]) - steps([1,2]);
        f_minus_dxdy = min(quality_function_handle(tetras, positions));
        positions(vertex, :) = positions_prev;

        fxy = (f_dxdy - f_dx - f_dy + 2*f_xyz - f_minus_dx - f_minus_dy + f_minus_dxdy)/...
            (2*(steps(1)*steps(2)));

        positions(vertex, [2,3]) = positions(vertex, [2,3]) + steps([2,3]);
        f_dydz = min(quality_function_handle(tetras, positions));
        positions(vertex, :) = positions_prev;
        positions(vertex, [2,3]) = positions(vertex, [2,3]) - steps([2,3]);
        f_minus_dydz = min(quality_function_handle(tetras, positions));
        positions(vertex, :) = positions_prev;

        fyz = (f_dydz - f_dy - f_dz + 2*f_xyz - f_minus_dy - f_minus_dz + f_minus_dydz)/...
            (2*(steps(2)*steps(3)));

        positions(vertex, [1,3]) = positions(vertex, [1,3]) + steps([1,3]);
        f_dxdz = min(quality_function_handle(tetras, positions));
        positions(vertex, :) = positions_prev;
        positions(vertex, [1,3]) = positions(vertex, [1,3]) - steps([1,3]);
        f_minus_dxdz = min(quality_function_handle(tetras, positions));
    %     positions(vertex, :) = positions_prev;

        fxz = (f_dxdz - f_dx - f_dz + 2*f_xyz - f_minus_dx - f_minus_dz + f_minus_dxdz)/...
            (2*(steps(1)*steps(3)));

        fyx = fxy;
        fzx = fxz;
        fzy = fyz; 

        H = [fxx fxy fxz;
             fyx fyy fyz;
             fzx fzy fzz];
    end
    
end

