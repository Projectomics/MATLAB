function filteredMatrix = filter_matrix(morphologyMatrix, regionStr, nowDateStr)
% Function to remove all the parcel columns with no axonal counts in the
% morphologyMatrix structure array

    % Initialize the filtered matrix with axonCounts and parcels
    filteredMatrix.axonCounts = zeros(morphologyMatrix.nRows, morphologyMatrix.nCols);
    filteredMatrix.parcels = {'parcels'};
    
    % Calculate the sum of the axon counts for each parcel
    sumCols = sum(morphologyMatrix.axonCounts);
    
    % Initialize a counter for the columns in the filtered matrix
    filteredCol = 1;
    
    % Iterate through each column in the original matrix
    for c = 1:morphologyMatrix.nCols

        % Check if the sum of the axon counts for the parcel is zero
        if (sumCols(c) == 0)
            % Skip columns with zero axon counts
            continue
        else
            % Copy the axon counts and parcel name for non-zero columns
            for r = 1:morphologyMatrix.nRows
                filteredMatrix.axonCounts(r, filteredCol) = morphologyMatrix.axonCounts(r, c);
                filteredMatrix.parcels(filteredCol) = morphologyMatrix.parcels(c);
            end
            filteredCol = filteredCol + 1;
        end

    end % c
    
    % Update the number of rows and columns in the filtered matrix
    filteredMatrix.nRows = morphologyMatrix.nRows;
    filteredMatrix.nCols = filteredCol - 1;
    
    % Generate a filename for saving the filtered parcel names
    fileName = sprintf('./output/%s__filtered_parcels_%s.xlsx', regionStr, nowDateStr);
    
    % Write the filtered parcel names to an Excel file
    writecell(filteredMatrix.parcels', fileName);

end % filter_matrix