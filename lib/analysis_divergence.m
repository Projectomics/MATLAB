function analysis_divergence(clusterMatrix, regionStr)

    addpath('./lib/');
    
    nClusters = size(clusterMatrix, 1);
    
    for clusterNo = 1:nClusters

        tempNeurons = clusterMatrix(clusterNo, :);
        nNeurons = 0;
        for neuronNo = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(neuronNo), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        neuronArray = tempNeurons(1:nNeurons);

        clusterName = sprintf('%c%d', char(65+nClusters-clusterNo), nNeurons);

        targetedParcelsFileName = sprintf('./data/%s__divergence_parcels__cluster%s', regionStr, clusterName);
        targetedParcelsCellArray = readcell(targetedParcelsFileName);

        nTargetedParcels = length(targetedParcelsCellArray);

        targetedParcelIpsiVsContralateralCellArray = cell(2*nTargetedParcels, 1);

        for i = 1:nTargetedParcels

            targetedParcelIpsiVsContralateralCellArray{(2*i)-1} = strcat('(I) ', targetedParcelsCellArray{i});
            targetedParcelIpsiVsContralateralCellArray{(2*i)} = strcat('(C) ', targetedParcelsCellArray{i});
        
        end

        divergence_get_length(neuronArray, targetedParcelIpsiVsContralateralCellArray, regionStr, ...
            clusterName);

        clear neuronArray;
        clear targetedParcelIpsiVsContralateralCellArray;

    end % r (nRows)
    
end % analysis_divergence()