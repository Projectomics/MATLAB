function groupings = sort_brain_parcels(morphologyMatrix)
	% Create matrix
    groupings.brainRegions = morphologyMatrix.parcels;
	count = 1;
	isPresent = 0;
    
    groupings.neurons = strings(length(groupings.brainRegions), 5000);
    
	% Traverse through the neurons and the regions; if neuron’s parcelName contains brain region string, add the name to the neuron array
	for neuron = 1:morphologyMatrix.nRows
		for region = 1:length(groupings.brainRegions)
            parcelName = morphologyMatrix.matchedSomaLocations{neuron};
            regionName = groupings.brainRegions{region};
			if(strcmpi(regionName, parcelName))
				for cols = 1:5000
					if(strcmpi(groupings.neurons(region, cols), ''))
						groupings.neurons(region, cols) = morphologyMatrix.neuronTypes(neuron);
                        break;
                    end % if
				end % for
			end % if
		end % for
	end % for
    %disp(groupings.brainRegions);
end % sort_brain_regions					