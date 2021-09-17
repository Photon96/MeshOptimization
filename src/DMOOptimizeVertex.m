function [vertices] = DMOOptimizeVertex(...
    tetrahedra, vertices, vertex_optimized, grid_points, quality_metric)
    
    center_point = vertices(vertex_optimized, :);
    unique_nodes = unique(tetrahedra);
    max_pos = vertices(vertex_optimized, :);
    max_quality = min(quality_metric(tetrahedra, vertices));
    
    omega = 0.25;
    if max_quality < 1/3
        nr_of_iter = 3;
    elseif max_quality < 2/3
        nr_of_iter = 2;
        omega = omega/2;
    else
        nr_of_iter = 1;
        omega = omega/4;
    end
    for iter=1:nr_of_iter
        
        [x_values, y_values, z_values] = GetGrid(vertices(unique_nodes, :), grid_points, center_point, omega);
        [X, Y, Z] = ndgrid(x_values, y_values, z_values);
        grid_positions = [reshape(X, grid_points^3, 1), reshape(Y, grid_points^3, 1), reshape(Z, grid_points^3, 1)];
       
        for i=1:length(grid_positions)
            vertices(vertex_optimized,:) = grid_positions(i,:);
            tmp_max_quality = min(quality_metric(tetrahedra, vertices));

            if tmp_max_quality > max_quality
                max_quality = tmp_max_quality;
                max_pos = vertices(vertex_optimized,:);
            end

        end
        omega = omega/2;
        vertices(vertex_optimized,:) = max_pos;
        center_point = max_pos;
    end
end

