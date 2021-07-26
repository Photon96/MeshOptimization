function [positions] = FminuncOptimization(options, positions, tetras,...
    free_nodes, quality_treshold, quality_function_handle)
   
    
    global_qualities = quality_function_handle(tetras, positions);
    nodes_optimize = GetNodesToOptimize(...
      free_nodes, tetras, global_qualities, quality_treshold);
    funcCount = 0;
    for i=1:length(nodes_optimize)
        adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
        node = nodes_optimize(i);
        x0 = positions(node, :);

        f = @(x)FunctionMetric(x, node, adjacent_tetras, positions, quality_function_handle);
        [x,~,~,output] = fminunc(f,x0,options);
        funcCount = funcCount + output.funcCount;
        positions(node, :) = x;
    end
    funcCount
    
end

