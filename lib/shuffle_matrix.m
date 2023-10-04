function shuffledMatrix = shuffle_matrix(originalMatrix, nShuffles, isUseOriginalAlgorithm)
% Function to shuffle the original matrix a user-selected number of times
% using one of two algorithms
    
    % Initialize the shuffled matrix with the original matrix
    shuffledMatrix = originalMatrix;
    [nRows, nCols] = size(shuffledMatrix);        
    count = 1;

    % Display progress information
    msg = sprintf('\nShuffling percent done: %3.0f', 0);
    fprintf(msg);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
    oneTenth = nShuffles / 10;

    while (count <= nShuffles)

        % Update progress information every 10% of completion
        if (mod(count,oneTenth) == 0)
            percentDone = 100 * count / nShuffles;
            msg = sprintf('\nShuffling percent done: %3.0f', percentDone);
            fprintf([reverseStr, msg]);
            reverseStr = repmat(sprintf('\b'), 1, length(msg));
        end

        % Randomly pick two distinct rows for swapping
        randRow1 = randi(nRows);
        randRow2 = randRow1;
        while (randRow1 == randRow2)
            randRow2 = randi(nRows); 
        end
        
        % Determine the order of rows for swapping
        if (randRow1 < randRow2)
            bottomRow = randRow2;
            topRow = randRow1;
        else
            bottomRow = randRow1;
            topRow = randRow2;
        end                

        % Randomly pick two distinct columns for swapping
        randCol1 = randi(nCols);
        randCol2 = randCol1;
        while (randCol1 == randCol2)
            randCol2 = randi(nCols); 
        end
        
        % Determine the order of columns for swapping
        if (randCol1 < randCol2)
            leftColumn = randCol1;
            rightColumn = randCol2;
        else
            leftColumn = randCol2;
            rightColumn = randCol1;
        end

        % Extract values from the selected cells
        topLeft = shuffledMatrix(topRow, leftColumn);
        topRight = shuffledMatrix(topRow, rightColumn);
        bottomLeft = shuffledMatrix(bottomRow, leftColumn);
        bottomRight = shuffledMatrix(bottomRow, rightColumn);
        
        if isUseOriginalAlgorithm

            %% Original algorithm for shuffling
            
            % Calculate the maximum value that can be swapped
            maxBound = min(topLeft, bottomRight);
            
            % Check if the maximum value is 0
            if maxBound == 0
                % Try the other diagonal if both cells are non-zero
                if topRight ~= 0 && bottomLeft ~= 0
                    maxBound = min(topRight, bottomLeft);
                    value = randi(maxBound);
                    shuffledMatrix(topRow, leftColumn) = shuffledMatrix(topRow, leftColumn) + value;
                    shuffledMatrix(bottomRow, leftColumn) = shuffledMatrix(bottomRow, leftColumn) - value;
                    shuffledMatrix(topRow, rightColumn) = shuffledMatrix(topRow, rightColumn) - value;
                    shuffledMatrix(bottomRow, rightColumn) = shuffledMatrix(bottomRow, rightColumn) + value;
                    count = count + 1;
                end                          
            else
                % Swap values between cells
                value = randi(maxBound);
                shuffledMatrix(topRow, leftColumn) = shuffledMatrix(topRow, leftColumn) - value;
                shuffledMatrix(bottomRow, leftColumn) = shuffledMatrix(bottomRow, leftColumn) + value;
                shuffledMatrix(topRow, rightColumn) = shuffledMatrix(topRow, rightColumn) + value;
                shuffledMatrix(bottomRow, rightColumn) = shuffledMatrix(bottomRow, rightColumn) - value;
                count = count + 1;
            end

        else

            %% Modified shuffle algorithm
            
            % Find minimal values along diagonals for swapping
            minTopLeftBottomRight = min([topLeft bottomRight]);
            minTopRightBottomLeft = min([topRight bottomLeft]);

            % Randomly choose a swapping direction between one of the two
            % diagonal directions
            coin = randi(2) - 1;

            if coin % Prioritize the topLeft-bottomRight diagonal
                if minTopLeftBottomRight % Swap values if non-zero
                    value = randi(minTopLeftBottomRight);
                    shuffledMatrix(topRow, leftColumn) = shuffledMatrix(topRow, leftColumn) - value;
                    shuffledMatrix(bottomRow, leftColumn) = shuffledMatrix(bottomRow, leftColumn) + value;
                    shuffledMatrix(topRow, rightColumn) = shuffledMatrix(topRow, rightColumn) + value;
                    shuffledMatrix(bottomRow, rightColumn) = shuffledMatrix(bottomRow, rightColumn) - value;
                    count = count + 1;
                else % Try the other diagonal
                    if minTopRightBottomLeft % Swap values if non-zero
                        value = randi(minTopRightBottomLeft);
                        shuffledMatrix(topRow, leftColumn) = shuffledMatrix(topRow, leftColumn) + value;
                        shuffledMatrix(bottomRow, leftColumn) = shuffledMatrix(bottomRow, leftColumn) - value;
                        shuffledMatrix(topRow, rightColumn) = shuffledMatrix(topRow, rightColumn) - value;
                        shuffledMatrix(bottomRow, rightColumn) = shuffledMatrix(bottomRow, rightColumn) + value;
                        count = count + 1;
                    end                
                end
            else % Prioritize the topRight-bottomLeft diagonal
                if minTopRightBottomLeft % Swap values if non-zero
                    value = randi(minTopRightBottomLeft);
                    shuffledMatrix(topRow, leftColumn) = shuffledMatrix(topRow, leftColumn) + value;
                    shuffledMatrix(bottomRow, leftColumn) = shuffledMatrix(bottomRow, leftColumn) - value;
                    shuffledMatrix(topRow, rightColumn) = shuffledMatrix(topRow, rightColumn) - value;
                    shuffledMatrix(bottomRow, rightColumn) = shuffledMatrix(bottomRow, rightColumn) + value;
                    count = count + 1;
                else % Try the other diagonal
                    if minTopLeftBottomRight % Swap values if non-zero
                        value = randi(minTopLeftBottomRight);
                        shuffledMatrix(topRow, leftColumn) = shuffledMatrix(topRow, leftColumn) - value;
                        shuffledMatrix(bottomRow, leftColumn) = shuffledMatrix(bottomRow, leftColumn) + value;
                        shuffledMatrix(topRow, rightColumn) = shuffledMatrix(topRow, rightColumn) + value;
                        shuffledMatrix(bottomRow, rightColumn) = shuffledMatrix(bottomRow, rightColumn) - value;
                        count = count + 1;
                    end
                end
            end % coin

        end % if isUseOriginalAlgorithm

    end % while count

    fprintf('\n');

end % shuffle_matrix()