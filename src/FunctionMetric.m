function [f, J, H] = FunctionMetric(x, vertex, tetras, positions)
    positions(vertex, :) = x;
    f = min(CalcQualityTetraVLrms(tetras, positions));
    f = -f;
    if nargout > 2
        [J, H] = FiniteDifference(vertex, tetras, positions, @CalcQualityTetraVLrms);
        H = -H;
    else
        J = FiniteDifference(vertex, tetras, positions, @CalcQualityTetraVLrms);
    end
    J = -J;
end

