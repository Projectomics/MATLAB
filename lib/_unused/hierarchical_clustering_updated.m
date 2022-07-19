function idClusters = hierarchical_clustering_updated(fileName, region)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    %clear all;
           
    strng = sprintf('\nLoading neuron distances ...\n');
    disp(strng);
    
    %reads in file with angles/differences between neuron pairs
    fileNameFull = sprintf('./output/%s', fileName);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ','))+1;
    %nCols = 5000;
    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ',');
    nRows = length(dataStr{1,1}) / nCols
    fclose(fid);
    
    for i = 1:nRows
        rawData(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end    

    %format data and create hierarchical clustering tree + dendrogram
    dim = str2num(cell2mat(rawData(nRows, 2)));
    squareMat = zeros(dim, dim);
    for i = 1:nRows
        row = str2num(cell2mat(rawData(i, 1)));
        col = str2num(cell2mat(rawData(i, 2)));
        value = str2num(cell2mat(rawData(i, 3)));
        squareMat(row, col) = value;
        squareMat(col, row) = value;
    end
    distances = squareform(squareMat);    
    clusters = linkage(distances, 'average');
    %T = cluster(clusters,'maxclust',3); 
    
    dendrogram(clusters, dim);
    str = strcat('./output/', region, '_average_dendrogram.fig');
    saveas(gcf, str);
    
    %matrix with final class divisions/clusters that showed insignificant results
    insigClusters = zeros(dim, dim);
    insigRow = 0;
    
    %input and process bin/raw matrix file
    disp('Enter Bin Matrix File');
    reply = [];
    while (isempty(reply)) % enter filtered binary/raw matrix for region
        reply = select_csvFileName();
        if strcmp(reply, '!')
            disp('Exiting');
        else
            fid2 = fopen(reply);
            if(fid2 == -1)
                reply = [];
            else
                fclose(fid2);
            end
        end
    end
       
    % loop that increments the number of clusters the data is divided
    % into, starting from 2
    for numClusters = 2:dim
        % create 2D array where neurons are divided into clusters, 
        %where rows indicate each cluster and columns indicate each neuron
        temp = cluster(clusters, 'maxclust', numClusters);
        groups = zeros(numClusters, dim);
        for i = 1:length(temp)
            row = temp(i);
            for j = 1:dim
                if(groups(row, j) == 0)
                    col = j;
                    break;
                end
            end
            groups(row, col) = i;
        end
        
        % call all functions on each cluster UNLESS any neurons from the
        % cluster are in insigClusters
        for r = 1:numClusters
            neuronArray = groups(r, :);
            neuronArray1 = nonzeros(neuronArray);
            neuronArray1 = neuronArray1.';
            
            if(~(ismember(neuronArray1(1), insigClusters)))
                %can switch out method below with binary, raw lateral, and binary
                %lateral counterparts
                p = call_all_functions_raw(neuronArray1, reply); 
                
                %if p value is not significant, add it to final class
                %division array
                if(p > 0.05)
                    if(~(ismember(neuronArray1(1), insigClusters)))
                        insigRow = insigRow + 1;
                        insigClusters(insigRow, :) = neuronArray;
                    end
                end
            end               
        end
        
        % once all neurons have been divided into the final class
        % divisions, save the clusters to a spreadsheet
        x = nnz(insigClusters);
        if(x == dim)
            %idClusters = bt_save_clusters(insigClusters, region);
            idClusters = save_clusters(insigClusters, region);
            break;
        else
            continue;
        end            
    end
    
end