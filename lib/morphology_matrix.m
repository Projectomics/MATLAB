function morphologyMatrix = morphology_matrix(data, morphologyMatrix)
% Function to extract the parcel locations of all soma, dendritic, and
% axonal points from MouseLight reconstruction data and update the
% morphologyMatrix structure array

    % Determine the number of dendrites and axons
    nDendrites = length(data.neurons{1,1}.dendrite);
    nAxons = length(data.neurons{1,1}.axon);

    % Update the row count in the morphologyMatrix structure array and set the current row
    morphologyMatrix.nRows = morphologyMatrix.nRows + 1;
    row = morphologyMatrix.nRows;
    
    % Store the neuron type and matched soma location for the current row
    morphologyMatrix.neuronTypes{row} = data.neurons{1,1}.idString;
    morphologyMatrix.matchedSomaLocations{row} = data.neurons{1,1}.soma.parcelName;
    
    % Process the soma location
    col = find(strcmp(morphologyMatrix.parcels, data.neurons{1,1}.soma.parcelName));
    if isempty(col)
        % If the parcel is not in the list, add it as a new column
        morphologyMatrix.nCols = morphologyMatrix.nCols + 1;
        col = morphologyMatrix.nCols;
        morphologyMatrix.parcels(col) = {data.neurons{1,1}.soma.parcelName};
    end
    
    % Increment the soma count for the current neuron and parcel
    morphologyMatrix.somaCounts(row, col) = morphologyMatrix.somaCounts(row, col) + 1;
    
    % Process the dendrite locations
    for i = 1:nDendrites
        col = find(strcmp(morphologyMatrix.parcels, data.neurons{1,1}.dendrite{1,i}.parcelName));
        if isempty(col)
            % If the parcel is not in the list, add it as a new column
            morphologyMatrix.nCols = morphologyMatrix.nCols + 1;
            col = morphologyMatrix.nCols;
            morphologyMatrix.parcels(col) = {data.neurons{1,1}.dendrite{1,i}.parcelName};
        end
            
        % Increment the dendrite count for the current neuron and parcel
        morphologyMatrix.dendriteCounts(row, col) = morphologyMatrix.dendriteCounts(row, col) + 1;
    end % i
        
    % Process the axon locations
    for i = 1:nAxons
        col = find(strcmp(morphologyMatrix.parcels, data.neurons{1,1}.axon{1,i}.parcelName));
        if isempty(col)
            % If the parcel is not in the list, add it as a new column
            morphologyMatrix.nCols = morphologyMatrix.nCols + 1;
            col = morphologyMatrix.nCols;
            morphologyMatrix.parcels(col) = {data.neurons{1,1}.axon{1,i}.parcelName};
        end
            
        % Increment the axon count for the current neuron and parcel
        morphologyMatrix.axonCounts(row, col) = morphologyMatrix.axonCounts(row, col) + 1;            
    end % i
    
end % morphology_matrix()
