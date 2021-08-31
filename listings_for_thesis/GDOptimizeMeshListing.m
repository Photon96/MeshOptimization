function [nodes, nodes_processed] = GDOptimizeMesh(...
    tetrahedra, nodes, free_nodes, functions_handler, opts)
    
    quality_metric = functions_handler{1};
    nodes_processed = 0;
    
    for k=1:opts.max_sweeps
        
        global_qualities = quality_metric(tetrahedra, nodes);
        nodes_optimize = GetNodesToOptimize(...
          free_nodes, tetrahedra, global_qualities, opts.quality_treshold);
        nodes_processed  = nodes_processed  + length(nodes_optimize);
        
        for i=1:length(nodes_optimize)
            adjacent_tetras = GetAdjacentTetras(...
                nodes_optimize(i), tetrahedra);
            steps = GetSteps(adjacent_tetras, nodes, opts.resolution);
            nodes = GradientDescent(adjacent_tetras, nodes, ...
              steps, nodes_optimize(i), functions_handler); 
        end
    end    
end