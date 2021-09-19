function [nodes] = GetNodesInBox(mesh, box)
    min_x = box(1,1);
    min_y = box(1,2);
    min_z = box(1,3);
    
    max_x = box(2,1);
    max_y = box(2,2);
    max_z = box(2,3);
    
    X = mesh.vertices(:,1) > min_x & mesh.vertices(:,1) < max_x;
    Y = mesh.vertices(:,2) > min_y & mesh.vertices(:,2) < max_y;
    Z = mesh.vertices(:,3) > min_z & mesh.vertices(:,3) < max_z;
    
    nodes = find(X & Y & Z);
end

