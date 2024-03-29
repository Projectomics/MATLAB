function morphologyMatrix = load_region_files_laterality(regionNeurons, region)

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
            data.neurons{1,1}.soma.parcelName = atlas.data.brainAreas{idx}.name;
            x = data.neurons{1,1}.soma.x;
            if(data.neurons{1,1}.soma.x > 5700)
                somaHemisphere = '(L) '; % hemisphere is left
            elseif(data.neurons{1,1}.soma.x < 5700)
                somaHemisphere = '(R) '; % hemisphere is right
            else
                somaHemisphere = '(C) '; % hemisphere is the center line
            end
        end
        
        % Determine parcels invaded by dendrites
        nDendrites = length(data.neurons{1,1}.dendrite);
        for d = 1:nDendrites
            if isempty(data.neurons{1,1}.dendrite{1,d}.allenId)
                data.neurons{1,1}.dendrite{1,d}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1,1}.dendrite{1,d}.allenId);
                xd = data.neurons{1,1}.dendrite{1,d}.x;
                if(data.neurons{1,1}.dendrite{1,d}.x > 5700)
                    dendriteHemisphere = '(L) '; % hemisphere is left
                elseif(data.neurons{1,1}.dendrite{1,d}.x < 5700)
                    dendriteHemisphere = '(R) '; % hemisphere is right
                else
                    dendriteHemisphere = '(C) '; % hemisphere is the center line
                end
                if(dendriteHemisphere == somaHemisphere)
                    tag = '(I) ';
                else
                    tag = '(C) ';
                end
                data.neurons{1,1}.dendrite{1,d}.parcelName = strcat(tag, atlas.data.brainAreas{idx}.name);
            end
        end % d
        
        % Determine parcels invaded by axons
        nAxons = length(data.neurons{1,1}.axon);
        for a = 1:nAxons
            if isempty(data.neurons{1,1}.axon{1,a}.allenId)
                data.neurons{1,1}.axon{1,a}.parcelName = 'null allenId';
            else
                idx = find(structureIds == data.neurons{1,1}.axon{1,a}.allenId);
                xa = data.neurons{1,1}.axon{1,a}.x;
                if(data.neurons{1,1}.axon{1,a}.x > 5700)
                    axonHemisphere = '(L) '; % hemisphere is left
                elseif(data.neurons{1,1}.axon{1,a}.x < 5700)
                    axonHemisphere = '(R) '; % hemisphere is right
                else
                    axonHemisphere = '(C) '; % hemisphere is the center line
                end
                if(axonHemisphere == somaHemisphere)
                    tag = '(I) ';
                else
                    tag = '(C) ';
                end
                data.neurons{1,1}.axon{1,a}.parcelName = strcat(tag, atlas.data.brainAreas{idx}.name);
            end
        end % a
        
        morphologyMatrix = morphology_matrix(data, morphologyMatrix);
        fprintf(fid, '%s', cell2mat(regionNeurons(i)));
        fprintf(fid, '\n');
        
    end % i
    fclose(fid);   
    save_morphology_matrix(morphologyMatrix, region);

end % load_region_files_laterality()