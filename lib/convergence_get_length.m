function [distancesToAllPointsInParcelArray, nowDateStr] = convergence_get_length(clusterMatrix, ...
    convergingParcel, regionStr, clusterNames)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    [nClusters, nNeuronsAll] = size(clusterMatrix);

    lengthMatrix = nan(nClusters, nNeuronsAll);

    fprintf('\nLoading brain areas from JSON file ...\n\n');
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for brainAreaNo = 1:nBrainAreas
        structureIds(brainAreaNo) = atlas.data.brainAreas{brainAreaNo}.structureId;
    end
    
    parcelLength = strlength(convergingParcel);
    hemisphere = cell2mat(extractBetween(convergingParcel, 1, 3));
    convergingParcel = cell2mat(extractBetween(convergingParcel, 4, parcelLength));
    splitInput = split(convergingParcel, '+');    
    
    fprintf('Analyzing convergence to %s\n', strcat(hemisphere, convergingParcel));

    for clusterNo = 1:nClusters

        distancesToAllPointsInParcelArray{clusterNo} = {0};

        tempNeurons = clusterMatrix(clusterNo, :);
        nNeurons = 0;
        for n = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(n), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        clusterNeurons = tempNeurons(1:nNeurons);

        distancesToAllPointsInParcel = 0;

        for neuronNo = 1:nNeurons  
            nInvasionsIn = 0;
            invasionSumIn = 0;
            
            fprintf('Loading cluster %s JSON file %d of %d\n', clusterNames{clusterNo}, neuronNo, nNeurons);

            fileId = strcat(cell2mat(clusterNeurons(neuronNo)), '.json');
            % Load JSON file
            neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);
            data = loadjson(neuronJsonFileName);
            
            x = data.neurons{1,1}.soma.x;
            if(x > 5700)
                somaHemisphere = '(L)'; % hemisphere is left
            elseif(x < 5700)
                somaHemisphere = '(R)'; % hemisphere is right
            else
                somaHemisphere = '(C)'; % hemisphere is the center line
            end
            
            nAxons = length(data.neurons{1,1}.axon);
            for a = 1:nAxons
               parentArray(a) = data.neurons{1,1}.axon{1,a}.parentNumber; 
            end
            
            % pass in point 1
            
            [nInvasionsOut, invasionSumOut, distancesToAllPointsInParcel] = traverse(hemisphere, ...
                somaHemisphere, convergingParcel, data, ...
                atlas, structureIds, 1, nInvasionsIn, invasionSumIn, splitInput, -1, 0, parentArray, ...
                distancesToAllPointsInParcel);
            
            if (neuronNo == 1)
                distancesToAllPointsInParcelArray{clusterNo} = distancesToAllPointsInParcel;
            else
                distancesToAllPointsInParcelArray{clusterNo} = [distancesToAllPointsInParcelArray{clusterNo}(1:end) distancesToAllPointsInParcel];
            end

            avInvasions = invasionSumOut/nInvasionsOut;
            lengthMatrix(clusterNo, neuronNo) = avInvasions;
            clear parentArray;

        end % neuronNo

        clear clusterNeurons
    
    end % clusterNo
    
    convergingParcel = strcat(hemisphere, convergingParcel);
    
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

    convergenceLengthsFileName = sprintf('./output/%s__convergence_lengths__%s_%s.xlsx', regionStr, convergingParcel, nowDateStr);

    for clusterNo = 1:nClusters
        convergenceLengthsCellMatrix{1}(1, clusterNo) = clusterNames(clusterNo);
    end

    lengthMatrix = lengthMatrix.';
    
    for neuronNo = 1:nNeuronsAll
        for clusterNo = 1:nClusters
            isMissingNeuronId = 0;
            if ismissing(clusterMatrix{clusterNo, neuronNo})
                isMissingNeuronId = 1;
            end

            if isMissingNeuronId
                convergenceLengthsCellMatrix{1}(neuronNo+1, clusterNo) = {''};
            elseif (isnan(lengthMatrix(neuronNo, clusterNo)))
                convergenceLengthsCellMatrix{1}(neuronNo+1, clusterNo) = {'NaN'};
            else
                convergenceLengthsCellMatrix{1}(neuronNo+1, clusterNo) = num2cell(lengthMatrix(neuronNo, clusterNo));
            end
        end % j
    end % i

    writecell(convergenceLengthsCellMatrix{1}, convergenceLengthsFileName);

end % convergence_get_length()