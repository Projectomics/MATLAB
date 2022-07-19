function cluster_Broad_Institute(clusters, cellType)
    [nRows, nCols] = size(clusters);
%     newClusters = strings(nRows, nCols);
%     for r = 1:length(clusters)
%         temp = clusters(r, 2);
%         if(strcmp(temp, cellType))
%             newClusters(r, 1) = clusters(r, 1);
%             newClusters(r, 2) = clusters(r, 2);
%             newClusters(r, 3) = clusters(r, 3);
%         else
%             newClusters(r, 1) = {'-'};
%             newClusters(r, 2) = {'-'};
%             newClusters(r, 3) = {'-'};
%         end
%     end
%         
%     newClusters(all(strcmp(newClusters,'-'),2),:) = [];    
%     nRows = length(newClusters)   
    
%     set = unique(newClusters(:, 3));
%     finalClusters = zeros(length(set), nRows);
%     
%     for i = 1:nRows
%        temp = newClusters(i, 3);
%        for k = 1:length(set)
%           if(strcmp(temp, set(k)))
%              x = finalClusters(k, :);
%              idx = find(~x,1,'first');
%              finalClusters(k, idx) = i;             
%           end
%        end
%     end

    newClusters = strings(nRows, nCols+1);
    newClusters(:, 1) = clusters(:, 1);
    newClusters(:, 2) = clusters(:, 2);
    newClusters(:, 3) = clusters(:, 3);
    for row = 1:nRows
       newClusters(row, 4) = strcat(newClusters(row, 2), '-', newClusters(row, 3)); 
    end
    
    set = unique(newClusters(:, 4));
    finalClusters = zeros(length(set), nRows);
    
    for i = 1:nRows
       temp = newClusters(i, 4);
       for k = 1:length(set)
          if(strcmp(temp, set(k)))
             x = finalClusters(k, :);
             idx = find(~x,1,'first');
             finalClusters(k, idx) = i;             
          end
       end
    end

   idClusters = save_clusters(finalClusters, cellType);
end