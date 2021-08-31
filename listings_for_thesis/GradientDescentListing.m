function [nodes] = GradientDescent(...
    tetrahedra, nodes, alpha, optimized_vertex, functions_handler)
    
    quality_metric = functions_handler{1};
    quality_metric_gradient = functions_handler{2};
    [current_quality, current_min_node] = min(quality_metric(tetrahedra, nodes));
    prev_quality = 0;

    while (current_quality > prev_quality)
       
        prev_quality = current_quality;
        prev_position = nodes(optimized_vertex, :);
        J = quality_metric_gradient(optimized_vertex,...
            tetrahedra, nodes, current_min_node, quality_metric);
        grad_direction = alpha.*J;
        new_position = prev_position + grad_direction;
        nodes(optimized_vertex,:) = new_position;
        [current_quality, current_min_node] = min(quality_metric(tetrahedra, nodes));
        
        if current_quality < 1/3 && current_quality < prev_quality
            nodes(optimized_vertex,:) = prev_position;
            [new_position, current_quality, current_min_node] = LineSearch(...
                tetrahedra, nodes, grad_direction, optimized_vertex, prev_quality, quality_metric);
        end
        
        nodes(optimized_vertex,:) = new_position;
    end
    
    if current_quality < prev_quality
        nodes(optimized_vertex,:) =  prev_position;
    end
    
end