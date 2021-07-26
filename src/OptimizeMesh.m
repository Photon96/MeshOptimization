function [mesh, processed_nodes] = OptimizeMesh(...
    mesh, quality_functions_handle, opts)

    positions = mesh.vertices;
    tetras = mesh.tetrahedra;
    free_nodes = mesh.free_vertices;
    quality_metric = quality_functions_handle{1};
    algorithm = opts.algorithm;
    processed_nodes = 0;
    for k=1:opts.max_sweeps
        
%         fprintf("Iteracja %u)\n", k)
        global_qualities = quality_metric(tetras, positions);
        nodes_optimize = GetNodesToOptimize(...
          free_nodes, tetras, global_qualities, opts.quality_treshold);
%         nodes_optimize = 386;
        if opts.diagnostics
            found_max_qualities = zeros(length(nodes_optimize),1);
            possible_max_qualities = zeros(length(nodes_optimize),1);
        end
        processed_nodes = processed_nodes + length(nodes_optimize);
        if strcmp(algorithm, 'GD')
%             nodes_optimize = nodes_optimize(randperm(length(nodes_optimize)));
            for i=1:length(nodes_optimize)
                adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
                steps = GetSteps(adjacent_tetras, positions, opts.resolution);
                if opts.diagnostics
                   [positions, found_max_qualities(i), possible_max_qualities(i)] = ...
                      GradientAscent(adjacent_tetras, positions, ...
                        steps, nodes_optimize(i), quality_functions_handle);
                else
                   positions = GradientAscent(adjacent_tetras, positions, ...
                      steps, nodes_optimize(i), quality_functions_handle); 
                end
            end
        elseif strcmp(algorithm, 'DMO')
                
            for i=1:length(nodes_optimize)
                adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
                positions = DMOOptimizeVertex(adjacent_tetras, positions, nodes_optimize(i),...
                    opts.grid_points, quality_functions_handle);
            end
         end
        
        if opts.diagnostics
            frac_improved = sum(found_max_qualities >= possible_max_qualities)/length(found_max_qualities);
            fprintf("Poprawiono %0.2f%% czworoscianow", frac_improved*100)
        end
    end
    mesh.vertices = positions;
    mesh.tetrahedra = tetras;
end

