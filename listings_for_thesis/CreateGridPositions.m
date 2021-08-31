function [grid] = CreateGridPositions(X, Y, Z, grid_points)
grid = [reshape(X, grid_points^3, 1), reshape(Y, grid_points^3, 1), reshape(Z, grid_points^3, 1)];
end

