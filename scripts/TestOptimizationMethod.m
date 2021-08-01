function [info, positions] = TestOptimizationMethod(method, positions, tetras, free_nodes,...
        quality_function_handle, quality_treshold)
    
    info.algorithm = method;
%     info.prev_min_quality = ...
%         min(quality_function_handle(tetras, positions));
    prev_tetras_worse_treshold = ...
         sum(quality_function_handle(tetras, positions) < 1/3);
    
    global_qualities = quality_function_handle(tetras, positions);
    prev_qualities = global_qualities;
    nodes_optimize = GetNodesToOptimize(...
      free_nodes, tetras, global_qualities, quality_treshold);
  
    
    if strcmp(method, "DFP")
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'dfp',...
            'Display', 'off', 'MaxIterations', 5);
        tic
        positions = FminuncOptimization(options, positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Steepest descent")
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'steepdesc',...
            'Display', 'off', 'MaxIterations', 5);
        tic
        positions = FminuncOptimization(options,  positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Trust-Region")
        options = optimoptions('fminunc','Algorithm','trust-region',...
            'SpecifyObjectiveGradient', true, 'Display', ...
            'off','HessianFcn', 'objective', 'MaxIterations', 5);
        tic
        positions = FminuncOptimization(options,  positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Damped Newton")
        tau = 1e-3;
        tolg = 1e-4;
        tolx = 1e-8;
        maxeval = 100;
        options = [tau tolg tolx maxeval];
        tic
        positions = DampedNewtonOptimization(options,  positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "ucminf: BFGS")
        tic
        positions = UcminfOptimization(positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "BFGS")
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'bfgs',...
            'Display', 'off', 'MaxIterations', 5);
        tic        
        positions = FminuncOptimization(options, positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Nonlinear Conjugate Gradient")
        params = ncg('defaults');
        params.Display = "off";
        params.MaxIters = 5;
        params.RestartIters = 5;
        params.Update = 'PR'; 
        
        tic
        positions = PoblanoOptimization(params, positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Gradient descent")
        opts.max_sweeps = 1;
        opts.quality_treshold = quality_treshold;
        opts.resolution = 0.01;
        opts.diagnostics = false;
        mesh.tetrahedra = tetras;
        mesh.vertices = positions;
        mesh.free_vertices = free_nodes;
        quality_functions{1} = @CalcQualityTetraVLrms;
        quality_functions{2} = @VLrmsGradient;
        opts.algorithm = 'GD';
        tic
        
        mesh = OptimizeMesh(mesh,quality_functions, opts);
        
        duration = toc;
        positions = mesh.vertices;
    end
    
%     info.duration = duration;
    global_qualities = quality_function_handle(tetras, positions);
%     nodes_optimize_curr = GetNodesToOptimize(...
%         free_nodes, tetras, global_qualities, quality_treshold);
%     
    info.current_min_quality = ...
        min(global_qualities);
    current_tetras_worse_treshold = sum(global_qualities < 1/3);
    info.duration = duration;
    current_qualities = global_qualities;
    info.improved_tets = sum(current_qualities > prev_qualities) - sum(current_qualities < prev_qualities);
    info.nr_iterations = 1;
    info.nodes_per_sec = length(nodes_optimize)/info.duration;
    info.quality_treshold = quality_treshold;
    info.prev_tetras_worse_treshold = prev_tetras_worse_treshold;
    info.current_tetras_worse_treshold = current_tetras_worse_treshold;
    info.poor_tets = sum(current_qualities < 1/3);
    %     info.nodes_per_sec = round((length(nodes_optimize) - length(nodes_optimize_curr) )/duration); 
end

