function morphologyMatrix = save_axon_summaries(morphologyMatrix, regionStr, nowDateStr)
% Function to save axonal information from MouseLight reconstructions and
% update the morphologyMatrix structure array

    % Generate filenames for saving data
    axonalCountsSummaryFileName = sprintf('./output/%s__axonal_counts_summary_%s.xlsx', regionStr, nowDateStr);    
    axonalParcelInvasionsFileName = sprintf('./output/%s__axonal_parcel_invasions_%s.xlsx', regionStr, nowDateStr); 
    
    % Get the number of rows and columns
    nRows = morphologyMatrix.nRows;
    nCols = morphologyMatrix.nCols;

    % Initialize cell arrays for the axonal counts summary and parcel invasions
    axonalCountsSummary{1}(1, 1) = {'Neurons'};
    axonalParcelInvasions{1}(1, 1) = {'Neurons'};
    axonalCountsSummary{1}(1, 2) = {'Location of Soma \ Parcels'};
    axonalParcelInvasions{1}(1, 2) = {'Location of Soma \ Parcels'};
    
    % Populate the first row with the parcel names for both summaries
    for col = 1:nCols
        axonalCountsSummary{1}(1, col+2) = morphologyMatrix.parcels(col);
        axonalParcelInvasions{1}(1, col+2) = morphologyMatrix.parcels(col);
    end

    % Store the axonal counts per parcel and soma locations
    for row = 1:nRows
        axonalCountsSummary{1}(row+1, 1) = morphologyMatrix.neuronTypes(row);
        axonalCountsSummary{1}(row+1, 2) = morphologyMatrix.matchedSomaLocations(row);
        
        % Populate the axonal counts for each parcel
        for col = 1:nCols
            axonalCountsSummary{1}(row+1, col+2) = num2cell(morphologyMatrix.axonCounts(row, col));
        end
    end

    % Initialize the fields for storing the axonal invasions
    morphologyMatrix.axonParcelInvasions = zeros(nRows, nCols);
    
    % Store the axonal invasions per parcel
    for row = 1:morphologyMatrix.nRows

        axonalParcelInvasions{1}(row+1, 1) = morphologyMatrix.neuronTypes(row);
        axonalParcelInvasions{1}(row+1, 2) = morphologyMatrix.matchedSomaLocations(row);

        for col = 1:morphologyMatrix.nCols
            if (morphologyMatrix.axonCounts(row, col) > 0)
                morphologyMatrix.axonParcelInvasions(row, col) = 1;
                axonalParcelInvasions{1}(row+1, col+2) = num2cell(1);
            else
                morphologyMatrix.axonParcelInvasions(row, col) = 0;
                axonalParcelInvasions{1}(row+1, col+2) = num2cell(0);
            end
        end % col

        % Calculate and store the total regions invaded
        totalRegions = sum(morphologyMatrix.axonParcelInvasions(row, :));
        morphologyMatrix.totalRegionsInvaded(row) = totalRegions;
        axonalParcelInvasions{1}(row+1, nCols+3) = num2cell(totalRegions);

    end % row
    
    % Write the axonal invasions per parcel to an Excel file
    writecell(axonalParcelInvasions{1}, axonalParcelInvasionsFileName);

    % Store the summary tallies
    axonalCountsSummary{1}(nRows+2, 1) = {'Total Axonal Data Points'};
    axonalCountsSummary{1}(nRows+2, 2) = {'-'};
    totalAxonData = sum(morphologyMatrix.axonCounts);
    for col = 1:nCols
        axonalCountsSummary{1}(nRows+2, col+2) = num2cell(totalAxonData(col));
    end
    axonalCountsSummary{1}(nRows+3, 1) = {'Total Parcel Invasions'};
    axonalCountsSummary{1}(nRows+3, 2) = {'-'};
    totalParcelInvasions = sum(morphologyMatrix.axonParcelInvasions);
    for col = 1:nCols
        axonalCountsSummary{1}(nRows+3, col+2) = num2cell(totalParcelInvasions(col));
    end
    axonalCountsSummary{1}(nRows+4, 1) = {'Total Somata'};
    axonalCountsSummary{1}(nRows+4, 2) = {'-'};
    totalSomata = sum(morphologyMatrix.somaCounts);
    for col = 1:nCols
        axonalCountsSummary{1}(nRows+4, col+2) = num2cell(totalSomata(col));
    end

    % Write the axonal counts summary to an Excel file
    writecell(axonalCountsSummary{1}, axonalCountsSummaryFileName);

end % save_axon_summaries()