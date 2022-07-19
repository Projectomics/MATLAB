function [nInvasionsOut, totalDistanceOut] = traverse(hemisphere, somaHemisphere, parcel, ...
    data, atlas, structureIds, sample, nInvasionsIn, totalDistanceIn, splitInput, parent, ...
    parentPointDistance, parentArray)
    
    %check if point invades
    hasInvaded = 0;
    sameHemisphere = 0;
    x = data.neurons{1,1}.axon{1,sample}.x;
    if(x > 5700)
        currentHemisphere = '(L)';
    elseif(x < 5700)
        currentHemisphere = '(R)';
    else
        currentHemisphere = '(C)';
    end

    if(currentHemisphere == somaHemisphere)
        currentHemisphere = '(I)';
    else
        currentHemisphere = '(C)';
    end

    if(strcmp(currentHemisphere, hemisphere)==1)
       sameHemisphere = 1; 
    end

    if isempty(data.neurons{1,1}.axon{1,sample}.allenId)
        currentParcel = 'null allenId';
    else
        idx = find(structureIds == data.neurons{1,1}.axon{1, sample}.allenId);
        currentParcel = atlas.data.brainAreas{idx}.name;
        for y = 1:length(splitInput)
            tempParcel = cell2mat(splitInput(y));
            if(((contains(currentParcel, tempParcel) == 1) && (contains(tempParcel, currentParcel)==0)) || (strcmp(tempParcel, currentParcel)==1))
               currentParcel = parcel; 
            end
        end
    end
    
    %distance
    %calc distance between sample and parent
    %add to parentPoint
    
    if(sample == 1)
       parentPointDistance = 0;
    else
       x1 = data.neurons{1,1}.axon{1,parent}.x;
       y1 = data.neurons{1,1}.axon{1,parent}.y;
       z1 = data.neurons{1,1}.axon{1,parent}.z;
       x2 = data.neurons{1,1}.axon{1,sample}.x;
       y2 = data.neurons{1,1}.axon{1,sample}.y;
       z2 = data.neurons{1,1}.axon{1,sample}.z;
       distance = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
       parentPointDistance = parentPointDistance+distance;
    end
    
    isEqual = strcmp(currentParcel, parcel);
    if(isEqual == 1 && sameHemisphere == 1)
        nInvasionsOut = nInvasionsIn+1;
        hasInvaded = 1;
        totalDistanceOut = totalDistanceIn + parentPointDistance;
    else
        nInvasionsOut = nInvasionsIn;
        totalDistanceOut = totalDistanceIn;
    end
    
    idx = find(parentArray == sample);    
    %base case
    %if no point has sample as a parent point, return
    %else
    %store the indices of points that have sample as a parent point,
    %for each point, call traverse
    
    if(length(idx) > 0)
%         if(length(idx) > 1)
%            disp('branch site'); 
%         end
        for a = 1:length(idx)
           newSample = idx(a); 
           [nInvasionsOut, totalDistanceOut] = traverse(hemisphere, somaHemisphere, parcel, data, atlas, structureIds, ...
               newSample, nInvasionsOut, totalDistanceOut, splitInput, sample, parentPointDistance, parentArray); 
        end
    end
    
end