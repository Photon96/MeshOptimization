if strcmp(algorithm, "BFGS")
    options = optimoptions('fminunc','Algorithm','quasi-newton',...
        'SpecifyObjectiveGradient', true, 'HessUpdate', 'bfgs',...
        'Display', 'off', 'MaxIterations', 5);
    positions = FminuncOptimization(tetrahedra, nodes, ...
        optimized_node, functions_handler, options);
end


function [nodes] = FminuncOptimization(tetrahedra, nodes, ...
    optimized_node, functions_handler, options)
  
    starting_pos = nodes(optimized_node, :);
    f = @(x)FunctionMetric(x, optimized_node, tetrahedra, nodes, functions_handler);
    new_pos = fminunc(f,starting_pos,options);
    nodes(optimized_node, :) = new_pos;
  
end
