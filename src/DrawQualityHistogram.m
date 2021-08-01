function [max_y] = DrawQualityHistogram(qualities, xlabel_title)
    feature('DefaultCharacterSet', 'windows-1252'); %# for all Character support
    nr_buckets = 50;
    buckets_ranges = linspace(0, 1, nr_buckets + 1);
    buckets_quality = zeros(nr_buckets, 1);
    
    for i=1:nr_buckets
        buckets_quality(i) = sum((qualities >= buckets_ranges(i) ...
            & qualities < buckets_ranges(i+1)));        
    end
    
    Y = reshape(buckets_quality, nr_buckets, 1);
    V1 = [Y diff(buckets_ranges')];
    V1L = [0; cumsum(V1(:,2))];                                             
   
    green = [60,179,113]./255;
    yellow = [255,255,0]./255;
    red = [220,20,60]./255;
    colors = ones(nr_buckets + 1,1).*green;
    colors(buckets_ranges < 2/3,:) = ones(sum(buckets_ranges < 2/3),3).*yellow;
    colors(buckets_ranges < 1/3,:) = ones(sum(buckets_ranges < 1/3),3).*red;
  
    for i = 1:size(V1,1)
        patch([0 1 1 0]*V1(i,2)+V1L(i),[0 0 1 1]*V1(i,1), colors(i,:))
    end
    axis([0  1    0  max(ylim)])
%     [~, min_i] = min(abs(buckets_ranges - 1/3));
%     xline(buckets_ranges(min_i));
    ylabel('Elementy');
    h = xlabel(xlabel_title, 'Interpreter', 'latex');
%     set(h, 'FontSize', 15); 
    max_y = max(ylim);
end

