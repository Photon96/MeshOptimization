clear all
addpath('../src')
addpath('../immoptibox')
load('../structures/deformed_cube_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;
quality_treshold = 0.35;

alg_types = 7;
prev_qualities = CalcQualityTetraVLrms(tetras, positions);

for alg_type=1:alg_types
    
    if alg_type == 1
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'dfp', 'Display', 'off', 'MaxIterations', 10);
        infos(alg_type).algorithm = "Quasi-Newton with dfp";
    end
    
    if alg_type == 2
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'steepdesc', 'Display', 'off', 'MaxIterations', 10);
        infos(alg_type).algorithm = "Quasi-Newton with steepdesc";
    end
    
    if alg_type == 3
        options = optimoptions('fminunc','Algorithm','trust-region',...
            'SpecifyObjectiveGradient', true, 'Display', 'off','HessianFcn', 'objective', 'MaxIterations', 10);
        infos(alg_type).algorithm = "Trust-region";
    end
    
    if alg_type == 4
        tau = 1e-3;
        tolg = 1e-4;
        tolx = 1e-8;
        maxeval = 10;
        options = [tau tolg tolx maxeval];
        infos(alg_type).algorithm = "Damp newton";
    end
    
    if alg_type == 5
        infos(alg_type).algorithm = "ucminf: Quasi-Newton with BFGS";
    end
    
    if alg_type == 6
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'bfgs', 'Display', 'off', 'MaxIterations', 10);
        infos(alg_type).algorithm = "fminunc: Quasi-Newton with BFGS";
    end
    
    if alg_type == 7
        opts.max_k = 1;
        opts.quality_treshold = quality_treshold;
        opts.resolution = 0.01;
        opts.diagnostics = false;
        infos(alg_type).algorithm = "Gradient ascent";
    end
    
    infos(alg_type).prev_min_quality = ...
        min(CalcQualityTetraVLrms(tetras, positions));
    infos(alg_type).prev_tetras_worse_treshold = ...
        sum(CalcQualityTetraVLrms(tetras, positions) < quality_treshold);
    
    if (alg_type >=0) && (alg_type <= 6) 
        tic
        global_qualities = CalcQualityTetraVLrms(tetras, positions);
        nodes_optimize = GetNodesToOptimize(...
          free_nodes, tetras, global_qualities, quality_treshold);

        for i=1:length(nodes_optimize)
            adjacent_tetras = GetAdjacentTetras(nodes_optimize(i), tetras);
            node = nodes_optimize(i);
            x0 = positions(node, :);

            if alg_type == 4
                X1 = dampnewton(@FunctionMetric,x0, options,...
                    node, adjacent_tetras, positions);
                x = X1(:, end);
            elseif alg_type == 5
                X1 = ucminf(@FunctionMetric,x0,[],[],...
                    node, adjacent_tetras, positions);
                x = X1(:, end);
            else
                f = @(x)FunctionMetric(x, node, adjacent_tetras, positions);
                x = fminunc(f,x0,options);
                
            end

            positions(node, :) = x;
        end
        duration = toc;
    end
    
    if alg_type == 7
        tic
        positions = OptimizeMesh(tetras, positions,...
              free_nodes, @CalcQualityTetraVLrms, opts);
        duration = toc;
    end
    
    global_qualities = CalcQualityTetraVLrms(tetras, positions);
    nodes_optimize_curr = GetNodesToOptimize(...
        free_nodes, tetras, global_qualities, quality_treshold);
    
    infos(alg_type).current_min_quality = ...
        min(global_qualities);
    infos(alg_type).current_tetras_worse_treshold = ...
        sum(global_qualities < quality_treshold);
    infos(alg_type).duration = duration;
    infos(alg_type).improved_tetras = ....
        infos(alg_type).prev_tetras_worse_treshold - infos(alg_type).current_tetras_worse_treshold;
    infos(alg_type).nodes_per_sec = round((length(nodes_optimize) - length(nodes_optimize_curr) )/duration); 
    
    positions = mesh.positions;
end

for i=1:alg_types
    infos(i)
end

