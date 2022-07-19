function fileName = shuffle_raw_laterality(inputFile, region, filteredRawMatrix)
    %clear all;

    addpath('./lib/');
    addpath('./output');
    addpath('../dir_MouseLight_ASSIP/lib/');

    outfile = sprintf('./output/%s', inputFile);
    fid = fopen(outfile, 'r');
    matrixIn = textscan(fid, '%d', 'delimiter', ',');
    fclose(fid);

    %nRows = 96;
    %nCols = 50;
    raw = open_raw_data_file(inputFile);
    [nRows, nCols] = size(raw);

    isRandom = 0;
    isLeftShifted = 0;
    isRightShifted = 0;
    isLeftRightShifted = 0;
    isFullShuffle = 1;
    nOnes = 1113;
    
    %converting data from a cell array to a matrix
    c = 0;
    for i = 1:nRows
        for j = 1:nCols
            c = c + 1;
            matrix(i, j) = matrixIn{1}(c);
        end % j
    end % i

    nShuffles = 100000;

    if isRandom
        matrix = round((nRows*nCols)*rand(nRows, nCols) + 1) <= nOnes;
        tag = 'random';
    elseif isLeftShifted
        threshold = 0.1;
        for iRow = 2:nRows
            for iCol = 1:nCols
                if (rand > threshold)
                    matrix(iRow, iCol) = ~(matrix(1, iCol));
                end % if (rand)
            end % iCol
        end % iRow
        tag = 'leftShifted';
    elseif isRightShifted
        threshold = 0.75;
        iCol = 0;
        for iRow = 2:nRows
            matrix(iRow, :) = ~matrix(iRow-1, :);
            iCol = round(nCols*rand + 1);
    %         iCol = iCol + 1;
    %         if (iCol > nCols)
    %             iCol = 1;
    %         end
            matrix(iRow, iCol) = ~matrix(iRow, iCol);
    %         for iCol = 1:nCols
    %             if (rand > threshold)
    %                 matrix(iRow, iCol) = ~matrix(iRow-1, iCol);
    %             end % if (rand)
    %         end % iCol
        end % iRow
        tag = 'rightShifted';
    elseif isLeftRightShifted
        threshold = 0.1;
        iRowStep = 32;
        nRand = 30;
        for iRow = 1:iRowStep:nRows
            if (iRow > 1)
                matrix(iRow, :) = ~matrix(iRow-iRowStep, :);
                for i = 1:nRand
                    iCol = round(nCols*rand + 1);
                    matrix(iRow, iCol) = ~matrix(iRow, iCol);
                end % i
            end % if (iRow > 1)
            for iiRow = [1:iRowStep-1] + iRow
                for iiCol = 1:nCols
                    if (rand > threshold)
                        matrix(iiRow, iiCol) = ~(matrix(iRow, iiCol));
                    else
                        matrix(iiRow, iiCol) = (matrix(iRow, iiCol));
                    end % if (rand)
                end % iCol
            end % iiRow
        end % iRow
        tag = 'left-rightShifted';
    else
        count=0;
        %for iShuffle = 1:nShuffles
        while count <= 100000
            if isFullShuffle
                randRow1 = randi(nRows);
                randRow2 = randRow1;
                while(randRow1 == randRow2)
                   randRow2 = randi(nRows); 
                end
                if(randRow1 < randRow2)
                    bottomRow = randRow2;
                    topRow = randRow1;
                else
                    bottomRow = randRow1;
                    topRow = randRow2;
                end                
                
                randCol1 = randi(nCols);
                randCol2 = randCol1;
                while(randCol1 == randCol2)
                   randCol2 = randi(nCols); 
                end
                if(randCol1 < randCol2)
                    leftColumn = randCol1;
                    rightColumn = randCol2;
                else
                    leftColumn = randCol2;
                    rightColumn = randCol1;
                end
                
                first = filteredRawMatrix.parcels{leftColumn};
                second = filteredRawMatrix.parcels{rightColumn};
                if(first(1:3) == second(1:3))                
                    topLeft = matrix(topRow, leftColumn);
                    topRight = matrix(topRow, rightColumn);
                    bottomLeft = matrix(bottomRow, leftColumn);
                    bottomRight = matrix(bottomRow, rightColumn);
                    if(topLeft < bottomRight)
                        maxBound = topLeft;
                    else
                        maxBound = bottomRight;
                    end
                    if(maxBound == 0)
                        if(topRight ~= 0 && bottomLeft ~= 0)
                            if(topRight < bottomLeft)
                                maxBound = topRight;
                            else
                                maxBound = bottomLeft;
                            end
                            value = randi(maxBound);
                            matrix(topRow, leftColumn) = matrix(topRow, leftColumn)+value;
                            matrix(bottomRow, leftColumn) = matrix(bottomRow, leftColumn)-value;
                            matrix(topRow, rightColumn) = matrix(topRow, rightColumn)-value;
                            matrix(bottomRow, rightColumn) = matrix(bottomRow, rightColumn)+value;               
                            count = count+1;
                        end                          
                    else
                        value = randi(maxBound);
                        matrix(topRow, leftColumn) = matrix(topRow, leftColumn)-value;
                        matrix(bottomRow, leftColumn) = matrix(bottomRow, leftColumn)+value;
                        matrix(topRow, rightColumn) = matrix(topRow, rightColumn)+value;
                        matrix(bottomRow, rightColumn) = matrix(bottomRow, rightColumn)-value;               
                        count = count+1;
                    end
                end                                
            end % if isFullShuffle
        end % iShuffle
        tag = 'fullyShuffled';
        disp(sprintf('Total times swapped: %d', count));
    end % if isRandom

    nowStr = datestr(now, 'yyyymmddHHMMSS');
    %outFile = sprintf('./output/matrix_%s_%s.csv', tag, nowStr);
    %fid = fopen(outFile, 'w');
    %for i = 1:nRows
    %    for j = 1:nCols
    %        fprintf(fid, '%d', matrix(i, j));
    %        if (j < nCols)
    %            fprintf(fid, ',');
    %        else
    %            fprintf(fid, '\n');
    %        end % if (j < nCols)
    %    end % j
    %end % i
    %fclose(fid)

    %outFile = sprintf('../dir_MouseLight_ASSIP/data/matrix_%s_%s.csv', tag, nowStr);
    filePath = './output/';
    fileName = sprintf('%s_matrix_%s_%s.csv', region, tag, nowStr);
    outFile = strcat(filePath, fileName);
    fid = fopen(outFile, 'w');
    for i = 1:nRows
        for j = 1:nCols
            fprintf(fid, '%d,', matrix(i, j));
        end % j
        fprintf(fid, '\n');
    end % i
    fclose(fid)
    
end % shuffle
