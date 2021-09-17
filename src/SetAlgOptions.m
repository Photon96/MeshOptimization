function [opts] = SetAlgOptions(config)
    opts.max_sweeps = config.max_sweeps;
    opts.resolution = 1/100; 
    opts.quality_treshold = config.quality_treshold;
    opts.algorithm = config.algorithm;
    opts.grid_points = config.grid_points;
    opts.diagnostics = config.diagnostics;
end

