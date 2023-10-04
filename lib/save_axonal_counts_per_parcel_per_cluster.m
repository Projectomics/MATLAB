function save_axonal_counts_per_parcel_per_cluster(neuronNamesByClusterFileName, originalMatrixWithLabels)
% Function to save to file the axonal point counts broken down by parcel and cluster

    fprintf('Saving axonal counts per parcel per cluster ...\n');

    % Read neuron names by cluster from the specified file
    neuronNamesByClusterCellArray = readcell(neuronNamesByClusterFileName);

    % Extract dimensions of the original matrix with labels
    [nNeuronsPlusOne, nParcelsPlusOne] = size(originalMatrixWithLabels);

    % Initialize a cell array to store the axonal counts per parcel per cluster
    axonalCountsPerParcelPerClusterCellArray = cell(nParcelsPlusOne, nClusters+1);

    % Set the header for the first cell of the cell array
    axonalCountsPerParcelPerClusterCellArray(1, 1) = {'Parcels \ Clusters'};

    clusterNames = cell(nClusters);
    nNeuronsPerCluster = zeros(nClusters, 1);

    % Iterate through the clusters to process and populate data
    for clusterNo = 1:nClusters

        tempNeurons = neuronNamesByClusterCellArray(clusterNo, :);
        nNeuronsPerCluster(clusterNo) = 0;
        for n = 1:length(tempNeurons)
            % Count non-missing neurons
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(n), 'UniformOutput', false)))
                nNeuronsPerCluster(clusterNo) = nNeuronsPerCluster(clusterNo) + 1;
            end
        end
        clusterNames{clusterNo} = sprintf('%c%d', char(65+nClusters-clusterNo), nNeuronsPerCluster(clusterNo));

        % Populate the header for the cluster names
        axonalCountsPerParcelPerClusterCellArray(1, clusterNo+1) = clusterNames(clusterNo);

    end % clusterNo

    % Iterate through the parcels to populate the axonal counts
    for parcelNo = 2:nParcelsPlusOne

        % Populate the first cell of the row with the parcel name
        axonalCountsPerParcelPerClusterCellArray(parcelNo, 1) = originalMatrixWithLabels(1, parcelNo);

        % Iterate through the clusters to calculate the axonal counts
        for clusterNo = 1:nClusters

            axonalCountsSum = 0;

            % Iterate through the neurons in the cluster
            for neuronsPerClusterNo = 1:nNeuronsPerCluster(clusterNo)

                neuronStr = neuronNamesByClusterCellArray{neuronsPerClusterNo};

                % Iterate through the neurons to find matching neuron names
                for neuronNo = 2:nNeuronsPlusOne

                    if strcmp(originalMatrixWithLabels{neuronNo, 1}, neuronStr)
                        axonalCountsSum = axonalCountsSum + cell2mat(originalMatrixWithLabels(neuronNo, parcelNo));
                    end % if strcmp

                end % neuronNo

            end % neuronPerClusterNo

            % Store the calculated axonal count in the cell array
            axonalCountsPerParcelPerClusterCellArray(parcelNo, clusterNo+1) = {axonalCountsSum};

        end % clusterNo

    end % parcelNo

    % Extract the relevant portion of the filename for saving
    underscoresIdx = strfind(neuronNamesByClusterFileName, '_');

    % Construct the final filename for saving
    axonalCountsPerParcelPerClusterFileName = sprintf('%s__axonal_counts_per_parcel_per_cluster_%s', ...
        neuronNamesByClusterFileName(1:underscoresIdx(2)-1), neuronNamesByClusterFileName(end-18:end));

    % Write the calculated data to a new spreadsheet
    writecell(axonalCountsPerParcelPerClusterCellArray, axonalCountsPerParcelPerClusterFileName);

end % save_axonal_counts_per_parcel_per_cluster()