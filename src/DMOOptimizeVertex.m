function [pos] = DMOOptimizeVertex(tetras, pos, v, grid_points, quality_functions_handle)
    
    quality_metric = quality_functions_handle{1};
    center_point = pos(v, :);
    unique_nodes = unique(tetras);
    max_pos = pos(v, :);
    max_quality = min(quality_metric(tetras, pos));

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
        [x_values, y_values, z_values] = GetGrid(pos(unique_nodes, :), grid_points, center_point, omega);
        [X, Y, Z] = ndgrid(x_values, y_values, z_values);
        grid_positions = [reshape(X, grid_points^3, 1), reshape(Y, grid_points^3, 1), reshape(Z, grid_points^3, 1)];
%         figure()
%         tetramesh(tetras, pos, 'facecolor', 'none')
%         hold on
%         plot3(grid_positions(:,1),grid_positions(:,2), grid_positions(:,3), 'r.','markersize', 15)
%         plot3(pos(v,1), pos(v,2), pos(v,3), 'b.', 'markersize', 20)
        for i=1:length(grid_positions)
            pos(v,:) = grid_positions(i,:);
            tmp_max_quality = min(quality_metric(tetras, pos));

            if tmp_max_quality > max_quality
                max_quality = tmp_max_quality;
                max_pos = pos(v,:);
            end

        end
%         stem3(max_pos(1),max_pos(2), max_pos(3), 'r*','LineStyle','none')
%         hold off
        omega = 2*omega/7;
        pos(v,:) = max_pos;
        center_point = max_pos;
%         plot3(pos(v,1), pos(v,2), pos(v,3), 'g.', 'markersize', 20)
    end
%     pos(v,:) = max_pos;
%     tetramesh(tetras, pos)
%     title("Po")
%     txt = sprintf("Jakosc po optymalizacji %f\n", max_quality)
end

