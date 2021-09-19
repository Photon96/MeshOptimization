function [nodes] = GetNodesInCylinder(mesh, z, center, r)
    min_z = z(1);
    max_z = z(2);
    
    Z = (mesh.vertices(:,3) > (min_z + 0.1)) & (mesh.vertices(:,3) < (max_z - 0.1));
    dist = sqrt(sum((mesh.vertices(:,[1,2]) - center).^2,2));
    R = dist < r;
    
    nodes = find(Z & R);
end

