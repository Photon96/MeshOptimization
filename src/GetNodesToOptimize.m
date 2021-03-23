function [nodes_optimize] = GetNodesToOptimize(free_nodes,tetras, global_qualities, quality_treshold)
    nodes_optimize = free_nodes(ismember(free_nodes,unique(tetras(global_qualities < quality_treshold, :))));
end

