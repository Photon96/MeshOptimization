function [positions, possible_max_quality, found_max_quality] = ...
    GradientAscent(tetras, positions, steps, v, quality_function_handle)
    
    [current_quality, i] = min(quality_function_handle(tetras, positions));
    prev_quality = 0;

    alfa = steps';
%     prev_qualities = quality_function_handle(tetras, positions);
    while (current_quality > prev_quality)
       
        prev_quality = current_quality;
        prev_position = positions(v,:);
        
%         J = FiniteDifference(v, tetras, positions, quality_function_handle);
          J = VLrmsGradient(v, tetras, positions, i);
%         J = FDAllElements(v, tetras, positions, quality_function_handle);
%         J = J(:, current_i);
%         J = J(:, i);
%         H = H((current_i - 1)*3 + 1:(current_i - 1)*3 + 3,:);
        %%% Newton method using Jacobian and Hessian
%         if all(eig(H) > 0) 
%            grad_direction = (H\J);
%         else
%            grad_direction = -J;
%         end
        grad_direction = J;

        grad_direction = alfa.*grad_direction;

        new_position = prev_position + grad_direction';
 
        positions(v,:) = new_position;
        [current_quality, i] = min(quality_function_handle(tetras, positions));
    end
    
    if current_quality < prev_quality
        positions(v,:) =  prev_position;
    end
    
    if nargout > 1
        [~, ~, ~, values] = Get3DGridValues(tetras, positions, v, quality_function_handle);
        possible_max_quality = max(values);
        found_max_quality = max(current_quality, prev_quality);
    end
%     figure(1)
%     DisplayChangeOfQuality(prev_qualities, quality_function_handle(tetras, positions));
%     figure(2)
%     Draw3DGridValues(X, Y, Z, values)
end

