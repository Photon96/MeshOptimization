function [x_values, y_values, z_values] = GetGrid(neighbours, grid_points, center_point, omega)
    xmax = max(neighbours(:,1));
    ymax = max(neighbours(:,2));
    zmax = max(neighbours(:,3));
    
    xmin = min(neighbours(:,1));
    ymin = min(neighbours(:,2));
    zmin = min(neighbours(:,3));
    
    x_length = (xmax - xmin)/2;
    y_length = (ymax - ymin)/2;
    z_length = (zmax - zmin)/2;
    
    %dx = (x_length - x_length*omega)/2;
    %dy = (y_length - y_length*omega)/2;
    
    x_start = center_point(1) - x_length*omega;
    x_stop = center_point(1) + x_length*omega;
    y_start = center_point(2) - y_length*omega;
    y_stop = center_point(2) + y_length*omega;
    z_start = center_point(3) + z_length*omega;
    z_stop = center_point(3) - z_length*omega;
    
    x_values = linspace(x_start, x_stop, grid_points);
    y_values = linspace(y_start, y_stop, grid_points);
    z_values = linspace(z_start, z_stop, grid_points);
end

