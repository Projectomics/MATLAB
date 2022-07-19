function p = call_all_functions_raw(neuronArray, rawBinMatrix, nShuffles)

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
        
        % Verify that rowSums and colSums are the same for real and random data
        sumRawCol = sum(rawMatrix); % array containing sum of each raw column
        sumRandCol = sum(shuffleMatrix); % array containing sum of each random column
        
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
        
    end % if (length(neuronArray))
    
end % call_all_functions_raw()