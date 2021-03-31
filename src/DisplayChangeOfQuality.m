function [] = DisplayChangeOfQuality(prev_quality, current_quality)
    quality_diff = current_quality - prev_quality;
    Y = [prev_quality current_quality quality_diff];
    hb = bar(1:length(prev_quality), Y, 1.4);
%     hb(2).FaceColor = [1,0.85,0.25];
    hold on
    y = 0.35;
    yline(y, 'k-', 'LineWidth', 2);
    set(gca,'xtick',[])
    legend(["prev quality", "current quality", "quality difference", "quality treshold"])
end

