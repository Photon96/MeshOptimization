function [new_position, current_quality, i] = LineSearch(...
        prev_position, positions, v, tetras, grad_direction, prev_quality, current_quality, quality_metric)
   
%     new_position = prev_position + grad_direction';
%     plot3(new_position(1),new_position(2),new_position(3), 'b.')
    max_iter = 3;
    while current_quality < prev_quality && max_iter >= 0
        grad_direction = grad_direction/2;
        new_position = prev_position + grad_direction';
        positions(v,:) = new_position;
        [current_quality,i] = min(quality_metric(tetras, positions));
        max_iter = max_iter - 1;
    end
end

