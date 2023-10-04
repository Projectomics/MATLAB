function p = apply_Levene_test(neuronArray, originalMatrix, nShuffles, isUseOriginalAlgorithm)
% Function to call Levene's statistical test on the neurons of the cluster
% and return the p-value

    nRows = length(neuronArray);

    % Check if the cluster has 2 or fewer neurons
    if (nRows <= 2)
        p = 1; % p-value is set to 1 since not enough data for test
    else        
        % Create a matrix containing only neurons from the cluster
        nCols = size(originalMatrix, 2);
        clusterNeuronsMatrix = zeros(nRows, nCols);
        
        % Populate the clusterNeuronsMatrix with relevant neuron data
        for row = 1:nRows
            for col = 1:nCols
                clusterNeuronsMatrix(row, col) = originalMatrix(neuronArray(row), col); 
            end        
        end
                 
        % Generate a shuffled version of the matrix
        shuffledMatrix = shuffle_matrix(clusterNeuronsMatrix, nShuffles, isUseOriginalAlgorithm);
        
        %% Data Analysis
        
        % Calculate and save the angles between neuron vectors for the original and shuffled data
        originalData = compute_angle_between_vectors(clusterNeuronsMatrix);
        shuffledData = compute_angle_between_vectors(shuffledMatrix);

        originalAngles = originalData(:, 3);
        randAngles = shuffledData(:, 3);
        
        fprintf('\n');
        
        if (var(randAngles) > var(originalAngles))
            % If the variance of the random angles > the variance of the
            % original angles, then the p-value is not significant
            p = 1;
        else
            % Conduct Levene's statistical comparison of variances when the
            % variance of the randomized angle data is less than that of the
            % original angle data
            combinedMatrix = [originalAngles(:), randAngles(:)];
            p = vartestn(combinedMatrix, 'TestType', 'LeveneAbsolute', 'Display', 'off');       
        end
        
    end % if nRows
    
end % apply_Levene_test()