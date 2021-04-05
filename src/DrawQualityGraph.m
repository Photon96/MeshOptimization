function [] = DrawQualityGraph(prev_qualities, qualities, xlabel_title)
    
    feature('DefaultCharacterSet', 'windows-1252'); %# for all Character support
    nr_buckets = 30;
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
    hb = bar(buckets_ranges(2:end), log(Y));
    
    hb(2).FaceColor = [1,0.85,0.25];
    ylabel('Elementy');
    h = xlabel(xlabel_title, 'Interpreter', 'latex');
    set(h, 'FontSize', 15); 
    legend('siatka przed poprawą', 'siatka po poprawie', 'Location','northwest');
end

