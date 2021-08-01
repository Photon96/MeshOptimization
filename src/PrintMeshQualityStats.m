function [] = PrintMeshQualityStats(qualities, quality_metric)
    fprintf("------- Mesh Quality Statistics -------\n")
    fprintf("Quality metric: %s\n", quality_metric)
    fprintf("Minimum:        %.3f\n", min(qualities))
    fprintf("Average:        %.3f\n", mean(qualities))
    fprintf("RMS:            %.3f\n", sqrt(sum(qualities.^2)/length(qualities)))
    fprintf("Maximum:        %.3f\n", max(qualities))
    fprintf("Std. dev.:      %.3f\n", std(qualities))
    fprintf("Tets < 0.33:    %i\n", sum(qualities < 1/3));
end

