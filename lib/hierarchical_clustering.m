function hierarchical_clustering(anglesFileName, dataFileNameBase, nShufflesLabel, nShuffles, isUseOriginalAlgorithm)
% Function to perform unsupervised hierarchical clustering based on
% Levene's statistical test for comparison of variances to decide if a
% splitting in the dendrogram is significant and should be continued

    % Add required path
    addpath('./lib/');
           
    fprintf('\nLoading vector angles ...\n\n');
    
    % Read angles between vector pairs
    anglesFileNameFull = sprintf('./data/%s', anglesFileName);
    
    rawData = readmatrix(anglesFileNameFull);
    nRows = size(rawData, 1);   

    fprintf('Saving dendrogram ...\n\n');

    % Create a full-screen figure
    figure('units', 'normalized', 'outerposition', [0 0 1 1]);

    % Format data and create hierarchical clustering tree + dendrogram
    dim = rawData(nRows, 2); 
    angles = rawData(:, 3).';
    info = linkage(angles, 'average');
    dendrogram(info, dim);
    str = strcat('./output/', nShufflesLabel, '__average_dendrogram.fig');
    saveas(gcf, str);
    
    pngPlotFileName = strcat('./output/', nShufflesLabel, '__average_dendrogram.png');
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    % Matrix with final class divisions/clusters that showed insignificant results
    insigClusters = zeros(dim, dim);
    insigRow = 0;
    
    % Input and process the original matrix file
    reply = strcat(dataFileNameBase, '.xlsx');
    originalMatrixWithLabelsCellArray = readcell(strcat('./data/', reply));
    originalMatrix = cell2mat(originalMatrixWithLabelsCellArray(2:end, 2:end));
       
    fprintf('Determining neuron clusters ...\n\n');

    % Increment the number of cluster subdivisions starting from 2 clusters
    for nClusters = 2:dim
        % Create 2D array ("groups") where neurons are divided into clusters 
        %
        % Call all functions on each subcluster UNLESS the neurons from the
        % subcluster are already found in insigClusters
        for clusterNo = 1:nClusters

            neuronArray = groups(clusterNo, :);
            nonZeroNeuronArray = nonzeros(neuronArray);
            nonZeroNeuronArray = nonZeroNeuronArray.'; % array of neurons in subcluster
            
            % If neurons in this subcluster do not already belong to a final class
            if (~(ismember(nonZeroNeuronArray(1), insigClusters)))

                % Call Levene's statistical test on the neurons of the
                % cluster and retrieve the p-value
                p = apply_Levene_test(nonZeroNeuronArray, originalMatrix, nShuffles, isUseOriginalAlgorithm); 

                % If p value is not significant, add the neurons of this
                % class to the final class division array
                if (p > 0.05)
                    insigRow = insigRow + 1;
                    insigClusters(insigRow, :) = neuronArray;
                end

            end % if ~ismember

        end % clusterNo
        
        % Save clusters to a spreadsheet once all the neurons are divided
        nNonzeroMatrixElements = nnz(insigClusters);
        if (nNonzeroMatrixElements == dim)
            neuronNamesByClusterFileName = save_clusters(insigClusters, dataFileNameBase);
            break;
        else
            continue;
        end  

    end % nClusters
    
    % Save to file the axonal point counts broken down by parcel and cluster
    save_axonal_counts_per_parcel_per_cluster(neuronNamesByClusterFileName, originalMatrixWithLabelsCellArray);

end % hierarchical_clustering()