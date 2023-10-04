function morphologyMatrix = load_region_files_hemispheres(regionNeurons, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    % Select JSON files to load
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    nFiles = length(regionNeurons);
    
    strng = 'Loading brain areas from JSON file ...\n';
    disp(strng);
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
    
    fileName = sprintf('./output/neuronIds_%s_%s.csv', region, ...
        datetime('now', 'Format', 'yyyyMMddHHmmSS'));   
    fid = fopen(fileName, 'w');
        
    for i = 1:nFiles
        strng = sprintf('Loading JSON file %d of %d', i, nFiles);
        disp(strng);
        
        fileId = strcat(cell2mat(regionNeurons(i)), '.json');
        % Load JSON file
        neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);        
        data = loadjson(neuronJsonFileName);
        
        % Determine parcel invaded by soma
        if isempty(data.neurons{1,1}.soma.allenId)
            data.neurons{1,1}.soma.parcelName = 'null allenId';
        else
            idx = find(structureIds == data.neurons{1,1}.soma.allenId);
            if(data.neurons{1,1}.soma.x < 5700)
                hemisphere = '(L) '; % hemisphere is left
            elseif(data.neurons{1,1}.soma.x > 5700)
                hemisphere = '(R) '; % hemisphere is right
            else
                hemisphere = '(C) '; % hemisphere is the center line
            end
            data.neurons{1,1}.soma.parcelName = strcat(hemisphere, atlas.data.brainAreas{idx}.name);
            somaParcel = data.neurons{1,1}.soma.parcelName;
        end
        
        % Determine parcels invaded by dendrites
        nDendrites = length(data.neurons{1,1}.dendrite);
        for d = 1:nDendrites
            if isempty(data.neurons{1,1}.dendrite{1,d}.allenId)
                data.neurons{1,1}.dendrite{1,d}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1,1}.dendrite{1,d}.allenId);
                %idx = find(structureIds == data.neurons{1,1}.dendrite{1,d}.allenId);
                if(data.neurons{1,1}.dendrite{1,d}.x < 5700)
                    hemisphere = '(L) '; % hemisphere is left
                elseif(data.neurons{1,1}.dendrite{1,d}.x > 5700)
                    hemisphere = '(R) '; % hemisphere is right
                else
                    hemisphere = '(C) '; % hemisphere is the center line
                end
                data.neurons{1,1}.dendrite{1,d}.parcelName = strcat(hemisphere, atlas.data.brainAreas{idx}.name);
                dendriteParcel = data.neurons{1,1}.dendrite{1,d}.parcelName;
            end
        end % d
        
        % Determine parcels invaded by axons
        nAxons = length(data.neurons{1,1}.axon);
        for a = 1:nAxons
            if isempty(data.neurons{1,1}.axon{1,a}.allenId)
                data.neurons{1,1}.axon{1,a}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1,1}.axon{1,a}.allenId);
                if(data.neurons{1,1}.axon{1,a}.x < 5700)
                    hemisphere = '(L) '; % hemisphere is left
                elseif(data.neurons{1,1}.axon{1,a}.x > 5700)
                    hemisphere = '(R) '; % hemisphere is right
                else
                    hemisphere = '(C) '; % hemisphere is the center line
                end
                data.neurons{1,1}.axon{1,a}.parcelName = strcat(hemisphere, atlas.data.brainAreas{idx}.name);
                axonParcel = data.neurons{1,1}.axon{1,a}.parcelName;
            end
        end % a
        
        morphologyMatrix = morphology_matrix(data, morphologyMatrix);
        fprintf(fid, '%s', cell2mat(regionNeurons(i)));
        fprintf(fid, '\n');
        
    end % i
    fclose(fid);

    save_morphology_matrix(morphologyMatrix, region);

end % load_region_files_hemispheres()