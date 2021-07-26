function [positions, possible_max_quality, found_max_quality] = ...
    GradientAscent(tetras, positions, steps, v, quality_functions_handlers)
    
    quality_metric = quality_functions_handlers{1};
    quality_metric_gradient = quality_functions_handlers{2};
    [current_quality, i] = min(quality_metric(tetras, positions));
    prev_quality = 0;

    alfa = steps';
%     prev_qualities = quality_function_handle(tetras, positions);
    while (current_quality > prev_quality)
       
        prev_quality = current_quality;
        prev_position = positions(v,:);
%         figure()
%         tetramesh(tetras, positions, 'facecolor', 'none')
%         hold on
%         plot3(prev_position(1),prev_position(2),prev_position(3), 'r.')
%           [J,H] = FiniteDifference(v, tetras, positions, quality_function_handle);
        J = quality_metric_gradient(v, tetras, positions, i, quality_metric);
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

%         new_position = prev_position + grad_direction';
%         plot3(new_position(1),new_position(2),new_position(3), 'b.')
%         positions(v,:) = new_position;
%         [current_quality, i] = min(quality_metric(tetras, positions));
%         while current_quality > 0 | sum(grad_direction) > eps
%             grad_direction = grad_direction/2;
%             new_position = prev_position + grad_direction';
%             positions(v,:) = new_position;
%             [current_quality, i] = min(quality_metric(tetras, positions));
%         end
        step = grad_direction;
        new_position = prev_position + step';
        positions(v,:) = new_position;
        [current_quality,i] = min(quality_metric(tetras, positions));
        if current_quality < 1/3 && current_quality < prev_quality
            [new_position, current_quality, i] = LineSearch(prev_position, positions, v, tetras, grad_direction, prev_quality, current_quality, quality_metric);
        end
        positions(v,:) = new_position;
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

