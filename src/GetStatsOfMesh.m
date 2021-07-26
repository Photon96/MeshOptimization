function [stats] = GetStatsOfMesh(tetrahedra, vertices, treshold, quality_function_handle)
    quality = quality_function_handle(tetrahedra, vertices);
    stats.min_quality = min(quality);
    stats.mean_quality = mean(quality);
    stats.tet_worse_than_treshold = sum(quality < treshold);
    stats.number_tet = size(tetrahedra, 1);
    stats.number_vertices = size(vertices, 1);
    stats.treshold = treshold;
end

