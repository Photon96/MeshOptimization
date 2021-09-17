function [positions] = FminuncOptimization(options, positions, tetras,...
    free_nodes, quality_treshold, quality_metric)
   
    
    global_qualities = quality_metric(tetras, positions);
    nodes_optimize = GetNodesToOptimize(...
      free_nodes, tetras, global_qualities, quality_treshold);
    for i=1:length(nodes_optimize)
        adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
        node = nodes_optimize(i);
        x0 = positions(node, :);

        f = @(x)FunctionMetric(x, node, adjacent_tetras, positions, quality_metric);
        x = fminunc(f,x0,options);
        positions(node, :) = x;
    end
    
end

