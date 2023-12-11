% Function to analyze convergence of onto clusters from specified parcels
function analysis_convergence(clusterMatrix, convergingParcelsCellArray, regionStr)

    % Add required paths for library functions
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    % Calculate the number of converging parcels
    nConvergingParcels = length(convergingParcelsCellArray);

    % Create cell array for ipsilateral vs contralateral labels
    convergingParcelIpsiVsContralateralCellArray = cell(2 * nConvergingParcels);

    % Populate the cell array with labels for ipsilateral and contralateral
    for i = 1:nConvergingParcels
        convergingParcelIpsiVsContralateralCellArray{(2 * i) - 1} = strcat('(I) ', convergingParcelsCellArray{i});
        convergingParcelIpsiVsContralateralCellArray{(2 * i)} = strcat('(C) ', convergingParcelsCellArray{i});
    end

    % Get the number of clusters and generate cluster names
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
        clusterNames{c} = sprintf('%c%d', char(65 + nClusters - c), nNeurons);
    end % c (nClusters)

    % Iterate over each converging parcel
    for i = 1:(2 * nConvergingParcels)
        convergingParcel = convergingParcelIpsiVsContralateralCellArray{i};

        % Get distances to all points in the converging parcel
        [distancesToAllPointsInParcelArray, nowDateStr] = convergence_get_length(clusterMatrix, ...
            convergingParcel, regionStr, clusterNames);

        % Initialize variables for boxplot
        maxBoxPlot = 0;
        nPointsInParcelArray = length(distancesToAllPointsInParcelArray);

        % Find the maximum number of points in a parcel for boxplot matrix
        for j = 1:nPointsInParcelArray
            maxPointsInParcelArray(j) = length(distancesToAllPointsInParcelArray{j});
            if (maxPointsInParcelArray(j) > maxBoxPlot)
                maxBoxPlot = maxPointsInParcelArray(j);
            end
        end

        % Initialize boxplot matrix with NaN
        boxPlotMatrix = NaN(maxBoxPlot, nPointsInParcelArray);

        % Populate boxplot matrix with distances
        for j = 1:nPointsInParcelArray
            boxPlotMatrix(1:maxPointsInParcelArray(j), j) = cell2mat(distancesToAllPointsInParcelArray(j));
        end

        % Create boxplot for the distances
        figure(i);
        boxplot(boxPlotMatrix);

        % Save boxplot figure in .fig format
        boxplotFilename = sprintf('./output/%s__convergence_box_and_whisker_plot__%s_%s.fig', ...
            regionStr, convergingParcel, nowDateStr);
        saveas(gcf, boxplotFilename);
        
        % Save boxplot figure in .png format
        pngPlotFileName = sprintf('./output/%s__convergence_box_and_whisker_plot__%s_%s.png', ...
            regionStr, convergingParcel, nowDateStr);
        print(gcf, '-dpng', '-r800', pngPlotFileName);
        
        % Analyze path distances using Wilcoxon test and FDR correction
        analyze_path_distances_using_Wilcoxon_test_and_FDR(distancesToAllPointsInParcelArray, ...
               clusterNames, convergingParcel, nowDateStr, regionStr);

    end % i

end % analysis_convergence()