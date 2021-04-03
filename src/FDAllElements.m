function [J, H] = FDAllElements(vertex, tetras, positions, quality_function_handle)
    
    positions_prev = positions(vertex, :);
    steps = [0.01, 0.01, 0.01];
    
    %%%% JACOBIAN
    positions(vertex, 1) = positions(vertex, 1) + steps(1);
    f_dx = quality_function_handle(tetras, positions);
    positions(vertex, 1) = positions(vertex, 1) - 2*steps(1);
    f_minus_dx = quality_function_handle(tetras, positions);
    fx = (f_dx - f_minus_dx)/(2*steps(1));
    
    positions(vertex, :) = positions_prev;
    
    positions(vertex, 2) = positions(vertex, 2) + steps(2);
    f_dy = quality_function_handle(tetras, positions);
    positions(vertex, 2) = positions(vertex, 2) - 2*steps(2);
    f_minus_dy = quality_function_handle(tetras, positions);
    fy = (f_dy - f_minus_dy)/(2*steps(2));
    
    positions(vertex, :) = positions_prev;
    
    positions(vertex, 3) = positions(vertex, 3) + steps(3);
    f_dz = quality_function_handle(tetras, positions);
    positions(vertex, 3) = positions(vertex, 3) - 2*steps(3);
    f_minus_dz = quality_function_handle(tetras, positions);
    fz = (f_dz - f_minus_dz)/(2*steps(3));
    
    J = [fx'; fy'; fz'];
    
    if nargout > 1
        positions(vertex, :) = positions_prev;
        %%% HESSIAN
        f_xyz = quality_function_handle(tetras, positions);
        fxx = (f_dx - 2*f_xyz + f_minus_dx)/(steps(1)*2);
        fyy = (f_dy - 2*f_xyz + f_minus_dy)/(steps(2)*2);
        fzz = (f_dz - 2*f_xyz + f_minus_dz)/(steps(3)*2);

        positions(vertex, [1,2]) = positions(vertex, [1,2]) + steps([1,2]);
        f_dxdy = quality_function_handle(tetras, positions);
        positions(vertex, :) = positions_prev;
        positions(vertex, [1,2]) = positions(vertex, [1,2]) - steps([1,2]);
        f_minus_dxdy = quality_function_handle(tetras, positions);
        positions(vertex, :) = positions_prev;

        fxy = (f_dxdy - f_dx - f_dy + 2*f_xyz - f_minus_dx - f_minus_dy + f_minus_dxdy)/...
            (2*(steps(1)*steps(2)));

        positions(vertex, [2,3]) = positions(vertex, [2,3]) + steps([2,3]);
        f_dydz = quality_function_handle(tetras, positions);
        positions(vertex, :) = positions_prev;
        positions(vertex, [2,3]) = positions(vertex, [2,3]) - steps([2,3]);
        f_minus_dydz = quality_function_handle(tetras, positions);
        positions(vertex, :) = positions_prev;

        fyz = (f_dydz - f_dy - f_dz + 2*f_xyz - f_minus_dy - f_minus_dz + f_minus_dydz)/...
            (2*(steps(2)*steps(3)));

        positions(vertex, [1,3]) = positions(vertex, [1,3]) + steps([1,3]);
        f_dxdz = quality_function_handle(tetras, positions);
        positions(vertex, :) = positions_prev;
        positions(vertex, [1,3]) = positions(vertex, [1,3]) - steps([1,3]);
        f_minus_dxdz = quality_function_handle(tetras, positions);
    %     positions(vertex, :) = positions_prev;

        fxz = (f_dxdz - f_dx - f_dz + 2*f_xyz - f_minus_dx - f_minus_dz + f_minus_dxdz)/...
            (2*(steps(1)*steps(3)));

        fyx = fxy;
        fzx = fxz;
        fzy = fyz; 
        H = zeros(3*length(tetras),3);
        H(1:3:end, :) = [fxx fxy fxz];
        H(2:3:end, :) = [fyx fyy fyz];
        H(3:3:end, :) = [fzx fzy fzz];
%         H = [fxx fxy fxz;
%              fyx fyy fyz;
%              fzx fzy fzz];
    end
    
end

