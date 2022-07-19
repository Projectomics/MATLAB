function braintell_threshold()
    thresholdArray = gui_threshold();   
    countThreshold = str2num(thresholdArray{1});
    totalDataPoints = 0;
    avDataPoints = 0;
    totalMicrons = 0;
    avMicrons = 0;
    
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');

    % Select JSON files to load
    % neuronJsonFiles = dir('./data/JSON/*.json');
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    nFiles = length(neuronJsonFiles);
    %nFiles = 5;
    
    strng = 'Loading brain areas from JSON file ...\n';
    disp(strng);
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
        
    %emptySomaId = zeros(1, nFiles);
    %somaIndex = 1;
    for i = 1:nFiles
        strng = sprintf('Loading JSON file %d of %d', i, nFiles);
        disp(strng);
        
        % Load JSON file
        neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', neuronJsonFiles(i).name);
        data = loadjson(neuronJsonFileName);        
        nAxons = length(data.neurons{1,1}.axon);
        totalDataPoints = totalDataPoints+nAxons;        
    end % i
    avDataPoints = totalDataPoints / nFiles;
    
    matrix = open_data_file('Braintell_all_raw.csv');
    [nRows, nCols] = size(matrix);
    for r = 1:nRows
       for c = 1:nCols
            totalMicrons = totalMicrons+matrix(r, c);
       end        
    end
    avMicrons = totalMicrons / nRows;
    
    proportion = countThreshold / avDataPoints;
    micronThreshold = proportion * avMicrons;
    disp(micronThreshold);
end