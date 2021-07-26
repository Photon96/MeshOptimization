function quality = CalcQualityTetraVLrms(tetras, positions)
    %funkcja obliczajaca minimalna jakosc tetów okreslona jako
    %2*sqrt(6)*V/Lrms
    %https://people.sc.fsu.edu/~jburkardt/presentations/cg_lab_tetrahedrons.pdf
    tetr = positions(reshape(tetras', 4*size(tetras, 1), []),:);

    A = tetr(1:4:length(tetr),:);
    B = tetr(2:4:length(tetr),:);
    C = tetr(3:4:length(tetr),:);
    D = tetr(4:4:length(tetr),:); 
    
    ab = A-B;
    ac = A-C;
    ad = A-D;
    
    V = CalcTetrahedraVolumes(ab, ac, ad);
    
    %oblicz dlugosci krawedzi
    Lab = sqrt(sum((A - B).^2,2)); 
    Lac = sqrt(sum((A - C).^2,2)); 
    Lad = sqrt(sum((A - D).^2,2)); 
    Lbc = sqrt(sum((B - C).^2,2)); 
    Lbd = sqrt(sum((B - D).^2,2)); 
    Lcd = sqrt(sum((C - D).^2,2)); 
    Lrms = sqrt(sum([Lab, Lac, Lad, Lbc, Lbd, Lcd].^2, 2)/6);

    c = 6*sqrt(2);
    quality = c*V./(Lrms.*Lrms.*Lrms);

end

