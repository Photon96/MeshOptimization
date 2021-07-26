function [DA_degrees] = CalculateDihedralAngles(mesh)
    %formula from https://people.sc.fsu.edu/~jburkardt/presentations/cg_lab_tetrahedrons.pdf
    %https://people.sc.fsu.edu/~jburkardt/m_src/tetrahedron_properties/tetrahedron_properties.html
    %DA_equilateral_tet = asin(2*sqrt(2)/3);
    
    nr_elements = size(mesh.tetrahedra, 1);
    DA_radians = zeros(nr_elements, 6);
    DA_degrees = zeros(nr_elements, 6);
    
    for i=1:nr_elements
        tetrahedron = mesh.tetrahedra(i,:);
        vertices = mesh.vertices(tetrahedron, :);
        
        a = vertices(1,:); 
        b = vertices(2,:);
        c = vertices(3,:);
        d = vertices(4,:);
        
        Nabc = cross((c-a),(b-a));
        % unit normal vector
        abc_normal = Nabc/norm(Nabc);
        
        Nabd = cross((b-a), (d-a));
        abd_normal = Nabd/norm(Nabd);
        
        Nacd = cross((d-a), (c-a));
        acd_normal = Nacd/norm(Nacd);
        
        Nbcd = cross((c-b), (d-b));
        bcd_normal = Nbcd/norm(Nbcd);
        
%         Fabc = (a + b + c)/3;
%         Fabd = (a + b + d)/3;
%         Facd = (a + c + d)/3;
%         Fbcd = (b + c + d)/3;
%         F = [Fabc' Fabd' Facd' Fbcd'];
%         N = [Nabc' Nabd' Nacd' Nbcd'];
%         X = F(1,:);
%         Y = F(2,:);
%         Z = F(3,:);
%         U = N(1,:);
%         V = N(2,:);
%         W = N(3,:);
%         
%         tetramesh(tetrahedron, vertices, 'facecolor','none');
%         hold on;
%         text(a(1),a(2),a(3), 'A')
%         text(b(1),b(2),b(3), 'B')
%         text(c(1),c(2),c(3), 'C')
%         text(d(1),d(2),d(3), 'D')
%         quiver3(X,Y,Z,U,V,W);
%         
%         h1 = DrawTriMesh([1 2 3],[a;b;c], 'red');
%         h2 = DrawTriMesh([1 2 3],[a;b;d], 'blue');
%         
%         set(h1, 'Visible', 'off')
%         set(h2, 'Visible', 'off')
%         
%         tetramesh(tetrahedron, vertices, 'facecolor','none');
%         DrawTriMesh([1 2 3],[a;b;c], 'red');
%         DrawTriMesh([1 2 3],[a;c;d], 'blue');
         
        %dihedral angles
        DA_ab = acos(abc_normal*abd_normal');
        DA_ac = acos(abc_normal*acd_normal');
        DA_ad = acos(acd_normal*abd_normal');
        DA_bc = acos(abc_normal*bcd_normal');
        DA_bd = acos(abd_normal*bcd_normal');
        DA_cd = acos(bcd_normal*acd_normal');
       
        DA_radians(i,:) = pi - [DA_ab DA_ac DA_ad DA_bc DA_bd DA_cd];
        
        DA_degrees(i,:) = round(DA_radians(i,:).*180/pi,2);
        
    end
end

