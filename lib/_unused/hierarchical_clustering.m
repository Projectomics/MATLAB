function idClusters = hierarchical_clustering(fileName, region)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    %clear all;
           
    strng = sprintf('\nLoading neuron distances ...\n');
    disp(strng);
    
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
    
    %dendrogram(clusters, dim);
    %str = strcat('./output/', region, '_average_dendrogram.fig');
    %saveas(gcf, str);
    
    for numClusters = 2:dim
        % create 2D array
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
        
        % call all functions on each group
        pValArray = zeros(numClusters, 1);
        for r = 1:numClusters
            neuronArray = groups(r, :);
            neuronArray = nonzeros(neuronArray);
            neuronArray = neuronArray.';
            %p = call_all_functions_lateral(neuronArray);
            p = call_all_functions(neuronArray, r);
            pValArray(r, 1) = p;
        end
        
        % see if any of the p-values were significant
        sig = find(pValArray < 0.05);
        if(length(sig) > 0)
            continue;
        else
            idClusters = save_clusters(groups, region);
            break;
        end                
    end
    
    % create dendrogram of region
   
    dendrogram(clusters, dim);
    str = strcat('./output/', region, '_average_dendrogram.fig');
    saveas(gcf, str);
    
end