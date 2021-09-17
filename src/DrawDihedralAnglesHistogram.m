function [] = DrawDihedralAnglesHistogram(DA)
    feature('DefaultCharacterSet', 'windows-1252'); %# for all Character support
    nr_buckets = 180/2;
    buckets_ranges = linspace(0, 180, nr_buckets + 1);
    buckets_DA = zeros(nr_buckets, 1);
    DA = DA(:);
    for i=1:nr_buckets
        buckets_DA(i) = sum((DA >= buckets_ranges(i) ...
            & DA < buckets_ranges(i+1)));        
    end
    
    Y = reshape(buckets_DA, nr_buckets, 1);
    Y = log(Y);
    V1 = [Y diff(buckets_ranges')];
    V1L = [0; cumsum(V1(:,2))];                                             
    
    silver = [192,192,192]./255;
    green = [60,179,113]./255;
    yellow = [255,255,0]./255;
    red = [220,20,60]./255;
    orange = [255,165,0]./255;
    
    colors = ones(nr_buckets + 1,1).*silver;
    
    colors(buckets_ranges < 40,:) = ones(sum(buckets_ranges < 40),3).*green;
    colors(buckets_ranges >= 140,:) = ones(sum(buckets_ranges >= 140),3).*green;
    
    colors(buckets_ranges < 30,:) = ones(sum(buckets_ranges < 30),3).*yellow;
    colors(buckets_ranges >= 150,:) = ones(sum(buckets_ranges >= 150),3).*yellow;
    
    colors(buckets_ranges < 20,:) = ones(sum(buckets_ranges < 20),3).*orange;
    colors(buckets_ranges >= 160,:) = ones(sum(buckets_ranges >= 160),3).*orange;
    
    colors(buckets_ranges < 10,:) = ones(sum(buckets_ranges < 10),3).*red;
    colors(buckets_ranges >= 170,:) = ones(sum(buckets_ranges >= 170),3).*red;
  
    for i = 1:size(V1,1)
        h = patch([0 1 1 0]*V1(i,2)+V1L(i),[0 0 1 1]*V1(i,1), colors(i,:));
        h.EdgeColor = 'none';
    end
    yticks([])
%     ylabel("Liczba elementów");
    axis([0  180    0  max(ylim)])
    min_DA = min(DA);
%     min_DA = find(buckets_DA ~= 0,1,'first');
%     max_DA = find(buckets_DA ~= 0,1,'last');
    max_DA = max(DA);
    min_label = {sprintf("%.1f", min_DA)};
    h = xline(min_DA,'-',min_label);
    set(h, 'LabelOrientation', 'horizontal')
    set(h, 'LabelHorizontalAlignment', 'right')
    max_label = {sprintf("%.1f", max_DA)};
    h = xline(max_DA,'-',max_label);
    set(h, 'LabelOrientation', 'horizontal')
    set(h, 'LabelHorizontalAlignment', 'left')
    set(gca,'TickLength',[0.05, 0.05])
    set(gca, 'Layer', 'top')
    xticks = 0:20:180;
    set(gca,'XTick',xticks)
    ax = gca;
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = 0:10:180;
    ax.YAxis.Visible = 'off';
%     ax.YAxis.Visible = 'off';   % remove y-axis    
%     grid on;
%     ax.XMinorGrid = 'on';
%     h = xlabel(xlabel_title, 'Interpreter', 'latex');
end
