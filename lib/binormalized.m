function biNormalizedCellArray = binormalized(originalCellArray, originalCellArrayFileName, nowDateStr)
% This function performs bi-normalization on an original cell array using specified normalization schemes.

    fprintf('\n\"Bi-normalizing\" data cell array ...\n');

    % Get the number of rows and columns in the original cell array.
    [nRows, nCols] = size(originalCellArray);    

    % Perform row normalization on the original cell array.
    rowNormalizedCellArray = row_normalized(originalCellArray);
    
    % Create the file name for the output row-normalized cell array
    outputFileName = sprintf('./output/%s__row_normalized_%s.xlsx', originalCellArrayFileName(1:end-5), nowDateStr);

    % Write the row-normalized cell array to file
    writecell(rowNormalizedCellArray, outputFileName);

    % Perform a scaling on the row-normalized cell array
    scaledCellArray = scaled_cell_array(rowNormalizedCellArray);
    
    % Create the file name for the output scaled cell array
    outputFileName = sprintf('./output/%s__scaled_%s.xlsx', originalCellArrayFileName(1:end-5), nowDateStr);

    % Write the scaled cell array to file
    writecell(scaledCellArray, outputFileName);
    
    % Perform column normalization on the scaled cell array.
    columnNormalizedCellArray = column_normalized(scaledCellArray);

    % Create the file name for the column-normalized cell array
    outputFileName = sprintf('./output/%s__column_normalized_%s.xlsx', originalCellArrayFileName(1:end-5), nowDateStr);

    % Write the column-normalized cell array to file
    writecell(columnNormalizedCellArray, outputFileName);
    
    % Initialize the bi-normalized cell array as the column-normalized cell array.
    biNormalizedCellArray = columnNormalizedCellArray;

    % Apply tract normalization on the last column of the bi-normalized cell array.
    biNormalizedCellArray(2:nRows, nCols) = normalize_tracts(columnNormalizedCellArray(2:nRows, nCols));

    % Create the file name for the bi-normalized cell array
    outputFileName = sprintf('./output/%s__bi_normalized_%s.xlsx', originalCellArrayFileName(1:end-5), nowDateStr);

    % Write the bi-normalized cell array to file
    writecell(biNormalizedCellArray, outputFileName);
    
end % binormalized()