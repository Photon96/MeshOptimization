clear all
addpath('../src')
mesh_original = load('original_mesh.mat');
mesh_optimized = load('optimized_mesh.mat');

mesh_original.tetrahedra(:, [2,3]) = mesh_original.tetrahedra(:, [3,2]);
mesh_optimized.tetrahedra(:, [2,3]) = mesh_optimized.tetrahedra(:, [3,2]);
txt = "Przed poprawą"
GetStatsOfMesh(mesh_original.tetrahedra, mesh_original.vertices, 1/3, @CalcQualityTetraVLrms)
txt = "Po poprawie"
GetStatsOfMesh(mesh_optimized.tetrahedra, mesh_optimized.vertices, 1/3, @CalcQualityTetraVLrms)

figure();
subplot(2,1,1)
DrawQualityBar(CalcQualityTetraVLrms(mesh_original.tetrahedra, mesh_original.vertices), '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
title("Przed poprawą")
subplot(2,1,2)
DrawQualityBar(CalcQualityTetraVLrms(mesh_original.tetrahedra, mesh_optimized.vertices), '$6 \sqrt{2}\frac{V}{L_{rms}^3}$')
title("Po poprawie")
mesh = load('neutral.mat');
mesh_original = mesh;
tet = mesh_original.tetrahedra(1,:);
L1 = mesh_original.vertices(tet(2),:) - mesh_original.vertices(tet(1),:);
L2 = mesh_original.vertices(tet(3),:) - mesh_original.vertices(tet(2),:);
L3 = mesh_original.vertices(tet(3),:) - mesh_original.vertices(tet(1),:);
L4 = mesh_original.vertices(tet(4),:) - mesh_original.vertices(tet(1),:);
L5 = mesh_original.vertices(tet(4),:) - mesh_original.vertices(tet(2),:);
L6 = mesh_original.vertices(tet(4),:) - mesh_original.vertices(tet(3),:);

C1 = L1;
C2 = (-2*L3 - L1)/sqrt(3);
C3 = (3*L4 + L3 - L1)/sqrt(6);
Cdet = C1*cross(C2,C3)';

T1 = C1*C1' + C2*C2' + C3*C3';
T2 = cross(C1,C2)*cross(C1,C2)' + cross(C2,C3)*cross(C2,C3)' + cross(C1,C3)*cross(C1,C3)';

q = sqrt(T1*T2)/(3*Cdet)
