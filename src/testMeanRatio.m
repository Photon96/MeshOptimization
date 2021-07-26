mesh = load('../structures/original_mesh.mat');
mesh.tetrahedra(:,[2,3]) = mesh.tetrahedra(:,[3,2]);
% 
% tic
% for i=1:100
    qualities2 = CalcQualityTetraMeanRatio(mesh.tetrahedra, mesh.vertices);
% end
% toc/100
% 
% tic
% for i=1:100
%     qualities2 = CalcQualityTetraVLrms(mesh.tetrahedra, mesh.vertices);
% end
% toc/100
