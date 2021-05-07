clear all
addpath('../src')
addpath('../immoptibox')
addpath('../poblano_toolbox')
load('../structures/deformed_cube_mesh.mat');
positions = mesh.positions;
tetras = mesh.tetrahedrons;
free_nodes = mesh.free_nodes;
quality_treshold = 1/3;

quality_function_handle = @CalcQualityTetraVLrms;


prev_qualities = CalcQualityTetraVLrms(tetras, positions);

algorithms = ["DFP", "Steepest descent", "Trust-Region", "Damped Newton",...
    "ucminf: BFGS", "fminunc: BFGS",  "Nonlinear Conjugate Gradient", "Gradient descent"];
algorithms = ["fminunc: BFGS"];
alg_types = length(algorithms);
for alg_type=1:alg_types
    
    
    [infos(alg_type), positions] = TestOptimizationMethod(algorithms(alg_type), positions, ...
        tetras, free_nodes, quality_function_handle, quality_treshold);
    
    global_qualities = quality_function_handle(tetras, positions);
   
    
    subplot(4,2,alg_type)
    DrawQualityBar(global_qualities, '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
    title(infos(alg_type).algorithm);
    positions = mesh.positions;
end

for i=1:alg_types
    infos(i)
end

