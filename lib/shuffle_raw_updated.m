function fileNameShuffled = shuffle_raw_updated(inputFile, region, nShuffles)

    addpath('./lib/');

    inputFilePath = './data/';
    outputFilePath = './output/';

    inputFileName = strcat(inputFilePath, inputFile);
    raw = readmatrix(inputFileName);

    matrix = shuffle_matrix(raw, nShuffles);

    tag = 'fullyShuffled';

    nowStr = datestr(now, 'yyyymmddHHMMSS');
    fileNameShuffled = sprintf('%s_matrix_%s_%s.csv', region, tag, nowStr);

    % save a copy to the data folder
    inFile = strcat(inputFilePath, fileNameShuffled);
    writematrix(matrix, inFile);
    
    % save a copy to the output folder
    outFile = strcat(outputFilePath, fileNameShuffled);
    writematrix(matrix, outFile);
    
end % shuffle_raw_updated()
