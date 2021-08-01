function [] = DrawQualityGraph(prev_qualities, qualities, xlabel_title)
    
    feature('DefaultCharacterSet', 'windows-1252'); %# for all Character support
    nr_buckets = 15;
    buckets_ranges = linspace(0, 1, nr_buckets + 1);
    buckets_prev_quality = zeros(nr_buckets, 1);
    buckets_quality = zeros(nr_buckets, 1);

    
    for i=1:nr_buckets
        buckets_prev_quality(i) = sum((prev_qualities >= buckets_ranges(i) ...
            & prev_qualities < buckets_ranges(i+1)));
        buckets_quality(i) = sum((qualities >= buckets_ranges(i) ...
            & qualities < buckets_ranges(i+1)));        
    end
    
    
    Y = [reshape(buckets_prev_quality, nr_buckets, 1), reshape(buckets_quality, nr_buckets, 1)];
%     Y = 10*Y;
    
    hb = bar(buckets_ranges(2:end), Y);
    
    cyan_color = [0,255,255]./255;
    darkred_color = [220,20,60]./255;
    hb(1).FaceColor = darkred_color;
    hb(2).FaceColor = cyan_color;
    
    ylabel('Elementy', 'Interpreter', 'latex');
    xlabel(xlabel_title, 'Interpreter', 'latex');
%     set(h, 'FontSize', 15); 
    legend('Siatka przed poprawą', 'Siatka po poprawie', 'Location','northwest');
end

