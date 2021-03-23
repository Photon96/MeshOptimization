function [steps] = GetSteps(tetras, points, resolution)
    %funkcja wyznaczaj?ca minimalne kroki w ka?dym kierunku
    unique_nodes = unique(tetras);
    neighbours = points(unique_nodes, :);
    xmax = max(neighbours(:,1));
    ymax = max(neighbours(:,2));
    zmax = max(neighbours(:,3));

    xmin = min(neighbours(:,1));
    ymin = min(neighbours(:,2));
    zmin = min(neighbours(:,3));
    steps = [(xmax - xmin)*resolution (ymax - ymin)*resolution (zmax - zmin)*resolution];
end

