clear all
addpath('../src')
addpath('../immoptibox')
addpath('../poblano_toolbox')
mesh = load('../structures/3D/new_deformed_cube_3k_el.mat');
mesh.tetrahedra = SetTetrahedraInCorrectOrientation(mesh.tetrahedra, mesh.vertices);
positions = mesh.vertices;
tetras = mesh.tetrahedra;
free_nodes = mesh.free_vertices;
quality_treshold = 1;

quality_function_handle = @CalcQualityTetraVLrms;
quality_metric_name = "VLrms";
prev_qualities = CalcQualityTetraVLrms(tetras, positions);

DrawQualityHistogram(prev_qualities, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
PrintMeshInfo(mesh)
fprintf("\n\n------- Before optimization -------\n\n")
PrintMeshQualityStats(prev_qualities, quality_metric_name)
algorithms = ["Gradient descent","Steepest descent","DFP","BFGS",...
    "Nonlinear Conjugate Gradient", "Trust-Region"];
algorithms_pl = ["Metoda gradientu prostego", "Metoda najszybszego spadku",...
    "DFP", "BFGS", "Metoda gradientów sprzężonych", "Trust-Region"];
algorithms = ["Nonlinear Conjugate Gradient"];
algorithms = "BFGS";
algorithms = "Gradient descent";

for alg_type=1:length(algorithms)
    
    
    [infos(alg_type), positions] = TestOptimizationMethod(algorithms(alg_type), positions, ...
        tetras, free_nodes, quality_function_handle, quality_treshold);
    
    global_qualities = quality_function_handle(tetras, positions);
   
    figure(2)
    subplot(3,2,alg_type)
    DrawQualityHistogram(global_qualities, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
    title(algorithms_pl(alg_type));
    
    figure(3)
    subplot(3,2,alg_type)
    mesh_tmp.vertices = positions;
    mesh_tmp.tetrahedra = mesh.tetrahedra;
    DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh_tmp));
    title(algorithms_pl(alg_type));
    positions = mesh.vertices;
end

for i=1:length(algorithms)
    PrintOptimizationInfo(infos(i));
    fprintf("Min quality:        %.3f\n", infos(i).current_min_quality)
    fprintf("Prev tetras < 0.33: %d\n", infos(i).prev_tetras_worse_treshold)
    fprintf("Curr tetras < 0.33: %d\n\n", infos(i).current_tetras_worse_treshold)
end

figure(1)
subplot(2,1,1)
DrawQualityHistogram(quality_function_handle(mesh.tetrahedra, mesh.vertices), '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')

subplot(2,1,2)
DrawDihedralAnglesHistogram(CalculateDihedralAngles(mesh));

