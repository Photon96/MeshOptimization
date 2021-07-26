function [h] = DrawTriMesh(triangles, vertices, color)
    if strcmp(color, '')
        h = trimesh(triangles, vertices(:,1), vertices(:,2), vertices(:,3));
    else
        h = trimesh(triangles, vertices(:,1), vertices(:,2), vertices(:,3), 'facecolor', color);
    end
end

