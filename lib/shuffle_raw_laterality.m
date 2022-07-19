function fileName = shuffle_raw_laterality(inputFile, region, filteredRawMatrix, nShuffles)

    addpath('./lib/');

    outfile = sprintf('./data/%s', inputFile);
    fid = fopen(outfile, 'r');
    matrixIn = textscan(fid, '%d', 'delimiter', ',');
    fclose(fid);

    raw = open_raw_data_file(inputFile);
    [nRows, nCols] = size(raw);

    %converting data from a cell array to a matrix
    c = 0;
    for i = 1:nRows
        for j = 1:nCols
            c = c + 1;
            matrix(i, j) = matrixIn{1}(c);
        end % j
    end % i

    count=0;
    %for iShuffle = 1:nShuffles
    while count <= nShuffles
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

    end % while
    tag = 'fullyShuffled';
    disp(sprintf('Total times swapped: %d', count));

    nowStr = datestr(now, 'yyyymmddHHMMSS');

    filePath = './output/';
    fileName = sprintf('%s_matrix_%s_%s.csv', region, tag, nowStr);
    outFile = strcat(filePath, fileName);
    dataFileName = strcat('./data/', fileName);
    fid = fopen(outFile, 'w');
    for i = 1:nRows
        for j = 1:nCols
            fprintf(fid, '%d,', matrix(i, j));
        end % j
        fprintf(fid, '\n');
    end % i
    fclose(fid)
    
    copyfile(outFile, dataFileName);

end % shuffle
