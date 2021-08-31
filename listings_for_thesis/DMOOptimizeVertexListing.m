function [nodes] = DMOOptimizeVertex(...
    tetrahedra, nodes, node_optimized, grid_points, quality_metric)
    
    center_point = nodes(node_optimized, :);
    unique_nodes = unique(tetrahedra);
    max_pos = nodes(node_optimized, :);
    max_quality = min(quality_metric(tetrahedra, nodes));

    omega = 0.25;
    if max_quality < 1/3
        nr_of_iter = 3;
    elseif max_quality < 2/3
        nr_of_iter = 2;
        omega = 2*omega/7;
    else
        nr_of_iter = 1;
        omega = 2*(2*omega/7)^2;
    end
    
    for iter=1:nr_of_iter
        
        [x_values, y_values, z_values] = GetGrid(...
            nodes(unique_nodes, :), grid_points, center_point, omega);
        [X, Y, Z] = ndgrid(x_values, y_values, z_values);
        grid_positions = CreateGridPositions(X, Y, Z, grid_points);
       
        for i=1:length(grid_positions)
            nodes(node_optimized,:) = grid_positions(i,:);
            tmp_max_quality = min(quality_metric(tetrahedra, nodes));

            if tmp_max_quality > max_quality
                max_quality = tmp_max_quality;
                max_pos = nodes(node_optimized,:);
            end

        end
        omega = 2*omega/7;
        nodes(node_optimized,:) = max_pos;
        center_point = max_pos;
    end
end