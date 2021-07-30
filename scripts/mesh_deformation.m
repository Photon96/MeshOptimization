addpath('../src')
mesh_name = 'd_Filtr_DDM.mat';
mesh_name = 'cube_3k_el.mat';
save_mesh = 0;
mesh = load(sprintf('../structures/3D/%s', mesh_name));

quality_treshold = 1/3;
tetras = mesh.tetrahedra;
positions = mesh.vertices;
free_nodes = mesh.free_vertices;
surface = mesh.surface;
% ind_x = (positions(:, 1) == 0 | positions(:, 1) == 1);
% ind_y = (positions(:, 2) == 0 | positions(:, 2) == 1);
% ind_z = (positions(:, 3) == 0 | positions(:, 3) == 1);
% free_nodes = find(~(ind_x | ind_y | ind_z));

positions = mesh.vertices;

for i=1:2000
    qualities = CalcQualityTetraVLrms(tetras, positions);
    good_qualities = qualities > 0.3;
    tets_good_qualities = tetras(good_qualities,:);
    
    chosen_tets = rand(length(tets_good_qualities), 1) > 0.3;
    tets_to_change = tets_good_qualities(chosen_tets, :);
    unique_vertices = unique(tets_to_change(:));
    
    % wybierz te wierzcholki, ktore naleza do zbioru wolnych wierzcholkow
    % wierzcholki niektorych tetow moga byc na powierzchni struktury -
    % pozbywamy sie ich
    vertices_to_change = intersect(unique_vertices, free_nodes);

    a = -0.05;
    b = 0.05;
    min_quality = 0;
    prev_positions = positions(vertices_to_change,:);
    while (min_quality <= 0)
        positions(vertices_to_change,:) = prev_positions(vertices_to_change,:);
        r = a + (b-a).*rand(length(vertices_to_change), 3);
        positions(vertices_to_change, :) = positions(vertices_to_change,:) + r;
        qualities = CalcQualityTetraVLrms(tetras, positions);
        min_quality = min(qualities);

%         valid_elements = qualities > 0;
%         invalid_tets = setdiff(find(chosen_tets), find(valid_elements));
%         vertices_invalid_tets = unique(tetras(invalid_tets(:)));
%         vertices_to_change = intersect(vertices_invalid_tets, free_nodes);
%         tets_to_change = tetras(invalid_tets);
%         vertices_valid_elements = tets_to_change(valid_elements, :);
%         vertices_valid_elements = unique(vertices_valid_elements(:));
%         vertices_to_change = setdiff(vertices_to_change, vertices_valid_elements);
%         positions(vertices_invalid_tets,:) = prev_positions(vertices_invalid_tets,:);
        a = a/2;
        b = b/2;
        
        %dodac wykluczenie quality(wierzcholek) > 0 z kolejnej iteracji

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
DrawQualityHistogram(qualities, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')

vertices = positions;
free_vertices = free_nodes;
tetrahedra = tetras;

if save_mesh
    save_mesh_name = sprintf('../structures/3D/deformed_%s', mesh_name);
    save(save_mesh_name, 'vertices', 'free_vertices', 'tetrahedra', 'surface')
end

