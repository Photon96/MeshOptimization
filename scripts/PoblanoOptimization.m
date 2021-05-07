function [positions] = PoblanoOptimization(params, positions, tetras,...
        free_nodes, quality_treshold, quality_function_handle)
    
    global_qualities = quality_function_handle(tetras, positions);
    nodes_optimize = GetNodesToOptimize(...
      free_nodes, tetras, global_qualities, quality_treshold);

    for i=1:length(nodes_optimize)
        adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
        node = nodes_optimize(i);
        x0 = positions(node, :);

        f = @(x)FunctionMetricPoblano(x, node, adjacent_tetras, positions, quality_function_handle);    
        out = ncg(f, x0', params);
        x = out.X';

        positions(node, :) = x;
    end
    
end
