function shuffleMatrix = shuffle_matrix(shuffleMatrix, nShuffles)

    [nRows, nCols] = size(shuffleMatrix);        
    count=0;

    while count < nShuffles

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

        % From the cells along the diagonal that will be losing
        % counts, determine what the max value that can be swapped is 
        % This has to be the smaller value in the diagonal cells, 
        % because the same amount will be lost from both cells and we
        % want to avoid negative numbers in cells
        if (topLeft < bottomRight)
            maxBound = topLeft;
        else
            maxBound = bottomRight;
        end
        
        % If the max value that can be swapped is 0, see if the cells
        % along the other diagonal will yield a different max value if
        % that diagonal became the one that will lose counts
        % This can happen only if both cells along the other diagonal
        % are not 0; if this is the case, then change the max value
        % that can be swapped to the new value
        if (maxBound == 0)

            if(topRight < bottomLeft)
                maxBound = topRight;
            else
                maxBound = bottomLeft;
            end

    	    if maxBound % not equal to zero

                % Choose a random value to be swapped between cells <=
                % the max value that can be swapped
                value = randi(maxBound);
                
                % Swap that value across 4 cells and increment number
                % of shuffles
                shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)+value;
                shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)-value;
                shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)-value;
                shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)+value;               
                count = count + 1;

            end % if maxBound

        else

            % Choose a random value to be swapped between cells <=
            % the max value that can be swapped
            value = randi(maxBound);
            
            % Swap that value across 4 cells and increment number
            % of shuffles
            shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)-value;
            shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)+value;
            shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)+value;
            shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)-value;   

            count = count+1;
            
        end % if (maxBound == 0)

    end % while count

end % shuffle_matrix()