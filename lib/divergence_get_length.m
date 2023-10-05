function divergence_get_length(neuronArray, parcelArray, regionName, clusterName)

    nNeurons = length(neuronArray);
    nParcels = length(parcelArray);
    lengthMatrix = zeros(nNeurons, nParcels);

    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');

    fprintf('\nLoading brain areas from JSON file ...\n');

    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
    
    for i = 1:nParcels
        parcel = parcelArray{i};

        fprintf('\nLoading neurons for parcel: %s\n', parcel);

        parcelLength = strlength(parcel);
        hemisphere = cell2mat(extractBetween(parcel, 1, 3));
        parcel = cell2mat(extractBetween(parcel, 4, parcelLength));
        splitInput = split(parcel, '+');
                
        distancesToAllPointsInParcel = [];

        for k = 1:nNeurons  
            nInvasionsIn = 0;
            invasionSumIn = 0;

            fprintf('Loading JSON file %d of %d\n', k, nNeurons);

            fileId = strcat(cell2mat(neuronArray(k)), '.json');
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
            
            [nInvasionsOut,invasionSumOut,distancesToAllPointsInParcel] = traverse(hemisphere, somaHemisphere, parcel, data, ...
                atlas, structureIds, 1, nInvasionsIn, invasionSumIn, splitInput, -1, 0, parentArray, ...
                distancesToAllPointsInParcel);
            
            avInvasions = invasionSumOut/nInvasionsOut;
            lengthMatrix(k, i) = avInvasions;
            clear parentArray;
        
        end % k (nNeurons)

        fprintf('Mean path distance for parcel %s is %e.\n', parcelArray{i}, mean(distancesToAllPointsInParcel));
        
        distancesToAllPointsInParcelArray{i} = distancesToAllPointsInParcel;
        distancesToAllPointsInParcelNo(i) = length(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelTotal(i) = sum(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelMean(i) = mean(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelMedian(i) = quantile(distancesToAllPointsInParcel, 0.5);
        distancesToAllPointsInParcel1stQuartile(i) = quantile(distancesToAllPointsInParcel, 0.25);
        distancesToAllPointsInParcel3rdQuartile(i) = quantile(distancesToAllPointsInParcel, 0.75);

    end % i (nParcels)
    
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');
    divergenceLengthsPerClusterFileName = sprintf('./output/%s__divergence_lengths__for_cluster%s_%s.xlsx', ...
        regionName, clusterName, nowDateStr);

    divergenceLengthsPerCluster{1}(1, 1) = {'Neurons \ Targeted Parcels'};
    divergenceLengthsPerCluster{1}(1, 2:nParcels+1) = parcelArray;

    divergenceLengthsPerCluster{1}(2, 1) = {'N'};
    for j = 1:nParcels
        if (isnan(distancesToAllPointsInParcelNo(j)))
            divergenceLengthsPerCluster{1}(2, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(2, j+1) = num2cell(distancesToAllPointsInParcelNo(j));
        end
    end % j

    divergenceLengthsPerCluster{1}(3, 1) = {'Total'};
    for j = 1:nParcels
        if (isnan(distancesToAllPointsInParcelMean(j)))
            divergenceLengthsPerCluster{1}(3, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(3, j+1) = num2cell(distancesToAllPointsInParcelTotal(j));
        end
    end % j

    divergenceLengthsPerCluster{1}(4, 1) = {'Mean'};
    for j = 1:nParcels
        if (isnan(distancesToAllPointsInParcelMean(j)))
            divergenceLengthsPerCluster{1}(4, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(4, j+1) = num2cell(distancesToAllPointsInParcelMean(j));
        end
    end % j

    divergenceLengthsPerCluster{1}(5, 1) = {'Median'};
    for j = 1:nParcels
        if(isnan(distancesToAllPointsInParcelMedian(j)))
            divergenceLengthsPerCluster{1}(5, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(5, j+1) = num2cell(distancesToAllPointsInParcelMedian(j));
        end
    end % j

    divergenceLengthsPerCluster{1}(6, 1) = {'1st Quartile'};
    for j = 1:nParcels
        if(isnan(distancesToAllPointsInParcel1stQuartile(j)))
            divergenceLengthsPerCluster{1}(6, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(6, j+1) = num2cell(distancesToAllPointsInParcel1stQuartile(j));
        end
    end % j

    divergenceLengthsPerCluster{1}(7, 1) = {'3rd Quartile'};
    for j = 1:nParcels
        if(isnan(distancesToAllPointsInParcel3rdQuartile(j)))
            divergenceLengthsPerCluster{1}(7, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(7, j+1) = num2cell(distancesToAllPointsInParcel3rdQuartile(j));
        end
    end % j

    writecell(divergenceLengthsPerCluster{1}, divergenceLengthsPerClusterFileName);

    labelStr = sprintf('cluster%s', clusterName);

    analyze_path_distances_using_Wilcoxon_test_and_FDR(distancesToAllPointsInParcelArray, parcelArray, ...
        labelStr, nowDateStr, regionName);
       
end % divergence_get_length()