addpath('../mesh2d');
[x,y] = meshgrid(1:10,1:10); 
z = zeros(10,10); 
T = delaunay(x,y); 
figure();

trimesh(T,x,y,z, 'edgecolor','black');
view(2)
axis off
axis equal

figure();

node = [                % list of xy "node" coordinates
    0, 0                % outer square
    10, 0
    10, 10
    0, 10] ;

edge = [                % list of "edges" between nodes
    1, 2                % outer square
    2, 3
    3, 4
    4, 1] ;

%------------------------------------------- call mesh-gen.
[vert,etri, ...
tria,tnum] = refine2(node,edge,[],[],1) ;

%------------------------------------------- draw tria-mesh
X = vert(:,1);
Y = vert(:,2);    

triplot(tria, X, Y, 'k')

axis equal
axis off
set(gcf,'color','w');


