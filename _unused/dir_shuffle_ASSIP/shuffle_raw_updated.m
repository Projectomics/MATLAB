function fileNameShuffled = shuffle_raw_updated(inputFile, region)
    %clear all;

    addpath('./lib/');
    addpath('./output');
    addpath('../dir_MouseLight_ASSIP/lib/');

    raw = readmatrix(inputFile);
    %raw( :, all( ~any( raw ), 1 ) ) = [];
    [nRows, nCols] = size(raw);
    %raw = round(raw);
    matrix = raw;


    count=0;
    while count < 100000
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
    end % count
    tag = 'fullyShuffled';
    disp(sprintf('Total times swapped: %d', count));

    nowStr = datestr(now, 'yyyymmddHHMMSS');
    filePath = './output/';
    fileNameShuffled = sprintf('%s_matrix_%s_%s.csv', region, tag, nowStr);
    outFile = strcat(filePath, fileNameShuffled);    
    writematrix(matrix, outFile);
    
end % shuffle
