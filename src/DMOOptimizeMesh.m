function [nodes, nodes_processed] = DMOOptimizeMesh(...
    tetrahedra, nodes, free_nodes, quality_metric, opts)
    
    nodes_processed = 0;
    
    for k=1:opts.max_sweeps   
        fprintf("Iteracja %u)\n", k)
        global_qualities = quality_metric(tetrahedra, nodes);
        nodes_optimize = GetNodesToOptimize(...
            free_nodes, tetrahedra, global_qualities, opts.quality_treshold);
        nodes_processed = nodes_processed + length(nodes_optimize);
        
        if opts.diagnostics
            found_max_qualities = zeros(length(nodes_optimize),1);
            possible_max_qualities = zeros(length(nodes_optimize),1);
        end
        
        for i=1:length(nodes_optimize)
            adjacent_tetrahedra = GetAdjacentTetras(nodes_optimize(i), tetrahedra);
            [nodes] = DMOOptimizeVertex(adjacent_tetrahedra, nodes,...
                nodes_optimize(i), opts.grid_points, quality_metric);
        end
        
        if opts.diagnostics
            frac_improved = sum(...
                found_max_qualities >= possible_max_qualities)/length(found_max_qualities);
            fprintf("Poprawiono %0.2f%% czworoscianow\n", frac_improved*100)
        end
    end
end

