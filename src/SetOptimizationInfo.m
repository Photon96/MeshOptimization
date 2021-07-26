function [info] = SetOptimizationInfo(...
    opts, prev_qualities, current_qualities, processed_nodes, duration)

    info.duration = duration;
    info.processed_nodes = processed_nodes;    
    info.algorithm = opts.algorithm;
    info.quality_treshold = opts.quality_treshold;
    info.nr_iterations = opts.max_sweeps;
    info.improved_tets = sum(prev_qualities < current_qualities) - sum(prev_qualities > current_qualities);
    info.nodes_per_sec = info.processed_nodes/info.duration;
end

