function compare_dendrogram_scratch(fileName, region)
%     addpath('./lib/');
%     addpath('./lib/jsonlab-1.5');
%     addpath('../dir_MouseLight_ASSIP/');
%     addpath('../dir_shuffle_ASSIP/');
%     %clear all;
%            
%     strng = sprintf('\nLoading neuron distances ...\n');
%     disp(strng);
%        
%     %reads in file with angles/differences between neuron pairs
%     fileNameFull = sprintf('./output/%s', fileName);
%     
%     rawData = readmatrix(fileNameFull);
%     [nRows, nCols] = size(rawData);   
% 
%     %format data and create hierarchical clustering tree + dendrogram
%     dim = rawData(nRows, 2);   
%     distances = rawData(:, 3).';
%     clusters = linkage(distances, 'average');
%     
%     dendrogram(clusters, dim);
%     str = strcat('./output/', region, '_average_dendrogram.fig');
%     saveas(gcf, str);
%     
%     %matrix with final class divisions/clusters that showed insignificant results
%     insigClusters = zeros(dim, dim);
%     insigRow = 0;
%     
%     temp = cluster(clusters, 'maxclust', 8);
%     groups = zeros(8, dim);
%     for i = 1:length(temp)
%         row = temp(i);
%         for j = 1:dim
%             if(groups(row, j) == 0)
%                 col = j;
%                 break;
%             end
%         end
%         groups(row, col) = i;
%     end
%      
%     idClusters = save_clusters(groups, region);

    broadFile = 'broad_official_localClusters_20211104112809 - Copy.csv';
    broadClusters = readmatrix(broadFile);
    [broadRow, broadCol] = size(broadClusters);
    
    ourFile = 'broad_localClusters_20211102160337 - Copy.csv';
    ourClusters = readmatrix(ourFile);
    [ourRow, ourCol] = size(ourClusters);
    
    nNeurons = nnz(~isnan(ourClusters));
    
    clusterAssignments = zeros(nNeurons, 3);
    for i = 1:nNeurons
       [bRowTemp, bColTemp] = find(broadClusters==i);
       [oRowTemp, oColTemp] = find(ourClusters==i);
       clusterAssignments(i, 1) = i;
       clusterAssignemnts(i, 2) = bRowTemp;
       clusterAssignments(i, 3) = oRowTemp;       
    end
    
end