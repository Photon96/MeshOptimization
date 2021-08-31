function [mesh] = OptimizeMesh(mesh, functions_handler, opts)
    
    nodes = mesh.vertices;
    tetrahedra = mesh.tetrahedra;
    free_nodes = mesh.free_vertices;
    algorithm = opts.algorithm;
    quality_metric = functions_handler{1};
    
    for k=1:opts.max_sweeps 
        
        global_qualities = quality_metric(tetrahedra, nodes);
        nodes_optimize = GetNodesToOptimize(...
            free_nodes, tetrahedra, global_qualities, opts.quality_treshold);
        
        for i=1:length(nodes_optimize)
            adjacent_tetrahedra = GetAdjacentTetras(nodes_optimize(i), tetrahedra);
            
            if strcmp(algorithm, 'DMO')
       
                nodes = DMOOptimizeVertex(adjacent_tetrahedra, nodes,...
                    nodes_optimize(i), opts.grid_points, quality_metric);
            
            elseif strcmp(algorithm, 'GD')
                
                steps = GetSteps(adjacent_tetrahedra, nodes, opts.resolution);
                nodes = GradientDescent(adjacent_tetrahedra, nodes, ...
                  steps, nodes_optimize(i), functions_handler); 
            
            end
        end
    end
    
    mesh.vertices = nodes;
end