function columnNormalizedCellArray = column_normalized(originalCellArray)
% This function takes a cell array as input and returns a column-normalized cell array.

    % Get the number of rows and columns in the input cell array.
    [nRows, nCols] = size(originalCellArray);
    
    % Extract the numerical values from the input cell array, excluding the label row, the label column,
    % and the tract values (last) column.
    originalCellArrayNums = originalCellArray(2:nRows, 2:nCols-1);
    
    % Sum the numerical values in each column.
    sumCols = sum(cell2mat(originalCellArrayNums), 1);
    
    % Initialize the output cell array as the input cell array.
    columnNormalizedCellArray = originalCellArray;
    
    % Iterate through rows and columns (excluding the label row and the label and tract values columns)
    % to perform column normalization.
    for r = 2:nRows
       for c = 2:nCols-1
           % Divide each element by the sum of its corresponding column's values.
           columnNormalizedCellArray{r, c} = originalCellArray{r, c} / sumCols(1, c-1);
       end % c
    end % r
   
end % column_normalized()