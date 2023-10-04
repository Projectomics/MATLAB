function morphologyMatrix = load_files()

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    clear all;

    % Select JSON files to load
    % neuronJsonFiles = dir('./data/JSON/*.json');
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    nFiles = length(neuronJsonFiles);
    %nFiles = 518;
    
    fprintf('\nLoading brain areas from JSON file ...\n\n');

    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
    
    nNeuronsMax = 2000;
    nParcelsMax = 5000;
    morphologyMatrix.axonCounts = zeros(nNeuronsMax,nParcelsMax);
    morphologyMatrix.dendriteCounts = zeros(nNeuronsMax,nParcelsMax);
    morphologyMatrix.somaCounts = zeros(nNeuronsMax,nParcelsMax);
    morphologyMatrix.neuronTypes = {'neuronType'};
    morphologyMatrix.parcels = {'parcels'};
    morphologyMatrix.nCols = 0;
    morphologyMatrix.nRows = 0;
    morphologyMatrix.matchedSomaLocations = {'parcelName'};
    
    %emptySomaId = zeros(1, nFiles);
    %somaIndex = 1;
    for i = 1:nFiles
        fprintf('Loading JSON file %d of %d\n', i, nFiles);
        
        % Load JSON file
        neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', neuronJsonFiles(i).name);
        data = loadjson(neuronJsonFileName);
        
        % Determine parcel invaded by soma
        if isempty(data.neurons{1,1}.soma.allenId)
            data.neurons{1,1}.soma.parcelName = 'null allenId';
            %emptySomaId(somaIndex) = i;
            %somaIndex = somaIndex+1;
            %disp(emptySomaId);
        else
            idx = find(structureIds == data.neurons{1,1}.soma.allenId);
            data.neurons{1,1}.soma.parcelName = atlas.data.brainAreas{idx}.name;
        end
        
        % Determine parcels invaded by dendrites
        nDendrites = length(data.neurons{1,1}.dendrite);
        for d = 1:nDendrites
            if isempty(data.neurons{1,1}.dendrite{1,d}.allenId)
                data.neurons{1,1}.dendrite{1,d}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1,1}.dendrite{1,d}.allenId);
                data.neurons{1,1}.dendrite{1,d}.parcelName = atlas.data.brainAreas{idx}.name;
            end
        end % d
        
        % Determine parcels invaded by axons
        nAxons = length(data.neurons{1,1}.axon);
        for a = 1:nAxons
            if isempty(data.neurons{1,1}.axon{1,a}.allenId)
                data.neurons{1,1}.axon{1,a}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1,1}.axon{1,a}.allenId);
                data.neurons{1,1}.axon{1,a}.parcelName = atlas.data.brainAreas{idx}.name;
            end
        end % a
        
        morphologyMatrix = morphology_matrix(data, morphologyMatrix);
        
    end % i
        
    save_morphology_matrix(morphologyMatrix, 'ALL');
    morphologyMatrix = save_axon_summaries(morphologyMatrix, 'ALL');
end 