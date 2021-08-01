function [] = PrintOptimizationInfo(info)
    fprintf("------- Optimization info -------\n")
    fprintf("Algortihm:        %s\n", info.algorithm)
    fprintf("Duration [s]:     %.3f\n", info.duration)
    fprintf("Improved tets:    %i\n", info.improved_tets)
    fprintf("Nodes per s:      %i\n", round(info.nodes_per_sec))
    fprintf("Quality treshold: %.2f\n", info.quality_treshold)
    fprintf("Number of sweeps: %i\n", info.nr_iterations)
end

