tetras = mesh.tetrahedra;
tetras(:,[2,3]) = tetras(:,[3,2]);
positions = mesh.vertices;
tic
for i=1:50
    quality = CalcQualityTetraMeanRatio(tetras, positions);
end
toc/50
