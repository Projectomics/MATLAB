function scaledCellArray = scaled_cell_array(originalCellArray)
% This function takes a cell array as input and returns a row-normalized cell array.

    % Get the number of rows and columns in the input cell array.
    [nRows, nCols] = size(originalCellArray);
    
    % Calculate the number of regions by subtracting 1 from the number of rows.
    nRegions = nRows - 1;
        
    % Calculate the number of clusters by subtracting 2 to ignore the label column and tract values column.
    nClusters = nCols - 2;

    % Initialize the scaled cell array based on the row-normalized cell array.
    scaledCellArray = originalCellArray;

    % Iterate through rows and columns (excluding the label row and the label and tract values columns)
    % to perform scaling.
    for r = 2:nRows
       for c = 2:nCols-1
           % Scale the values in the cell array using the number of clusters and regions.
           scaledCellArray{r, c} = originalCellArray{r, c} * nClusters / nRegions;
       end % c
    end % r

end % scaled_cell_array()