function groupings = sort_brain_regions(morphologyMatrix)
	% Create matrix
    groupings.brainRegions = {}
	count = 1;
	isPresent = 0;

	% Traverse through parcels; within each parcel, find first comma; add the substring to the matrix (so that there are no repeats)
	for parcel = 1:morphologyMatrix.nCols     
        substr = morphologyMatrix.parcels(parcel);        
        idx = strfind(substr{1}, ',');
		if(length(idx) > 0)
            substr = extractBetween(substr{1}, 1, idx(1)-1);
        else
            idx = strfind(substr{1}, '/');
            if(length(idx)>0)
                substr = extractBetween(substr{1}, 1, idx(1)-1);
            end
		end % if
		for region = 1:length(groupings.brainRegions)
            if(strcmpi(groupings.brainRegions{region}, substr))
                isPresent = 1;
            end % if
		end % for
		if(isPresent == 0)
			groupings.brainRegions{count} = substr{1};
			count = count+1;
        else
            isPresent = 0; %reset for next loop
		end % if
	end % for
    
    groupings.neurons = strings(length(groupings.brainRegions), 5000);
    
	% Traverse through the neurons and the regions; if neuron’s parcelName contains brain region string, add the name to the neuron array
	for neuron = 1:morphologyMatrix.nRows
		for region = 1:length(groupings.brainRegions)
            parcelName = morphologyMatrix.matchedSomaLocations{neuron};
            regionName = groupings.brainRegions{region};
            idx = strfind(parcelName, ',');
            substr = '';
            if(length(idx) > 0)
                substr = extractBetween(parcelName, 1, idx(1)-1);
            else
                idx = strfind(parcelName, '/');
                if(length(idx)>0)
                    substr = extractBetween(parcelName, 1, idx(1)-1);
                else
                    substr = parcelName;
                end
            end % if         
            if(strcmp(regionName, substr))
                for cols = 1:5000
                    if(strcmpi(groupings.neurons(region, cols), ''))
                        groupings.neurons(region, cols) = morphologyMatrix.neuronTypes(neuron);
                        break;
                    end % if
                end % for
            end
		end % for
	end % for
    %disp(groupings.brainRegions);
end % sort_brain_regions					