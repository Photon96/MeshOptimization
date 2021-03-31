function [] = Draw3DGridValues(X, Y, Z, values)  
     scatter3(X(:),Y(:),Z(:),5,values);
     colormap(jet);
     colorbar;
end

