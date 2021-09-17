function [nodes, nodes_processed] = GDOptimizeMesh(...
    tetrahedra, nodes, free_nodes, quality_functions_handler, opts)
    
    quality_metric = quality_functions_handler{1};
    nodes_processed = 0;
    for k=1:opts.max_sweeps
       
        fprintf("Iteracja %u)\n", k)
        global_qualities = quality_metric(tetrahedra, nodes);
        nodes_optimize = GetNodesToOptimize(...
          free_nodes, tetrahedra, global_qualities, opts.quality_treshold);

        if opts.diagnostics
            found_max_qualities = zeros(length(nodes_optimize),1);
            possible_max_qualities = zeros(length(nodes_optimize),1);
        end
        
        nodes_processed  = nodes_processed  + length(nodes_optimize);
        for i=1:length(nodes_optimize)
            adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetrahedra);
            steps = GetSteps(adjacent_tetras, nodes, opts.resolution);

            if opts.diagnostics
               [nodes, found_max_qualities(i), possible_max_qualities(i)] = ...
                  GradientAscent(adjacent_tetras, nodes, ...
                    steps, nodes_optimize(i), quality_functions_handler);
            else
               nodes = GradientDescent(adjacent_tetras, nodes, ...
                  steps, nodes_optimize(i), quality_functions_handler); 
            end
        end

        if opts.diagnostics
            frac_improved = sum(found_max_qualities >= possible_max_qualities)/length(found_max_qualities);
            fprintf("Poprawiono %0.2f%% czworoscianow", frac_improved*100)
        end
    end    
end

