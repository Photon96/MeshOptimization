function [adjacent_tetras] = GetAdjacentTetras(free_nodes, tetras)
    adjacent_tetras = tetras(any(tetras == free_nodes, 2), :);
end

