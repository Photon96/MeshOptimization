function [inverted] = GetInvertedTetrahedra(tetras, positions)
    tetr = positions(reshape(tetras', 4*size(tetras, 1), []),:);

    A = tetr(1:4:length(tetr),:);
    B = tetr(2:4:length(tetr),:);
    C = tetr(3:4:length(tetr),:);
    D = tetr(4:4:length(tetr),:); 
    
    ab = A-B;
    ac = A-C;
    ad = A-D;
    
    V = CalcTetrahedraVolumes(ab, ac, ad);
    
    inverted = V < 0;
    
end

