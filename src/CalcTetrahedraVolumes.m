function [V] = CalcTetrahedraVolumes(ab, ac, ad)
    V = Calculate3x3Determinants(ab, ac, ad)./6;
end

