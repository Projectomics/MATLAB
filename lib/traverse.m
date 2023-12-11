% Recursive function to traverse the neuronal axon and calculate invasion lengths
function [nInvasionsOut, totalDistanceOut, distancesToAllPointsInParcel] = traverse(hemisphere, somaHemisphere, parcel, ...
    data, atlas, structureIds, sample, nInvasionsIn, totalDistanceIn, splitInput, parent, ...
    parentPointDistance, parentArray, distancesToAllPointsInParcel)
    
    % Check if the current axon point invades the specified parcel
    hasInvaded = 0;
    sameHemisphere = 0;
    x = data.neurons{1,1}.axon{1,sample}.x;
    
    % Determine the current hemisphere of the axon point
    if(x > 5700)
        currentHemisphere = '(L)';
    elseif(x < 5700)
        currentHemisphere = '(R)';
    else
        currentHemisphere = '(C)';
    end

    % Adjust hemisphere based on soma hemisphere for invasion determination
    if (currentHemisphere == somaHemisphere)
        currentHemisphere = '(I)';
    else
        currentHemisphere = '(C)';
    end

    % Check if the current hemisphere matches the specified hemisphere
    if (strcmp(currentHemisphere, hemisphere)==1)
       sameHemisphere = 1; 
    end

    % Determine the parcel of the current axon point
    if isempty(data.neurons{1,1}.axon{1,sample}.allenId)
        currentParcel = 'null allenId';
    else
        idx = find(structureIds == data.neurons{1,1}.axon{1, sample}.allenId);
        currentParcel = atlas.data.brainAreas{idx}.name;
        
        % Check and update the current parcel based on splitInput
        for y = 1:length(splitInput)
            tempParcel = cell2mat(splitInput(y));
            if(((contains(currentParcel, tempParcel) == 1) && (contains(tempParcel, currentParcel)==0)) || (strcmp(tempParcel, currentParcel)==1))
               currentParcel = parcel; 
            end
        end
    end
    
    % Calculate distance between the current axon point and its parent
    if (sample == 1)
       parentPointDistance = 0;
    else
       x1 = data.neurons{1,1}.axon{1,parent}.x;
       y1 = data.neurons{1,1}.axon{1,parent}.y;
       z1 = data.neurons{1,1}.axon{1,parent}.z;
       x2 = data.neurons{1,1}.axon{1,sample}.x;
       y2 = data.neurons{1,1}.axon{1,sample}.y;
       z2 = data.neurons{1,1}.axon{1,sample}.z;
       distance = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
       parentPointDistance = parentPointDistance + distance;
    end
    
    % Check if the current point invades the specified parcel and hemisphere
    isEqual = strcmp(currentParcel, parcel);
    if (isEqual == 1 && sameHemisphere == 1)
        nInvasionsOut = nInvasionsIn + 1;
        hasInvaded = 1;
        totalDistanceOut = totalDistanceIn + parentPointDistance;
        
        % Update distancesToAllPointsInParcel array
        nPointsInParcel = length(distancesToAllPointsInParcel);
        if ((nPointsInParcel == 1) && (distancesToAllPointsInParcel == 0))
            distancesToAllPointsInParcel(1) = parentPointDistance;
        else
            distancesToAllPointsInParcel(nPointsInParcel + 1) = parentPointDistance;
        end
    else
        nInvasionsOut = nInvasionsIn;
        totalDistanceOut = totalDistanceIn;
    end
    
    % Find indices of points that have the current point as a parent point
    idx = find(parentArray == sample);

    % If there are points with the current point as a parent, recursively call traverse
    if (length(idx) > 0)
        for a = 1:length(idx)
           newSample = idx(a); 
           [nInvasionsOut, totalDistanceOut, distancesToAllPointsInParcel] = traverse(hemisphere, somaHemisphere, ...
               parcel, data, atlas, structureIds, ...
               newSample, nInvasionsOut, totalDistanceOut, splitInput, sample, parentPointDistance, parentArray, ...
               distancesToAllPointsInParcel); 
        end
    end
    
end % traverse()