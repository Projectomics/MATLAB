function fileNameShuffled = shuffle_data(inputFile, nShufflesLabel, nShuffles, isUseOriginalAlgorithm)
% Function to randomize a matrix a user-selected number of times using one
% of two algorithms and save the resulting shuffled matrix to an Excel file

    % Add the library path
    addpath('./lib/');

    % Define input and output file paths
    inputFilePath = './data/';
    outputFilePath = './output/';

    % Generate the full input file name
    inputFileName = strcat(inputFilePath, inputFile);
    
    % Read the original matrix with labels from the input file
    originalMatrixWithLabelsCellArray = readcell(inputFileName);

    % Separate out the data values from the labels in the first row and
    % first column
    originalMatrix = cell2mat(originalMatrixWithLabelsCellArray(2:end, 2:end));

    % Shuffle the original matrix a user-selected number of times using one
    % of two algorithms
    shuffledMatrix = shuffle_matrix(originalMatrix, nShuffles, isUseOriginalAlgorithm);

    % Generate a timestamp for the output file name
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');
    fileNameShuffled = sprintf('%s__fully_shuffled_%s.xlsx', nShufflesLabel, nowDateStr);

    % Save a copy of the shuffled matrix to the data folder
    inFile = strcat(inputFilePath, fileNameShuffled);
    writematrix(shuffledMatrix, inFile);
    
    % Save a copy of the shuffled matrix to the output folder
    outFile = strcat(outputFilePath, fileNameShuffled);
    writematrix(shuffledMatrix, outFile);

end % shuffle_data