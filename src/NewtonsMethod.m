function [positions] = NewtonsMethod(tetras, positions, steps, v, quality_function_handle)
    
    current_quality = min(quality_function_handle(tetras, positions));
    prev_quality = 0;
    it = 1;
    alfa = steps;

    while (current_quality > prev_quality)
       
        it = it + 1;
        prev_quality = current_quality;
        prev_position = positions(v,:);
        
        J = -FiniteDifference(v, tetras, positions, quality_function_handle);

        fun_value = 1 - prev_quality;

        grad_direction = fun_value\J;
        grad_direction = alfa.*grad_direction;

        new_position = prev_position(:)' - grad_direction;
 
        positions(v,:) = new_position;
        current_quality = min(quality_function_handle(tetras, positions));
    end
    
    if current_quality < prev_quality
        positions(v,:) =  prev_position(:);
    end
    
end

