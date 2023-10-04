function rowNormalizedCellArray = row_normalized(originalCellArray)
% This function takes a cell array as input and returns a row-normalized cell array.

    % Get the number of rows and columns in the input cell array.
    [nRows, nCols] = size(originalCellArray);
    
    % Extract the numerical values from the input cell array, excluding the label row, the label column,
    % and the tract values (last) column.
    originalCellArrayNums = originalCellArray(2:nRows, 2:nCols-1);

    % Sum the numerical values in each row.
    sumRows = sum(cell2mat(originalCellArrayNums), 2);
    
    % Initialize the output cell array as the input cell array.
    rowNormalizedCellArray = originalCellArray;
    
    % Iterate through rows and columns (excluding the label row and the label and tract values columns)
    % to perform row normalization.
    for r = 2:nRows
       for c = 2:nCols-1
           % Divide each element by the sum of its corresponding row's values.
           rowNormalizedCellArray{r, c} = originalCellArray{r, c} / sumRows(r-1, 1) ;
       end % c
    end % r

end % row_normalized()