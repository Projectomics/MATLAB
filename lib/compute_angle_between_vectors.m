function doublesData = compute_angle_between_vectors(data)
% Function to compute the angles between two vectors and store the results,
% where a vector is a row in a matrix
    
    % Determine the number of rows in the input data
    nRows = size(data, 1);
    
    % Initialize variables for progress tracking
    reverseStr = '';
    nComparisons = nRows*(nRows-1)/2;
    oneTenth = nComparisons / 10;

    c = 0;
    
    % Loop through pairs of vectors to compute angles
    for i = 1:nRows
        
        for ii = i+1:nRows

            vector1 = data(i, :);
            vector2 = data(ii, :);
            
            % Calculate the dot product and magnitudes
            dotProduct = dot(vector1, vector2);
            mag1 = norm(vector1);
            mag2 = norm(vector2);
            
            % Compute the angle between vectors in degrees
            angle = acosd(dotProduct/(mag1 * mag2));
            angle = round(angle);
            
            % Store the angle and indices of vectors in the doublesData array
            c = c + 1;
            doublesData(c, :) = [i ii angle];

            % Display the progress
            if (mod(c,oneTenth) == 0)
                percentDone = 100 * c / nComparisons;
                msg = sprintf('\nComputing angles percent done: %3.0f', percentDone);
                fprintf([reverseStr, msg]);
                reverseStr = repmat(sprintf('\b'), 1, length(msg));
            end

        end % ii
        
    end % i

    fprintf('\n');

end % compute_angle_between_vectors()