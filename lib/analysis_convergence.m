function analysis_convergence(clusterMatrix, convergingParcelsCellArray, regionStr)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    nConvergingParcels = length(convergingParcelsCellArray);

    convergingParcelIpsiVsContralateralCellArray = cell(2*nConvergingParcels);

    for i = 1:nConvergingParcels

        convergingParcelIpsiVsContralateralCellArray{(2*i)-1} = strcat('(I) ', convergingParcelsCellArray{i});
        convergingParcelIpsiVsContralateralCellArray{(2*i)} = strcat('(C) ', convergingParcelsCellArray{i});
    
    end

    nClusters = size(clusterMatrix, 1);
    clusterNames = cell(nClusters);

    for c = 1:nClusters

        tempNeurons = clusterMatrix(c, :);
        nNeurons = 0;
        for n = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(n), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        clusterNames{c} = sprintf('%c%d', char(65+nClusters-c), nNeurons);

    end % c (nClusters)

    for i = 1:(2*nConvergingParcels)
       convergingParcel = convergingParcelIpsiVsContralateralCellArray{i};

       [distancesToAllPointsInParcelArray, nowDateStr] = convergence_get_length(clusterMatrix, ...
           convergingParcel, regionStr, clusterNames);

       analyze_path_distances_using_Wilcoxon_test_and_FDR(distancesToAllPointsInParcelArray, ...
           clusterNames, convergingParcel, nowDateStr, regionStr);
    end % i

end % analysis_convergence()