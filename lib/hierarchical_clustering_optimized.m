function idClusters = hierarchical_clustering_optimized(fileName, region, nShuffles)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
           
    strng = sprintf('\nLoading neuron distances ...\n');
    disp(strng);
       
    %reads in file with angles/differences between neuron pairs
    fileNameFull = sprintf('./data/%s', fileName);
    
    rawData = readmatrix(fileNameFull);
    [nRows, nCols] = size(rawData);   

    %format data and create hierarchical clustering tree + dendrogram
    dim = rawData(nRows, 2); 
    distances = rawData(:, 3).';
    info = linkage(distances, 'average');
    dendrogram(info, dim);
    str = strcat('./output/', region, '_average_dendrogram.fig');
    saveas(gcf, str);
    
    %matrix with final class divisions/clusters that showed insignificant results
    insigClusters = zeros(dim, dim);
    insigRow = 0;
    
    %input and process bin/raw matrix file
    disp('Enter Bin Matrix File');
    reply = [];
    while (isempty(reply)) % enter filtered binary/raw matrix for region
        reply = select_csvFileName('Select original data file:');
        if strcmp(reply, '!')
            disp('Exiting');
        else
            fid2 = fopen(strcat('./data/', reply));
            if(fid2 == -1)
                reply = [];
            else
                fclose(fid2);
            end
        end
    end
    rawBinMatrix = readmatrix(strcat('./data/', reply));
       
    % Increment number of cluster subdivisions starting from 2 clusters
    for numClusters = 2:dim
        % Create 2D array ("groups") where neurons are divided into clusters 
        % In this array, each row indicates each cluster and columns
        % indicate each neuron number
        %
        % Example: say there are 4 neurons that we want to divide into 2
        % clusters, "groups" should look something like this 
        % [1, 2; 3, 4] --> neurons 1+2 in row 1 are part of 1 subcluster,
        % while neurons 3+4 in row 2 are part of the 2nd subcluster
        %
        % cluster() defines clusters from an agglomerative hierarchical
        % cluster tree info
        %
        % MaxClust defines a maximum of numClusters clusters using
        % 'distance' as the criterion for defining clusters
        temp = cluster(info, 'MaxClust', numClusters);
        groups = zeros(numClusters, dim);
        % First pass through, length(temp) = dim = number of neurons
        for i = 1:dim
            row = temp(i);
            for j = 1:dim
                if(groups(row, j) == 0)
                    col = j;
                    break;
                end
            end
            groups(row, col) = i;
        end

        % Call all functions on each subcluster (each row of "groups") UNLESS any neurons from the
        % subcluster are already found in insigClusters, since these neurons
        % have already shown insignificant results and been placed in their
        % final class divisions
        for r = 1:numClusters
            neuronArray = groups(r, :);
            nonZeroNeuronArray = nonzeros(neuronArray);
            nonZeroNeuronArray = nonZeroNeuronArray.'; % array of neurons in subcluster
            
            % if neurons in this subcluster do not already belong to a final class
            if (~(ismember(nonZeroNeuronArray(1), insigClusters)))
                % Call the technique on the neurons of the cluster, and
                % retrieve the p-value
                p = call_all_functions_raw(nonZeroNeuronArray, rawBinMatrix, nShuffles); 

                % If p value is not significant, add the neurons of this
                % class to the final class division array
                if (p > 0.05)
                    insigRow = insigRow + 1;
                    insigClusters(insigRow, :) = neuronArray;
                end
            end      
        end % r
        
        % once all neurons have been divided into the final class
        % divisions, save the clusters to a spreadsheet
        nNonzeroMatrixElements = nnz(insigClusters);
        if (nNonzeroMatrixElements == dim)
            idClusters = save_clusters(insigClusters, region);
            break;
        else
            continue;
        end  

    end % for numClusters
    
end % hieraarchical_clustering_optimized()