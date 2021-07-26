function [normal] = NormalToTriangle(vertices, triangle)
    A = vertices(triangle(1, 2),:) - vertices(triangle(1, 1),:);
    B = vertices(triangle(1, 3),:) - vertices(triangle(1, 1),:);
    normal = cross(A,B);
end

