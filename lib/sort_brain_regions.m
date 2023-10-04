function groupings = sort_brain_regions(morphologyMatrix)
% Function to sort through and extract the brain regions from the parcels
% stored in the morphologyMatrix structure array

    % Initialize the structure for storing the grouped brain regions and neurons
    groupings.brainRegions = {};
    count = 1;
    isPresent = 0;

    % Traverse through the parcels; within each parcel, find the first comma;
    % add the substring to the matrix (no repeats)
    for parcel = 1:morphologyMatrix.nCols

        substr = morphologyMatrix.parcels(parcel);        
        idx = strfind(substr{1}, ',');
        
        % Check for a comma in the parcel name and extract the substring before the comma
        if (length(idx) > 0)
            substr = extractBetween(substr{1}, 1, idx(1)-1);
        else
            idx = strfind(substr{1}, '/');
            if (length(idx)>0)
                substr = extractBetween(substr{1}, 1, idx(1)-1);
            end
        end % if length
        
        % Check if the substring is already present in the brain regions list
        for region = 1:length(groupings.brainRegions)
            if (strcmpi(groupings.brainRegions{region}, substr))
                isPresent = 1;
            end
        end % region
        
        % If not present, add the substring to the brain regions list
        if (isPresent == 0)
            groupings.brainRegions{count} = substr{1};
            count = count + 1;
        else
            isPresent = 0; % Reset for the next loop
        end

    end % parcel
    
    % Initialize a matrix to store the neuron names within the grouped brain regions
    groupings.neurons = strings(length(groupings.brainRegions), 5000);
    
    % Traverse through the neurons and brain regions; if a neuron's parcel
    % name contains the brain region string, then add the neuron name to
    % the region's neuron array
    for neuron = 1:morphologyMatrix.nRows

        for region = 1:length(groupings.brainRegions)

            parcelName = morphologyMatrix.matchedSomaLocations{neuron};
            regionName = groupings.brainRegions{region};
            
            idx = strfind(parcelName, ',');
            substr = '';
            if (length(idx) > 0)
                substr = extractBetween(parcelName, 1, idx(1)-1);
            else
                idx = strfind(parcelName, '/');
                if (length(idx)>0)
                    substr = extractBetween(parcelName, 1, idx(1)-1);
                else
                    substr = parcelName;
                end
            end % if         
            
            % If the region name matches the substring from the parcel name
            if (strcmp(regionName, substr))
                for cols = 1:5000
                    % Find an empty slot in the neuron array and store the neuron name
                    if (strcmpi(groupings.neurons(region, cols), ''))
                        groupings.neurons(region, cols) = morphologyMatrix.neuronTypes(neuron);
                        break;
                    end
                end % cols
            end

        end % region

    end % neuron

end % sort_brain_regions()			