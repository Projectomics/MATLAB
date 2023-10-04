function morphologyMatrix = load_MouseLight_JSON_files(nowDateStr)
% Function to load all MouseLight reconstruction JSON files from the data directory

    % Add necessary library paths
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    % Clear all variables to start fresh
    clear all;

    % Define the directory containing JSON files to load
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    nFiles = length(neuronJsonFiles);
    
    fprintf('\nLoading brain areas from JSON file ...\n\n');

    % Load brain area information from JSON
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    % Extract structure IDs for brain areas
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
    
    % Define maximum limits for neurons and parcels
    nNeuronsMax = 2000;
    nParcelsMax = 5000;
    
    % Initialize the morphologyMatrix structure array
    morphologyMatrix.axonCounts = zeros(nNeuronsMax, nParcelsMax);
    morphologyMatrix.dendriteCounts = zeros(nNeuronsMax, nParcelsMax);
    morphologyMatrix.somaCounts = zeros(nNeuronsMax, nParcelsMax);
    morphologyMatrix.neuronTypes = {'neuronType'};
    morphologyMatrix.parcels = {'parcels'};
    morphologyMatrix.nCols = 0;
    morphologyMatrix.nRows = 0;
    morphologyMatrix.matchedSomaLocations = {'parcelName'};
    
    % Loop through each JSON file
    for i = 1:nFiles

        fprintf('Loading JSON file %d of %d\n', i, nFiles);
        
        % Load JSON file
        neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', neuronJsonFiles(i).name);
        data = loadjson(neuronJsonFileName);
        
        % Determine the parcel location of the soma
        if isempty(data.neurons{1, 1}.soma.allenId)
            data.neurons{1, 1}.soma.parcelName = 'null allenId';
        else
            idx = find(structureIds == data.neurons{1, 1}.soma.allenId);
            data.neurons{1, 1}.soma.parcelName = atlas.data.brainAreas{idx}.name;
        end
        
        % Determine the parcels invaded by the dendrites
        nDendrites = length(data.neurons{1, 1}.dendrite);
        for d = 1:nDendrites
            if isempty(data.neurons{1, 1}.dendrite{1, d}.allenId)
                data.neurons{1, 1}.dendrite{1, d}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1, 1}.dendrite{1, d}.allenId);
                data.neurons{1, 1}.dendrite{1, d}.parcelName = atlas.data.brainAreas{idx}.name;
            end
        end % d
        
        % Determine the parcels invaded by the axons
        nAxons = length(data.neurons{1, 1}.axon);
        for a = 1:nAxons
            if isempty(data.neurons{1, 1}.axon{1, a}.allenId)
                data.neurons{1, 1}.axon{1, a}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1, 1}.axon{1, a}.allenId);
                data.neurons{1, 1}.axon{1, a}.parcelName = atlas.data.brainAreas{idx}.name;
            end
        end % a
        
        % Update the morphologyMatrix structure array
        morphologyMatrix = morphology_matrix(data, morphologyMatrix);
        
    end % i
    
    % Save the morphologyMatrix structure array and axon summaries
    save_morphology_matrix(morphologyMatrix, 'ALL', nowDateStr);
    morphologyMatrix = save_axon_summaries(morphologyMatrix, 'ALL', nowDateStr);

end % load_MouseLight_JSON_files