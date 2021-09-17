function [mesh, nodes_processed] = OptimizeMesh(...
    mesh, quality_functions_handler, opts)

    nodes = mesh.vertices;
    tetrahedra= mesh.tetrahedra;
    free_nodes = mesh.free_vertices;
    quality_metric = quality_functions_handler{1};
    algorithm = opts.algorithm;
    
    if strcmp(algorithm, 'DMO')
        [nodes, nodes_processed] = DMOOptimizeMesh(...
            tetrahedra, nodes, free_nodes, quality_metric, opts);
    elseif strcmp(algorithm, 'GD')
        [nodes, nodes_processed] = GDOptimizeMesh(...
            tetrahedra, nodes, free_nodes, quality_functions_handler, opts);
    end
    
    mesh.vertices = nodes;
end
    
    

