function xVector = nnls(dataCellArray, dataFileName)
% Function to compute the non-negative least squares of a matrix of data
% values with an accompanying column of tract values

    % Add the library path for custom functions
    addpath('./lib/');

    % Store the current date and time in a string
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

    % Apply bi-normalization to the input data
    biNormalizedDataCellArray = binormalized(dataCellArray, dataFileName, nowDateStr);

    % Get the dimensions of the bi-normalized data
    [nRows, nCols] = size(biNormalizedDataCellArray);

    % Extract the bi-normalized data values for computation
    biNormalizedNums = cell2mat(biNormalizedDataCellArray(2:nRows, 2:nCols-1));

    % Extract the normalized tract values for computation
    normalizedTractValues = cell2mat(biNormalizedDataCellArray(2:nRows, nCols));

    % Perform non-negative least squares optimization
    [xVector, residualNorm] = lsqnonneg(biNormalizedNums, normalizedTractValues);

    % Create filenames for saving the results
    xVectorFileName = sprintf('./output/%s__X_vector_%s.xlsx', dataFileName(1:end-5), nowDateStr);
    residualNormFileName = sprintf('./output/%s__residual_norm_%s.xlsx', dataFileName(1:end-5), nowDateStr);

    % Write the computed xVector to an Excel file
    writematrix(xVector, xVectorFileName);

    % Write the computed residual norm to an Excel file
    writematrix(residualNorm, residualNormFileName);

end % nnls()