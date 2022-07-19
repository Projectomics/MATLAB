function validate_hierarchical_clustering(fileName, region, setA, differencesA)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    %clear all;
           
    strng = sprintf('\nLoading neuron distances ...\n');
    disp(strng);
    
    rawData = differencesA;
    [nRows, nCols] = size(rawData);

    %dim = str2num(cell2mat(rawData(nRows, 2)));
    dim = rawData(nRows, 2);
    squareMat = zeros(dim, dim);
    for i = 1:nRows
        row = rawData(i, 1);
        col = rawData(i, 2);
        value = rawData(i, 3);
        squareMat(row, col) = value;
        squareMat(col, row) = value;
    end
    distances = squareform(squareMat);    
    clusters = linkage(distances, 'average');
    %T = cluster(clusters,'maxclust',3); 
    
    dendrogram(clusters, dim);
    str = strcat('./output/', region, '_average_dendrogram.fig');
    saveas(gcf, str);
    
    for numClusters = 1:dim
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
            groups(row, col) = setA(i);
        end
        
        % call all functions on each group
        pValArray = zeros(numClusters, 1);
        for r = 1:numClusters
            neuronArray = groups(r, :);
            neuronArray = nonzeros(neuronArray);
            %neuronArray = neuronArray.';
            shuffledArray = zeros(length(neuronArray), 1);
            [range, start] = validate_shuffle_range(neuronArray);
            for i = 1:length(shuffledArray)
                %shuffledArray(i) = rand * 2 -1;
                shuffledArray(i) = rand * range + start;
            end
            [setADistances, differences] = validate_analysis(neuronArray, 'A_clustering');
            [shuffledDistances, differences] = validate_analysis(shuffledArray, 'shuffled_clustering');
            [h, p, ci, stats] = vartest2(cell2mat(setADistances), cell2mat(shuffledDistances), 'Tail', 'right');
            pValArray(r, 1) = p;
        end
        
        % see if any of the p-values were significant
        sig = find(pValArray < 0.05);
        if(length(sig) > 0)
            continue;
        else
            save_clusters(groups, region);
            break;
        end                
    end
    
    % create dendrogram of region
   
    dendrogram(clusters, dim);
    str = strcat('./output/', region, '_average_dendrogram.fig');
    saveas(gcf, str);
    
end