function shuffleMatrix = shuffle_matrix(rawMatrix, nShuffles)

    % Shuffle binary matrix
    shuffleMatrix = rawMatrix;
    [nRows, nCols] = size(shuffleMatrix);        
    count = 1;

    reverseStr = '';
    oneTenth = nShuffles / 10;
    fprintf('\n');

    while (count <= nShuffles)

        if (mod(count,oneTenth) == 0)
            percentDone = 100 * count / nShuffles;
            msg = sprintf('Shuffling percent done: %3.0f', percentDone);
            fprintf([reverseStr, msg]);
            reverseStr = repmat(sprintf('\b'), 1, length(msg));
        end

        % Pick two random, distinct rows to swap values, and determine
        % which row is the top and bottom row
        randRow1 = randi(nRows);
        randRow2 = randRow1;
        while (randRow1 == randRow2)
           randRow2 = randi(nRows); 
        end
        if (randRow1 < randRow2)
            bottomRow = randRow2;
            topRow = randRow1;
        else
            bottomRow = randRow1;
            topRow = randRow2;
        end                

        % Pick two random, distinct cols to swap values, and determine
        % which col is the left and right col
        randCol1 = randi(nCols);
        randCol2 = randCol1;
        while (randCol1 == randCol2)
           randCol2 = randi(nCols); 
        end
        if (randCol1 < randCol2)
            leftColumn = randCol1;
            rightColumn = randCol2;
        else
            leftColumn = randCol2;
            rightColumn = randCol1;
        end

        % From the chosen rows and columns, there will be 4 cells that
        % are taking part in the swapping process
        % Determine which cell is the topLeft, topRight, bottomLeft,
        % and bottomRight cell
        topLeft = shuffleMatrix(topRow, leftColumn);
        topRight = shuffleMatrix(topRow, rightColumn);
        bottomLeft = shuffleMatrix(bottomRow, leftColumn);
        bottomRight = shuffleMatrix(bottomRow, rightColumn);
        
        % Find the maximal values along the diagonals to be swapped
        minTopLeftBottomRight = min([topLeft bottomRight]);
        minTopRightBottomLeft = min([topRight bottomLeft]);

        % Randomly select a swapping direction
        coin = randi(2) - 1;

        if coin % prioritize the topLeft-bottomRight diagonal
            if minTopLeftBottomRight % if non-zero, perform the swap
                value = randi(minTopLeftBottomRight);
                shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)-value;
                shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)+value;
                shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)+value;
                shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)-value;
                count = count + 1;
            else % try the other diagonal
                if minTopRightBottomLeft % if non-zero, perform the swap
                    value = randi(minTopRightBottomLeft);
                    shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)+value;
                    shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)-value;
                    shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)-value;
                    shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)+value;
                    count = count + 1;
                end                
            end
        else % prioritize the topRight-bottomLeft diagonal
            if minTopRightBottomLeft % if non-zero, perform the swap
                value = randi(minTopRightBottomLeft);
                shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)+value;
                shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)-value;
                shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)-value;
                shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)+value;
                count = count + 1;
            else % try the other diagonal
                if minTopLeftBottomRight % if non-zero, perform the swap
                    value = randi(minTopLeftBottomRight);
                    shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)-value;
                    shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)+value;
                    shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)+value;
                    shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)-value;
                    count = count + 1;
                end
            end
        end % coin

    end % while count

    fprintf('\n');

end % shuffle_matrix()