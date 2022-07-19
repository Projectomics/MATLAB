function p = call_all_functions_raw(neuronArray, rawBinMatrix, nShuffles)
%     addpath('./lib/');
%     addpath('./lib/jsonlab-1.5');
%     addpath('../dir_MouseLight_ASSIP/');
%     addpath('../dir_shuffle_ASSIP/');
%     addpath('../dir_MouseLight_ASSIP/lib');
%     addpath('../dir_shuffle_ASSIP/lib');

    if(length(neuronArray) <= 2) % if cluster consists of 2 neurons or less
        p = 1;
    else        
        % Create matrix for only the neurons in the cluster  
        % Loop through full raw matrix, and add rows that correspond
        % to neurons in this cluster to the new matrix
        [nRows, nCols] = size(rawBinMatrix);
        rawMatrix = zeros(length(neuronArray), nCols);
        for row = 1:length(neuronArray)
            for col = 1:nCols
                rawMatrix(row, col) = rawBinMatrix(neuronArray(row), col); 
            end        
        end
                 
        shuffleMatrix = shuffle_matrix(rawMatrix, nShuffles);
%         % Shuffle binary matrix        
%         shuffleMatrix = rawMatrix;
%         [nRows, nCols] = size(shuffleMatrix);        
%         count=0;
%         while count < nShuffles % conduct 100M shuffles
%             % Pick two random, distinct rows to swap values, and determine
%             % which row is the top and bottom row
%             randRow1 = randi(nRows);
%             randRow2 = randRow1;
%             while(randRow1 == randRow2)
%                randRow2 = randi(nRows); 
%             end
%             if(randRow1 < randRow2)
%                 bottomRow = randRow2;
%                 topRow = randRow1;
%             else
%                 bottomRow = randRow1;
%                 topRow = randRow2;
%             end                
% 
%             % Pick two random, distinct cols to swap values, and determine
%             % which col is the left and right col
%             randCol1 = randi(nCols);
%             randCol2 = randCol1;
%             while(randCol1 == randCol2)
%                randCol2 = randi(nCols); 
%             end
%             if(randCol1 < randCol2)
%                 leftColumn = randCol1;
%                 rightColumn = randCol2;
%             else
%                 leftColumn = randCol2;
%                 rightColumn = randCol1;
%             end
% 
%             % From the chosen rows and columns, there will be 4 cells that
%             % are taking part in the swapping process
%             % Determine which cell is the topLeft, topRight, bottomLeft,
%             % and bottomRight cell
%             topLeft = shuffleMatrix(topRow, leftColumn);
%             topRight = shuffleMatrix(topRow, rightColumn);
%             bottomLeft = shuffleMatrix(bottomRow, leftColumn);
%             bottomRight = shuffleMatrix(bottomRow, rightColumn);
%             
%             % From the cells along the diagonal that will be losing
%             % counts, determine what the max value that can be swapped is 
%             % This has to be the smaller value in the diagonal cells, 
%             % because the same amount will be lost from both cells and we
%             % want to avoid negative numbers in cells            
%             if(topLeft < bottomRight)
%                 maxBound = topLeft;
%             else
%                 maxBound = bottomRight;
%             end
%             
%             % If the max value that can be swapped is 0, see if the cells
%             % along the other diagonal will yield a different max value if
%             % that diagonal became the one that will lose counts
%             % This can happen only if both cells along the other diagonal
%             % are not 0; if this is the case, then change the max value
%             % that can be swapped to the new value
%             if(maxBound == 0)
%                 if(topRight ~= 0 && bottomLeft ~= 0)
%                     if(topRight < bottomLeft)
%                         maxBound = topRight;
%                     else
%                         maxBound = bottomLeft;
%                     end
%                     
%                     % Choose a random value to be swapped between cells <=
%                     % the max value that can be swapped
%                     value = randi(maxBound);
%                     
%                     % Swap that value across 4 cells and increment number
%                     % of shuffles
%                     shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)+value;
%                     shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)-value;
%                     shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)-value;
%                     shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)+value;               
%                     count = count+1;
%                 end                          
%             else
%                 % Choose a random value to be swapped between cells <=
%                 % the max value that can be swapped
%                 value = randi(maxBound);
%                 
%                 % Swap that value across 4 cells and increment number
%                 % of shuffles
%                 shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)-value;
%                 shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)+value;
%                 shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)+value;
%                 shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)-value;               
%                 count = count+1;
%             end
%         end % while count
%        disp(sprintf('Total times swapped: %d', count));
        
        % Verify that rowSums and colSums are the same for real and random data
        sumRawCol = sum(rawMatrix); % array containing sum of each raw column
        sumRandCol = sum(shuffleMatrix); % array containing sum of each random column
%         if(isequal(sumRawCol, sumRandCol)) % check if the two arrays are equal
%             disp('COL SUMS CORRECT');
%         else
%             disp('COL SUMS INCORRECT');
%         end
        
        % Check row sums
        error = 0;
        [nRows, nCols] = size(shuffleMatrix);
        for k = 1:nRows
           tempRawSum = sum(rawMatrix(k, :)); % sum of raw row
           tempColSum = sum(shuffleMatrix(k, :)); % sum of random row
           if(tempRawSum ~= tempColSum) % there is an error if the two values are not equal
               error = 1;
           end
        end
%         if(error == 0)
%             disp('ROW SUMS CORRECT');
%         else
%             disp('ROW SUMS INCORRECT');
%         end
               
        % Data Analysis
        
        % Calculate and save arccosine between neurons for raw and shuffled data
        rawData = raw_angle_double(rawMatrix);
        shuffledData = raw_angle_double(shuffleMatrix);    
        rawDifferences = rawData(:, 3);
        randDifferences = shuffledData(:, 3);
        
        % Conduct Levene's test        
        if (var(randDifferences) > var(rawDifferences))
            % if variance of random angles > variance of raw angles, p-val
            % is not significant
            p = 1;
        else
            combinedMatrix = [rawDifferences(:), randDifferences(:)];
            [p, stats] = vartestn(combinedMatrix,'TestType','LeveneAbsolute','Display','off');       
        end
        
        % save matrix for subcluster
%         if(p > 0.05)
%            writematrix(rawMatrix, './output/PREsubcluster.csv'); 
%         end
        
    end % if (length(neuronArray))
end