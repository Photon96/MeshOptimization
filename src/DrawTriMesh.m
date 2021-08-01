function [h] = DrawTriMesh(mesh, color)
    vertices = mesh.vertices;
    triangles = mesh.surface;
    if strcmp(color, '')
        h = trimesh(triangles, vertices(:,1), vertices(:,2), vertices(:,3));
    else
        h = trimesh(triangles, vertices(:,1), vertices(:,2), vertices(:,3),...
            'facecolor', color, 'edgecolor', 'black');
    end
    axis equal;
    axis off;
end

