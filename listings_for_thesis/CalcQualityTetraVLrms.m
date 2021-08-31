function [qualities] = CalculateQualityVLrms(tetrahedra, nodes)
    tetr = nodes(reshape(tetrahedra', 4*size(tetrahedra, 1), []),:);

    A = tetr(1:4:length(tetr),:);
    B = tetr(2:4:length(tetr),:);
    C = tetr(3:4:length(tetr),:);
    D = tetr(4:4:length(tetr),:); 
    
    ab = A-B;
    ac = A-C;
    ad = A-D;
    
    V = CalculateTetrahedraVolumes(ab, ac, ad);
    
    Lab = sqrt(sum((A - B).^2,2)); 
    Lac = sqrt(sum((A - C).^2,2)); 
    Lad = sqrt(sum((A - D).^2,2)); 
    Lbc = sqrt(sum((B - C).^2,2)); 
    Lbd = sqrt(sum((B - D).^2,2)); 
    Lcd = sqrt(sum((C - D).^2,2)); 
    Lrms = sqrt(sum([Lab, Lac, Lad, Lbc, Lbd, Lcd].^2, 2)/6);

    c = 6*sqrt(2);
    qualities = c*V./(Lrms.*Lrms.*Lrms);

end