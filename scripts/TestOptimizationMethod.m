function [info, positions] = TestOptimizationMethod(method, positions, tetras, free_nodes,...
        quality_function_handle, quality_treshold)
    
    info.algorithm = method;
    info.prev_min_quality = ...
        min(quality_function_handle(tetras, positions));
    info.prev_tetras_worse_treshold = ...
        sum(quality_function_handle(tetras, positions) < quality_treshold);
    
    global_qualities = quality_function_handle(tetras, positions);
    nodes_optimize = GetNodesToOptimize(...
      free_nodes, tetras, global_qualities, quality_treshold);
  
    if strcmp(method, "DFP")
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'dfp', 'Display', 'off', 'MaxIterations', 1);
        tic
        positions = FminuncOptimization(options, positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Steepest descent")
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'steepdesc', 'Display', 'off', 'MaxIterations', 1);
        tic
        positions = FminuncOptimization(options,  positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Trust-Region")
        options = optimoptions('fminunc','Algorithm','trust-region',...
            'SpecifyObjectiveGradient', true, 'Display', 'off','HessianFcn', 'objective', 'MaxIterations', 10);
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
    
    if strcmp(method, "fminunc: BFGS")
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'bfgs', 'Display', 'off', 'MaxIterations', 1, 'MaxFunctionEvaluations', 5);
        tic
        positions = FminuncOptimization(options, positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Nonlinear Conjugate Gradient")
        params = ncg('defaults');
        params.Display = "off";
        params.MaxIters = 1;
        params.RestartIters = 5;
        params.Update = 'PR'; 
        
        tic
        positions = PoblanoOptimization(params, positions, tetras,...
            free_nodes, quality_treshold, quality_function_handle);
        duration = toc;
    end
    
    if strcmp(method, "Gradient descent")
        opts.max_k = 1;
        opts.quality_treshold = quality_treshold;
        opts.resolution = 0.01;
        opts.diagnostics = false;
        
        tic
        positions = OptimizeMesh(tetras, positions,...
              free_nodes, @CalcQualityTetraVLrms, opts);
        duration = toc;
    end
    
    info.duration = duration;
    global_qualities = quality_function_handle(tetras, positions);
    nodes_optimize_curr = GetNodesToOptimize(...
        free_nodes, tetras, global_qualities, quality_treshold);
    
    info.current_min_quality = ...
        min(global_qualities);
    info.current_tetras_worse_treshold = ...
        sum(global_qualities < quality_treshold);
    info.duration = duration;
    info.improved_tetras = info.prev_tetras_worse_treshold - info.current_tetras_worse_treshold;
    info.nodes_per_sec = round((length(nodes_optimize) - length(nodes_optimize_curr) )/duration); 
    
   
%     else
%         tic
%         global_qualities = CalcQualityTetraVLrms(tetras, positions);
%         nodes_optimize = GetNodesToOptimize(...
%           free_nodes, tetras, global_qualities, quality_treshold);
% 
%         for i=1:length(nodes_optimize)
%             adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
%             node = nodes_optimize(i);
%             x0 = positions(node, :);
%             
%             if strcmp(method, "DFP") || strcmp(method, "Steepest descent") || strcmp(method, "Trust-Region") 
%                 f = @(x)FunctionMetric(x, node, adjacent_tetras, positions);
%                 x = fminunc(f,x0,options);
%             if alg_type == 4
%                 X1 = dampnewton(@FunctionMetric,x0, options,...
%                     node, adjacent_tetras, positions);
%                 x = X1(:, end);
%             elseif alg_type == 5
%                 X1 = ucminf(@FunctionMetric,x0,[],[],...
%                     node, adjacent_tetras, positions);
%                 x = X1(:, end);
%             elseif alg_type == 7
%                 f = @(x)FunctionMetricPoblano(x, node, adjacent_tetras, positions);    
%                 out = ncg(f, x0', params);
%                 x = out.X';
% 
%             else
%                 
%                 
%             end
% 
%             positions(node, :) = x;
%         end
%         duration = toc;
%     end
    
end

