function normalizedTractsArray = normalize_tracts(originalTractsArray)
% This function normalizes an array of tract values by the sum of all values.
    
    % Get the length of the original tracts array.
    nTracts = length(originalTractsArray);

    % Calculate the sum of all values in the original tracts array.
    sumTracts = sum(cell2mat(originalTractsArray), 'all');

    for i = 1:nTracts
        % Normalize each element in the original tracts array by dividing it by the sum of all values.
        normalizedTractsArray{i} = originalTractsArray{i} / sumTracts;
%         normalizedTractsArray{i} = 1 / nTracts;
    end % i

end % normalize_tracts()