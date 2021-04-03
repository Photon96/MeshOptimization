function [positions] = OptimizeMesh(...
    tetras, positions, free_nodes, quality_function_handle, opts)
    
    for k=1:opts.max_k
        
        txt = sprintf("Iteracja nr %u", k)
        global_qualities = quality_function_handle(tetras, positions);
        nodes_optimize = GetNodesToOptimize(...
          free_nodes, tetras, global_qualities, opts.quality_treshold);
        if opts.diagnostics
            found_max_qualities = zeros(length(nodes_optimize),1);
            possible_max_qualities = zeros(length(nodes_optimize),1);
        end
        
        for i=1:length(nodes_optimize)
            adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
            steps = GetSteps(adjacent_tetras, positions, opts.resolution);
            if opts.diagnostics
                [positions, found_max_qualities(i), possible_max_qualities(i)] = ...
                  GradientAscent(adjacent_tetras, positions, ...
                  steps, nodes_optimize(i), quality_function_handle);
            else
               positions = ...
                  GradientAscent(adjacent_tetras, positions, ...
                  steps, nodes_optimize(i), quality_function_handle); 
            end
        end
        
        if opts.diagnostics
            frac_improved = sum(found_max_qualities >= possible_max_qualities)/length(found_max_qualities);
            txt = sprintf("Poprawiono %0.2f%% czworoscianow", frac_improved*100)
        end
    end
    
end

