addpath('../src')
mesh_folder = 'real structures/';
mesh_name = 'd_Filtr_DDM';
% mesh_name = 'cube_3k_el';
mesh_name_save_ext = 'alg_comparison';
mesh_name_save_ext = '';
save_mesh = 0;
quality_treshold = 1/3;

mesh = load(sprintf('../structures/3D/%s%s.mat',mesh_folder, mesh_name));

tetras = mesh.tetrahedra;
positions = mesh.vertices;
free_nodes = mesh.free_vertices;
surface = mesh.surface;
changed_nodes = [];
initial_qualities = CalcQualityTetraVLrms(tetras, positions);
global_vertices_to_change = free_nodes(rand(length(free_nodes),1) > 0.9);  

for i=1:200
    vertices_to_change = global_vertices_to_change;
%     qualities = CalcQualityTetraVLrms(tetras, positions);
%     good_qualities = qualities > quality_treshold;
%     tets_good_qualities = tetras(good_qualities, :);
% %     tets_to_change = tets_good_qualities;
%     chosen_tets = rand(length(tets_good_qualities), 1) > 0.99;
%     tets_to_change = tets_good_qualities(chosen_tets, :);
%     unique_vertices = unique(tets_to_change(:));
    
    % wybierz te wierzcholki, ktore naleza do zbioru wolnych wierzcholkow
    % wierzcholki niektorych tetow moga byc na powierzchni struktury -
    % pozbywamy sie ich
     
%     vertices_to_change = intersect(unique_vertices, free_nodes);
%     changed_nodes = unique([changed_nodes; vertices_to_change]);
    
%     vertices_to_change = find(rand(length(free_nodes),1) > 0.3);
    a = -0.05;
    b = 0.05;
    inverted_tets = 1;
    prev_positions = positions;
    reset_positions = positions;
    while_it = 0;
    while (any(inverted_tets))
        positions(vertices_to_change,:) = prev_positions(vertices_to_change,:);
%         positions = prev_positions;
        r = a + (b-a).*rand(length(vertices_to_change), 3);
        positions(vertices_to_change, :) = positions(vertices_to_change,:) + r;
        min_quality = min(CalcQualityTetraVLrms(tetras, positions));
        inverted_tets = GetInvertedTetrahedra(tetras, positions);
%         valid_elements = qualities > 0;
%         invalid_tets = setdiff(find(chosen_tets), find(valid_elements));
%         vertices_invalid_tets = unique(tetras(invalid_tets(:)));
%         vertices_to_change = intersect(vertices_invalid_tets, free_nodes);
%         tets_to_change = tetras(invalid_tets);
%         vertices_valid_elements = tets_to_change(valid_elements, :);
%         vertices_valid_elements = unique(vertices_valid_elements(:));
%         vertices_to_change = setdiff(vertices_to_change, vertices_valid_elements);
%         positions(vertices_invalid_tets,:) = prev_positions(vertices_invalid_tets,:);
%         negative_qualities = qualities <= 0;
%         invalid_tets = intersect(find(chosen_tets), find(negative_qualities));
%         invalid_vertices = tetras(invalid_tets,:);
%         vertices_to_change = intersect(invalid_vertices(:), vertices_to_change);
        
        a = a/2;
        b = b/2;
        %dodac wykluczenie quality(wierzcholek) > 0 z kolejnej iteracji
        bad_vertices = [];
        for j=1:length(vertices_to_change)
            adjacent_tetras = GetAdjacentTetras(vertices_to_change(j), tetras);
            inverted_adj_tetras = GetInvertedTetrahedra(adjacent_tetras, positions);
            if (any(inverted_adj_tetras))
                bad_vertices = [bad_vertices; vertices_to_change(j)];
            end
        end
        
        vertices_to_change = bad_vertices;
        while_it = while_it + 1;
%         fprintf("Iteracja while %i)\n", while_it);
        
        % zresetuj iteracje gdy nie ma poprawy
        if (while_it > 10)
            fprintf("RESET\n");
            positions(global_vertices_to_change,:) = reset_positions(global_vertices_to_change,:);
            inverted_tets = 0;

        end
    end
    if mod(i, 10) == 0
        qualities = CalcQualityTetraVLrms(tetras, positions);
        fprintf("Iteracja %i)\n", i);
        fprintf("Liczba elementow o jakosci < %.2f: %i\n", quality_treshold, sum(qualities < quality_treshold));
    end
    
end
qualities = CalcQualityTetraVLrms(tetras, positions);
poor_tetras = qualities < quality_treshold;
fprintf("Liczba elementow: %i\n", length(tetras));
fprintf("Liczba elementow o jakosci < %.2f: %i\n", quality_treshold, sum(poor_tetras));

% figure()
% tetramesh(mesh.tetrahedra, positions, 'facecolor','none');
% hold on
% tetramesh(mesh.tetrahedra(poor_tetras,:), positions, 'facecolor', 'red');
% figure()
DrawQualityGraph(initial_qualities, qualities, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')


fprintf("Liczba zmienionych czworoscianow: %i\n", sum(initial_qualities ~= qualities));

vertices = positions;
free_vertices = free_nodes;
tetrahedra = tetras;

if save_mesh
    changed_vertices = global_vertices_to_change;
    
    save_mesh_name = sprintf('../structures/3D/%sdeformed_%s.mat', ...
        mesh_folder,mesh_name);
    if isfile(save_mesh_name)
        fprintf("Plik %s już istnieje!!!\n", save_mesh_name);
    else
        save(save_mesh_name, 'vertices', 'free_vertices', 'tetrahedra', 'surface', 'changed_vertices')
    end
end

