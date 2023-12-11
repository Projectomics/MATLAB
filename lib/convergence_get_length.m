% Function to analyze convergence lengths onto clusters from specified parcels
function [distancesToAllPointsInParcelArray, nowDateStr] = convergence_get_length(clusterMatrix, ...
    convergingParcel, regionStr, clusterNames)

    % Add required paths for library functions
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    % Get the number of clusters and neurons
    [nClusters, nNeuronsAll] = size(clusterMatrix);

    % Initialize distance matrix with NaN values
    lengthMatrix = nan(nClusters, nNeuronsAll);

    % Load brain areas from JSON file
    fprintf('\nLoading brain areas from JSON file ...\n\n');
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    % Extract structure IDs from brain areas
    for brainAreaNo = 1:nBrainAreas
        structureIds(brainAreaNo) = atlas.data.brainAreas{brainAreaNo}.structureId;
    end
    
    % Process converging parcel information
    parcelLength = strlength(convergingParcel);
    hemisphere = cell2mat(extractBetween(convergingParcel, 1, 3));
    convergingParcel = cell2mat(extractBetween(convergingParcel, 4, parcelLength));
    splitInput = split(convergingParcel, '+');    
    
    fprintf('Analyzing convergence to %s\n', strcat(hemisphere, convergingParcel));

    % Iterate over each cluster
    for clusterNo = 1:nClusters

        % Initialize distances array for the current cluster
        distancesToAllPointsInParcelArray{clusterNo} = {0};

        % Extract neurons from the current cluster
        tempNeurons = clusterMatrix(clusterNo, :);
        nNeurons = 0;
        for n = 1:length(tempNeurons)
            if ~sum(cell2mat(cellfun(@ismissing, tempNeurons(n), 'UniformOutput', false)))
                nNeurons = nNeurons + 1;
            end
        end
        clusterNeurons = tempNeurons(1:nNeurons);

        % Initialize total distances for the current cluster
        distancesToAllPointsInParcel = 0;

        % Iterate over each neuron in the cluster
        for neuronNo = 1:nNeurons  
            nInvasionsIn = 0;
            invasionSumIn = 0;
            
            fprintf('Loading cluster %s JSON file %d of %d\n', clusterNames{clusterNo}, neuronNo, nNeurons);

            % Load JSON file for the current neuron
            fileId = strcat(cell2mat(clusterNeurons(neuronNo)), '.json');
            neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);
            data = loadjson(neuronJsonFileName);
            
            % Determine the hemisphere of the soma
            x = data.neurons{1,1}.soma.x;
            if(x > 5700)
                somaHemisphere = '(L)'; % hemisphere is left
            elseif(x < 5700)
                somaHemisphere = '(R)'; % hemisphere is right
            else
                somaHemisphere = '(C)'; % hemisphere is the center line
            end
            
            % Extract parent information for axons
            nAxons = length(data.neurons{1,1}.axon);
            for a = 1:nAxons
               parentArray(a) = data.neurons{1,1}.axon{1,a}.parentNumber; 
            end
            
            % Call the traverse function to analyze convergence
            [nInvasionsOut, invasionSumOut, distancesToAllPointsInParcel] = traverse(hemisphere, ...
                somaHemisphere, convergingParcel, data, ...
                atlas, structureIds, 1, nInvasionsIn, invasionSumIn, splitInput, -1, 0, parentArray, ...
                distancesToAllPointsInParcel);
            
            % Update the distances array for the current cluster
            if (neuronNo == 1)
                distancesToAllPointsInParcelArray{clusterNo} = distancesToAllPointsInParcel;
            else
                distancesToAllPointsInParcelArray{clusterNo} = [distancesToAllPointsInParcelArray{clusterNo}(1:end) distancesToAllPointsInParcel];
            end

            % Calculate average invasions
            avInvasions = invasionSumOut/nInvasionsOut;

            % Update the length matrix
            lengthMatrix(clusterNo, neuronNo) = avInvasions;
            clear parentArray;

        end % neuronNo

        clear clusterNeurons
    
    end % clusterNo
    
    % Concatenate hemisphere information with converging parcel
    convergingParcel = strcat(hemisphere, convergingParcel);
    
    % Get the current date and time in a string format
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

    % Create a filename for the convergence lengths output
    convergenceLengthsFileName = sprintf('./output/%s__convergence_lengths__%s_%s.xlsx', regionStr, convergingParcel, nowDateStr);

    % Initialize convergence lengths cell matrix
    for clusterNo = 1:nClusters
        convergenceLengthsCellMatrix{1}(1, clusterNo) = clusterNames(clusterNo);
    end

    % Transpose the length matrix
    lengthMatrix = lengthMatrix.';
    
    % Iterate over each neuron and cluster to populate the cell matrix
    for neuronNo = 1:nNeuronsAll
        for clusterNo = 1:nClusters
            isMissingNeuronId = 0;
            if ismissing(clusterMatrix{clusterNo, neuronNo})
                isMissingNeuronId = 1;
            end

            % Check if the neuron ID is missing
            if isMissingNeuronId
                convergenceLengthsCellMatrix{1}(neuronNo+1, clusterNo) = {''};
            % Check if the length is NaN
            elseif (isnan(lengthMatrix(neuronNo, clusterNo)))
                convergenceLengthsCellMatrix{1}(neuronNo+1, clusterNo) = {'NaN'};
            else
                convergenceLengthsCellMatrix{1}(neuronNo+1, clusterNo) = num2cell(lengthMatrix(neuronNo, clusterNo));
            end
        end % j
    end % i

    % Write the cell matrix to the convergence lengths file
    writecell(convergenceLengthsCellMatrix{1}, convergenceLengthsFileName);

end % convergence_get_length()