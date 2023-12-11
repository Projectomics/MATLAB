% Function to analyze divergence of axonal projections based on clusterMatrix and regionStr
function analysis_divergence(clusterMatrix, regionStr)

    % Add library path
    addpath('./lib/');

    % Get the number of clusters
    nClusters = size(clusterMatrix, 1);
    
    % Loop through each cluster
    for clusterNo = 1:nClusters

        % Extract neurons for the current cluster
        tempNeurons = clusterMatrix(clusterNo, :);
        nNeurons = 0;
        
        % Count non-missing neurons
        for neuronNo = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(neuronNo), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        
        % Create an array containing non-missing neurons
        neuronArray = tempNeurons(1:nNeurons);

        % Generate a cluster name based on cluster number and neuron count
        clusterName = sprintf('%c%d', char(65+nClusters-clusterNo), nNeurons);

        % Create a filename for targeted parcels based on region and cluster
        targetedParcelsFileName = sprintf('./data/%s__divergence_parcels__cluster%s', regionStr, clusterName);
        
        % Read targeted parcels from the file
        targetedParcelsCellArray = readcell(targetedParcelsFileName);

        % Get the number of targeted parcels
        nTargetedParcels = length(targetedParcelsCellArray);

        % Create a cell array for Ipsi vs. Contralateral comparison
        targetedParcelIpsiVsContralateralCellArray = cell(2 * nTargetedParcels, 1);

        % Populate the Ipsi vs. Contralateral cell array
        for i = 1:nTargetedParcels
            targetedParcelIpsiVsContralateralCellArray{(2 * i) - 1} = strcat('(I) ', targetedParcelsCellArray{i});
            targetedParcelIpsiVsContralateralCellArray{(2 * i)} = strcat('(C) ', targetedParcelsCellArray{i});
        end

        % Call the divergence_get_length function for analysis
        divergence_get_length(neuronArray, targetedParcelIpsiVsContralateralCellArray, regionStr, ...
            clusterName);

        % Clear temporary arrays for the next iteration
        clear neuronArray;
        clear targetedParcelIpsiVsContralateralCellArray;

    end % Loop through clusters
    
end % analysis_divergence()