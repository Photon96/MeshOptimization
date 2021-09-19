clear all
clear off
addpath('../src')

% user config
config_file = "../configs/eksperyment_Filtr_DDM_morphing.json";
config = ReadConfig(config_file);

quality_metric_name = config.quality_metric;

alg_options = SetAlgOptions(config);

if isfield(config, 'mesh_save')
    save_optimized_mesh = true;
else
    save_optimized_mesh = false;
end

mean_ratio_label = '$\frac{3\left| det\left( AW^{-1}\right)\right|^{\frac{2}{3}}}{\| AW^{-1}\|_{F}^2 }$';
vlrms_label = '$6 \sqrt{2}\frac{V}{L_{rms}^3}$';

if strcmp(quality_metric_name, "Mean-Ratio")
    quality_functions{1} = @CalcQualityTetraMeanRatio;
    quality_functions{2} = @FiniteDifference;
    quality_metric_label = mean_ratio_label;
elseif strcmp(quality_metric_name, "Volume-Length")
    quality_functions{1} = @CalcQualityTetraVLrms;
    quality_functions{2} = @VLrmsGradient;
    quality_metric_label = vlrms_label;
end

quality_metric = quality_functions{1};

mesh_initial = load(config.mesh_file);
mesh_initial.tetrahedra = SetTetrahedraInCorrectOrientation(mesh_initial.tetrahedra, mesh_initial.vertices);


initial_qualities = quality_metric(mesh_initial.tetrahedra, mesh_initial.vertices);

PrintMeshInfo(mesh_initial)
fprintf("\n\n------- Before optimization -------\n\n")
PrintMeshQualityStats(initial_qualities, quality_metric_name)

tmp_free_vertices = mesh_initial.free_vertices;
mesh_initial.free_vertices = mesh_initial.changed_vertices;
% mesh_initial.free_vertices = tmp_free_vertices;
tic
[mesh_optimized, processed_nodes] = OptimizeMesh(mesh_initial, quality_functions, alg_options);
duration = toc;

optimized_qualities = quality_metric(mesh_optimized.tetrahedra, mesh_optimized.vertices);

opt_info = SetOptimizationInfo(alg_options, initial_qualities, optimized_qualities, processed_nodes, duration);

fprintf("\n\n------- After %s optimization -------\n\n", alg_options.algorithm)
PrintMeshQualityStats(optimized_qualities, quality_metric_name)
PrintOptimizationInfo(opt_info)

figure()
DrawQualityGraph(initial_qualities, optimized_qualities, quality_metric_name);

figure()
subplot(2,1,1)
DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh_initial))
% title('Siatka przed poprawą')

subplot(2,1,2)

DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh_optimized))
% title('Siatka po poprawie')



if save_optimized_mesh
    tetrahedra = mesh_optimized.tetrahedra;
    vertices = mesh_optimized.vertices;
    free_vertices = tmp_free_vertices;
    surface = mesh_optimized.surface;
    save(config.mesh_save, 'tetrahedra', 'vertices', 'free_vertices', 'surface');
end

if isfield(config, 'mesh_morphing')
        %REMOVE FRONT FACE & BACK FACE
        %1. krazek
        x_start = 20;
        x_end = 29.5;
        y_start = (9.52 - 6.91)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        y_start = 6.91 + (9.52 - 6.91)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        %2. krazek
        x_start = 30;
        x_end = 39;
        y_start = (9.52 - 7.93)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        y_start = 7.93 + (9.52 - 7.93)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        %3. krazek
        x_start = 39.5;
        x_end = 48.5;
        y_start = (9.52 - 7.93)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        y_start = 7.93 + (9.52 - 7.93)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        %4. krazek
        x_start = 49;
        x_end = 58.5;
        y_start = (9.52 - 6.91)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        y_start = 6.91 + (9.52 - 6.91)/2;
        borders = [x_start x_end y_start];
        mesh_initial.surface = RemoveFace(mesh_initial, borders);

        figure()
        poor_tets = initial_qualities < 1/3;

        DrawTriMesh(mesh_initial, 'g');
        hold on
        tetramesh(mesh_initial.tetrahedra(poor_tets,:), mesh_initial.vertices, 'facecolor', 'red')
        xlim([20.1, 58.4])
%         view(-15,6)
        view(-15.7193,21.0349)

        set(gcf,'color','w');


        figure()
        poor_tets = optimized_qualities < 1/3;
        DrawTriMesh(mesh_initial, 'g');
        hold on
        tetramesh(mesh_initial.tetrahedra(poor_tets,:), mesh_optimized.vertices, 'facecolor', 'red')
        xlim([20.1, 58.4])
        
        view(-15.7193,21.0349)
        set(gcf,'color','w');
        
        X_changes = find(mesh_initial.vertices(:,1) ~= mesh_optimized.vertices(:,1));
        Y_changes = find(mesh_initial.vertices(:,2) ~= mesh_optimized.vertices(:,2));
        Z_changes = find(mesh_initial.vertices(:,3) ~= mesh_optimized.vertices(:,3));
        frac_changes = length(unique([X_changes;Y_changes;Z_changes;mesh_initial.changed_vertices]))/length(mesh_initial.vertices);
        fprintf("Frakcja zmienionych wierzcholkow %.2f\n", frac_changes)

end

