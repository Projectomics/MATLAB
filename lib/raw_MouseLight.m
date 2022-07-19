function differences = raw_MouseLight(fileName, nShufflesLabel, isUseShufflesLabel)

    inputFileName = strcat('./data/', fileName);
    rawData = readmatrix(inputFileName);
    [nRows, nCols] = size(rawData);    
    differencesData = raw_angle_double(rawData);
    %differencesData = raw_differences_double(binaryData);
    
    nDiffRows = size(differencesData, 1);
    differences = {};
    diffIndex = 1;
    
    if isUseShufflesLabel
        fullFileName = sprintf('./output/%s_differences_doublesAxon_%s.csv', nShufflesLabel, datestr(now, 'yyyymmddHHMMSS'));
    else
        fullFileName = sprintf('./output/%s_differences_doublesAxon_%s.csv', fileName(1:end-4), datestr(now, 'yyyymmddHHMMSS'));
    end
    dataFileName = ['./data/', fullFileName(10:end)];
    fid = fopen(fullFileName, 'w');
    for i = 1:nDiffRows
        fprintf(fid, '%d,%d,%d\n', differencesData(i, 1), differencesData(i, 2), differencesData(i, 3));
        differences{diffIndex} = differencesData(i, 3);
        diffIndex=diffIndex+1;
    end % i
    fclose(fid);

    copyfile(fullFileName, dataFileName);
    
end % MouseLight()