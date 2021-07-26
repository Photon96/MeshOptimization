function qualities = CalcQualityTetraMeanRatio(tetras, positions)
    % funkcja obliczajaca jakosc tetów okreslona jako
    % (3*det(A1*inv(W))^(2/3))/(norm(A1*inv(W), 'fro')^2)
    % https://cfwebprod.sandia.gov/cfdocs/CompResearch/docs/local_global.pdf
    % https://www.mcs.anl.gov/~tmunson/papers/shape.pdf
    tetr = positions(reshape(tetras', 4*size(tetras, 1), []),:);

    A = tetr(1:4:length(tetr),:);
    B = tetr(2:4:length(tetr),:);
    C = tetr(3:4:length(tetr),:);
    D = tetr(4:4:length(tetr),:); 
    
%     ab = A-B;
%     ac = A-C;
%     ad = A-D;
    ab = A-B;
    ac = A-C;
    ad = A-D;
   
    det_M = Calculate3x3Determinants(ab, ac, ad);
    
    n = size(tetras,1);
%     M = zeros(3*n, 3);
    
    %TODO: improve
%     for i=1:n
%         M((i-1)*3 + 1:(i-1)*3 + 3,:) = [ab(i,:)' ac(i,:)' ad(i,:)'];
%     end
%     W = [1 1/2 1/2; ...
%         0 sqrt(3)/2 sqrt(3)/6;...
%         0 0 sqrt(6)/3];
%     W_inv = inv(W);
    W_inv = [1.0000   -0.5774   -0.4082;
         0    1.1547   -0.4082;
         0         0    1.2247];
%     det_W_inv = det(W_inv);
    det_W_inv = 1.4142;
    
    norms = zeros(n,1);
    dets = det_M.*det_W_inv;
    
    for i=1:n
        %TODO: improve
%         norms(i) = norm(M((i-1)*3 + 1:(i-1)*3 + 3, :)*W_inv, 'fro')^2;
        %frobenius norm
        %https://mathworld.wolfram.com/FrobeniusNorm.html
        norms(i) = sqrt(sum(([ab(i,:)' ac(i,:)' ad(i,:)']*W_inv).^2, 'all'));
        norms(i) = norm([ab(i,:)' ac(i,:)' ad(i,:)']*W_inv, 'fro');
    end
    
    if any(dets < 0 )
        qualities = 0;
        return
    end
    
    qualities = (3*dets.^(2/3))./(norms.^2);

end

