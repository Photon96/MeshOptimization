function [intersection, alfa] = IsIntersectionTetra(tetra, pos)
    intersection = 0;
%     my_ones = ones(4,1);
    tetr = pos(reshape(tetra', 4*length(tetra), []),:);
    alfa = zeros(length(tetr)/4,1);
    j = 1;
    %my_ones = ones(4,1);
    long_ones = ones(length(tetr),1);
    alfa_matrix = [tetr(:,1:3), long_ones];
    for i=1:4:length(tetr)
        alfa(j) = det(alfa_matrix(i:i+3,:));
        j = j + 1;
    end
    if find(alfa <= 0, 1, 'first')
        intersection = 1;
    end
%     for i=1:length(tetra)
%         tetr = pos(tetra(i,:),:);
%         alfa = det([
%             tetr my_ones;
%         ]);
%         if alfa <=0 
%             intersection = 1;
%             return
%         end
% %         A = pos(tetra(i, 1),:);
% %         B = pos(tetra(i, 2),:); 
% %         C = pos(tetra(i, 3),:);
% %         D = pos(tetra(i, 4),:);
% %         delta = det([
% %             0    A*B' C*A' D*A' 1
% %             A*B' 0    C*B' D*B' 1
% %             A*C' B*C' 0    D*C' 1
% %             A*D' B*D' C*D' 0    1
% %             1    1    1    1    0
% %         ]);
% %         if delta <=0
% %             intersection = 1;
% %             return
% %         end
%     end
end

