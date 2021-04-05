clear all
addpath('../src')
addpath('../immoptibox')
load('../structures/deformed_cube_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;
quality_treshold = 0.35;

alg_types = 5;
prev_qualities = CalcQualityTetraVLrms(tetras, positions);

for alg_type=1:alg_types
    
    if alg_type == 1
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'dfp', 'Display', 'off', 'MaxIterations', 10);
        infos(alg_type).algorithm = "Quasi-newton with dfp";
    end
    
    if alg_type == 2
        options = optimoptions('fminunc','Algorithm','quasi-newton',...
            'SpecifyObjectiveGradient', true, 'HessUpdate', 'steepdesc', 'Display', 'off', 'MaxIterations', 10);
        infos(alg_type).algorithm = "Quasi-newton with steepdesc";
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
        infos(alg_type).algorithm = "Dump newton";
    end
    
    if alg_type == 5
        opts.max_k = 1;
        opts.quality_treshold = quality_treshold;
        opts.resolution = 0.01;
        opts.diagnostics = false;
        infos(alg_type).algorithm = "Gradient ascent";
    end
    
    infos(alg_type).prev_min_quality = ...
        min(CalcQualityTetraVLrms(tetras, positions));
    infos(alg_type).prev_mean_quality = ...
        mean(CalcQualityTetraVLrms(tetras, positions));
    infos(alg_type).prev_tetras_worse_treshold = ...
        sum(CalcQualityTetraVLrms(tetras, positions) < quality_treshold);
    
    if (alg_type >=0) && (alg_type <= 4) 
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
            elseif alg_type ~= 5
                f = @(x)FunctionMetric(x, node, adjacent_tetras, positions);
                x = fminunc(f,x0,options);
            end

            positions(node, :) = x;
        end
        duration = toc;
    end
    
    if alg_type == 5
        tic
        positions = OptimizeMesh(tetras, positions,...
              free_nodes, @CalcQualityTetraVLrms, opts);
        duration = toc;
    end
    
    infos(alg_type).current_min_quality = ...
        min(CalcQualityTetraVLrms(tetras, positions));
    infos(alg_type).current_mean_quality = ...
        mean(CalcQualityTetraVLrms(tetras, positions));
    infos(alg_type).current_tetras_worse_treshold = ...
        sum(CalcQualityTetraVLrms(tetras, positions) < quality_treshold);
    infos(alg_type).duration = duration;
    
    positions = mesh.positions;
end

for i=1:alg_types
    infos(i)
end





% figure(1);
% DrawQualityGraph(prev_qualities1, current_qualities1, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$');
