function [f, J, H] = FunctionMetricPoblano(x, vertex, tetras, positions, quality_function_handle)
    positions(vertex, :) = x';
    [f,i] = min(quality_function_handle(tetras, positions));
    f = -f;
    if nargout > 2
%         [J, H] = FDAllElements(vertex, tetras, positions, @CalcQualityTetraVLrms);
%         H = H((i - 1)*3 + 1:(i - 1)*3 + 3,:);
        [J, H] = FiniteDifference(vertex, tetras, positions, quality_function_handle);
        H = -H;
    else
%         J = FDAllElements(vertex, tetras, positions, @CalcQualityTetraVLrms);
%         J = FiniteDifference(vertex, tetras, positions, @CalcQualityTetraVLrms);
        J = VLrmsGradient(vertex, tetras, positions, i);
    end
%     J = -J(:, i);
    J = -J;
end

