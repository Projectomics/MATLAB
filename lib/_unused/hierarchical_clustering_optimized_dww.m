function idClusters = hierarchical_clustering_optimized(fileName, region, nShuffles)
           
    strng = sprintf('\nLoading neuron distances ...\n');
    disp(strng);
       
    %reads in file with angles/differences between neuron pairs
    fileNameFull = sprintf('./data/%s', fileName);
    
    rawData = readmatrix(fileNameFull);
    [nRows, nCols] = size(rawData);

    %format data and create hierarchical clustering tree + dendrogram
    nNeurons = rawData(nRows, 2);
    distances = rawData(:, 3).';

    % linkage: returns a matrix that encodes a tree containing hierarchical clusters of the rows of the input data matrix
    hierarchicalClusters = linkage(distances, 'average');

    % dendrogram: generates a dendrogram plot with no more than nNeurons leaf nodes
    dendrogram(hierarchicalClusters, nNeurons);
    str = strcat('./output/', region, '_average_dendrogram_', datestr(now, 'yyyymmddHHMMSS'), '.fig');
    saveas(gcf, str);

    % input and process bin/raw matrix file
%    disp('Enter Bin Matrix File');
    reply = [];
    while (isempty(reply)) % enter filtered binary/raw matrix for region
%        reply = select_csvFileName('Select original data file:');
%        reply = 'Presubiculum_raw_morphologyMatrix_20201005092953.csv';
	    reply = 'test_data.csv';
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
       
    % matrix with final class divisions/clusters that showed insignificant results
    insigClusters = zeros(nNeurons, nNeurons);
    insigRow = 0;

    logFile = sprintf('./output/log_%s_%s.txt', region, datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(logFile, 'w');
    fclose(fid);
    
    % Increment number of cluster subdivisions starting from 2 clusters
    for numClusters = 2:nNeurons
    	fid = fopen(logFile, 'a');
    
        % cluster() defines clusters from an agglomerative hierarchical
        % cluster tree "hierarchicalClusters"
        %
        % MaxClust defines a maximum of numClusters clusters using
        % 'distance' as the criterion for defining clusters
        %
        % "temp" is an array of cluster assignments based on "numClusters"
        % number of clusters for all "nNeurons" number of neurons
        temp = cluster(hierarchicalClusters, 'MaxClust', numClusters);

        % Create 2D array ("tempClusters") where neurons are divided into clusters 
        % In this array, each row indicates each cluster and columns
        % indicate each neuron number
        %
        % Example: say there are 4 neurons that we want to divide into 2
        % clusters, "tempClusters" should look something like this 
        % [1, 2; 3, 4] --> neurons 1+2 in row 1 are part of 1 subcluster,
        % while neurons 3+4 in row 2 are part of the 2nd subcluster
        tempClusters = zeros(numClusters, nNeurons);

        for i = 1:nNeurons
            row = temp(i);
            for j = 1:nNeurons
                if (tempClusters(row, j) == 0)
                    col = j;
                    break;
                end
            end
            tempClusters(row, col) = i;
        end

        % Call all functions on each subcluster (each row of
        % "tempClusters") UNLESS any neurons from the subcluster are
        % already found in insigClusters, since these neurons have already
        % shown insignificant results and been placed in their final class
        % divisions
        for row = 1:numClusters
            % array of neurons in subcluster
            neuronArray = tempClusters(row, :);
            nonZeroNeuronArray = nonzeros(neuronArray).';

            fprintf(fid, 'nClusters = %d; row = %d\n', numClusters, row);

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

	    if (0)
            
            % check if neurons in this subcluster do not already belong to
            % a final class
            significantFlag = 1;
            significantArray = zeros(1, length(nonZeroNeuronArray));
            for i = 1:length(nonZeroNeuronArray)
                significantArray(i) = ~(ismember(nonZeroNeuronArray(i), insigClusters));
            end % i
            significantFlag = (sum(significantArray) == length(nonZeroNeuronArray));
%            disp(sprintf('nClusters = %d; row = %d; significantFlag = %d', numClusters, row, significantFlag));
            fprintf(fid, 'nClusters = %d; row = %d; significantFlag = %d\n', numClusters, row, significantFlag);
            if significantFlag
%            if (~(ismember(nonZeroNeuronArray(1), insigClusters)))
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

	    end

        end % row
        
        % once all neurons have been divided into the final class
        % divisions, save the clusters to a spreadsheet
        nNonzeroInsignificantNeurons = nnz(insigClusters);
%        disp(sprintf('# of insignificant neurons = %d out of %d', nNonzeroInsignificantNeurons, nNeurons));
        fprintf(fid, '# of insignificant neurons = %d out of %d\n', nNonzeroInsignificantNeurons, nNeurons);
        if (nNonzeroInsignificantNeurons == nNeurons)
            idClusters = save_clusters(insigClusters, region);
            break;
        else
            continue;
        end  

	fclose(fid);

    end % for numClusters
    
end % hieraarchical_clutsering_optimized()