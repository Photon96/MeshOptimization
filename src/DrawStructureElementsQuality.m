function [] = DrawStructureElementsQuality(mesh, qualities)

    red = [220,20,60]./255;       
    bad_elements = qualities < 1/3;
    figure();
    tetramesh(mesh.tetrahedra, mesh.vertices, 'FaceColor', 'none');
    hold on;
    tetramesh(mesh.tetrahedra(bad_elements, :), mesh.vertices, 'FaceColor', red);
end

