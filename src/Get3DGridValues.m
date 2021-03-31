function [X, Y, Z, values] = Get3DGridValues(...
    tetras, positions, node_optimize, quality_function_handle)
    nr_points = 20;
    x = linspace(min(positions(tetras, 1)), max(positions(tetras, 1)), nr_points);
    y = linspace(min(positions(tetras, 2)), max(positions(tetras, 2)), nr_points);
    z = linspace(min(positions(tetras, 3)), max(positions(tetras, 3)), nr_points);
    [X,Y,Z] = meshgrid(x,y,z);
    coords = [X(:) Y(:) Z(:)];
    values = zeros(nr_points^3, 1);
    tmp_positions = positions;
    for j=1:length(coords)
        tmp_positions(node_optimize,:) = coords(j,:);
        values(j) = min(quality_function_handle(tetras, tmp_positions));
    end
    
end

