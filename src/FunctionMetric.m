function [f, J, H] = FunctionMetric(x, vertex, tetras, positions)
    positions(vertex, :) = x;
    [f,i] = min(CalcQualityTetraVLrms(tetras, positions));
    f = -f;
    if nargout > 2
%         [J, H] = FDAllElements(vertex, tetras, positions, @CalcQualityTetraVLrms);
%         H = H((i - 1)*3 + 1:(i - 1)*3 + 3,:);
        [J, H] = FiniteDifference(vertex, tetras, positions, @CalcQualityTetraVLrms);
        H = -H;
    else
%         J = FDAllElements(vertex, tetras, positions, @CalcQualityTetraVLrms);
%         J = FiniteDifference(vertex, tetras, positions, @CalcQualityTetraVLrms);
        J = VLrmsGradient(vertex, tetras, positions, i);
    end
%     J = -J(:, i);
    J = -J;
end

