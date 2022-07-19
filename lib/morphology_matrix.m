function morphologyMatrix = morphology_matrix(data, morphologyMatrix)
    
    nDendrites = length(data.neurons{1,1}.dendrite);
    nAxons = length(data.neurons{1,1}.axon);

    morphologyMatrix.nRows = morphologyMatrix.nRows + 1;
    row = morphologyMatrix.nRows;
    
    morphologyMatrix.neuronTypes{row} = data.neurons{1,1}.idString;
    morphologyMatrix.matchedSomaLocations{row} = data.neurons{1,1}.soma.parcelName;
    
    % Process soma location
    col = find(strcmp(morphologyMatrix.parcels, data.neurons{1,1}.soma.parcelName));
    if isempty(col)
        morphologyMatrix.nCols = morphologyMatrix.nCols + 1;
        col = morphologyMatrix.nCols;
        morphologyMatrix.parcels(col) = {data.neurons{1,1}.soma.parcelName};
    end
    
    morphologyMatrix.somaCounts(row,col) = morphologyMatrix.somaCounts(row,col) + 1;
    
    % Process dendrite locations
    for i = 1:nDendrites
        col = find(strcmp(morphologyMatrix.parcels, data.neurons{1,1}.dendrite{1,i}.parcelName));
        if isempty(col)
            morphologyMatrix.nCols = morphologyMatrix.nCols + 1;
            col = morphologyMatrix.nCols;
            morphologyMatrix.parcels(col) = {data.neurons{1,1}.dendrite{1,i}.parcelName};
        end
            
        morphologyMatrix.dendriteCounts(row,col) = morphologyMatrix.dendriteCounts(row,col) + 1;
    end % i
        
    % Process axon locations
    for i = 1:nAxons
        col = find(strcmp(morphologyMatrix.parcels, data.neurons{1,1}.axon{1,i}.parcelName));
        if isempty(col)
            morphologyMatrix.nCols = morphologyMatrix.nCols + 1;
            col = morphologyMatrix.nCols;
            morphologyMatrix.parcels(col) = {data.neurons{1,1}.axon{1,i}.parcelName};
        end
            
        morphologyMatrix.axonCounts(row,col) = morphologyMatrix.axonCounts(row,col) + 1;            
    end % i
    
end % morphology_matrix()
