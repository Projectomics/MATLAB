function groupings = sort_brain_parcels(morphologyMatrix)
% Function to sort through and extract the brain parcels stored in the
% morphologyMatrix structure array

    % Initialize a variable to the number of neurons in the
    % morphologyMatrix structure array
    nNeurons = morphologyMatrix.nRows;
    
    % Initialize the structure for storing the grouped brain parcels and neurons
    groupings.brainParcels = morphologyMatrix.parcels;
    groupings.neurons = strings(length(groupings.brainParcels), nNeurons);
    
	% Traverse through the neurons and the parcels; if a neuron's parcel
    % name contains the brain parcel string, then add the neuron name to
    % the parcel's neuron array
	for neuron = 1:nNeurons

		for parcel = 1:length(groupings.brainParcels)

            % Retrieve the soma location of the current neuron
            somaLocation = morphologyMatrix.matchedSomaLocations{neuron};

            % Retrieve the name of the current parcel
            parcelName = groupings.brainParcels{parcel};

            % If the soma location of the current neuron is the same as the
            % name of the current parcel, then store the current neuron
            % name in the grouped neuron array
			if (strcmpi(somaLocation, parcelName))
				for cols = 1:nNeurons
					if (strcmpi(groupings.neurons(parcel, cols), ''))
						groupings.neurons(parcel, cols) = morphologyMatrix.neuronTypes(neuron);
                        break;
                    end % if
				end % cols
			end % if

		end % parcel

	end % neuron

end % sort_brain_parcels					