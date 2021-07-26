function [adjacent_tetras] = GetAdjacentTetras(free_node, tetras)
    %works also for adjacent triangles
    adjacent_tetras = tetras(any(tetras == free_node, 2), :);
end

