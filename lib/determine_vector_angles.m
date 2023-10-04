function angles = determine_vector_angles(fileName, nShufflesLabel, isUseShufflesLabel, nowDateStr)
% Function to calculate the angle between pairs of vectors (rows of a
% matrix) and save the results to file
    
    % Construct the input file path
    inputFileName = strcat('./data/', fileName);
    
    % Read the data depending on whether the shuffles label is used
    if isUseShufflesLabel
        rawDataWithLabelsCellArray = readcell(inputFileName);
        rawData = cell2mat(rawDataWithLabelsCellArray(2:end, 2:end));
    else
        rawData = readmatrix(inputFileName);
    end
    
    % Ccompute the angles between two vectors and store the results, where
    % a vector is a row in a matrix
    anglesData = compute_angle_between_vectors(rawData);
    
    % Determine the number of angle rows
    nAngleRows = size(anglesData, 1);
    angles = {};
    angleIndex = 1;
    
    % Determine the appropriate output file name
    if isUseShufflesLabel
        fullFileName = sprintf('./output/%s__angles_%s.xlsx', nShufflesLabel, nowDateStr);
    else
        fullFileName = sprintf('./output/%s__angles_%s.xlsx', fileName(1:end-5), nowDateStr);
    end

    % Write the angle data to the output file
    writematrix(anglesData, fullFileName);

    % Copy the output file to the data directory
    dataFileName = strcat('./data/', fullFileName(10:end));
    copyfile(fullFileName, dataFileName);
    
    % Store the angle data in a cell array
    for i = 1:nAngleRows
        angles{angleIndex} = anglesData(i, 3);
        angleIndex = angleIndex + 1;
    end % i

end % determine_vector_angles()