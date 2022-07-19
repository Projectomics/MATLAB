function fileName = braintell_shuffle_both_constraints(inputFile, region)
    %clear all;

    addpath('./lib/');
    addpath('./output');
    addpath('../dir_MouseLight_ASSIP/lib/');

    
    totalMatrix = open_str_data_file('Braintell_fMOST - Copy.csv');
    parcelMatrix = totalMatrix(1,:);
    parcelMatrix(1) = [];
    parcelMatrix(1) = [];
    parcelMatrix(1) = [];
    
    
    outfile = sprintf('./output/%s', inputFile);
    fid = fopen(outfile, 'r');
    matrixIn = textscan(fid, '%d', 'delimiter', ',');
    fclose(fid);

    raw = open_data_file(inputFile);
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
                countLoop = 0;
                randRow1 = randi([1, nRows-1], 1, 1);
                randCol1 = randi([1, nCols-1], 1, 1);
                topLeft = matrix(randRow1, randCol1);
                
                while(countLoop < 100)
                    randCol2 = randi([randCol1+1, nCols], 1, 1);
                    topRight = matrix(randRow1, randCol2);
                    if(randCol2 ~= randCol1 & topRight ~= topLeft)
                        break;
                    end
                    countLoop = countLoop+1;
                end
                countLoop = 0;
                
                while(countLoop < 100)
                    randRow2 = randi([randRow1+1, nRows], 1, 1);
                    bottomLeft = matrix(randRow2, randCol1);
                    if(randRow2 ~= randRow1 & bottomLeft ~= topLeft)
                        break;
                    end
                    countLoop = countLoop+1;
                end
                bottomRight = matrix(randRow2, randCol2);     
                                
                if((topLeft == bottomRight) & (bottomLeft == topRight) & (topLeft ~= bottomLeft) & (topRight ~= bottomRight))

                    first = parcelMatrix(randCol1);
                    second = parcelMatrix(randCol2);
                    if(first{1}(1:5) == second{1}(1:5))
                        sumBefore = sum(matrix(randRow1, :));
                        matrix(randRow1, randCol1) = bottomLeft;
                        newTopLeft = matrix(randRow1, randCol1);
                        matrix(randRow2, randCol1) = topLeft;
                        newBottomLeft = matrix(randRow2, randCol1);
                        matrix(randRow1, randCol2) = bottomRight;
                        newTopRight = matrix(randRow1, randCol2);
                        matrix(randRow2, randCol2) = topRight;
                        newBottomRight = matrix(randRow2, randCol2);
                        sumAfter = sum(matrix(randRow1, :));
                        if(sumBefore ~= sumAfter)
                           disp(randRow1);
                        end
                        count = count+1;
                    end
                end
                tag = 'fullyShuffled';
            end % if isFullShuffle
        end % iShuffle
        disp(sprintf('Total times swapped: %d', count));
    end % if isRandom

    nowStr = datestr(now, 'yyyymmddHHMMSS');
    filePath = './output/';
    fileName = sprintf('%s_matrix_%s_%s.csv', region, tag, nowStr);
    outFile = strcat(filePath, fileName);
    fid = fopen(outFile, 'w');
    for i = 1:nRows
        for j = 1:nCols
            fprintf(fid, '%d', matrix(i, j));
            if (j < nCols)
                fprintf(fid, ',');
            else
                fprintf(fid, '\n');
            end % if (j < nCols)
        end % j
    end % i
    fclose(fid)
end % shuffle