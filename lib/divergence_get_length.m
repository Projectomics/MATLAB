% Function to calculate divergence lengths for given neurons and parcels
function divergence_get_length(neuronArray, parcelArray, regionName, clusterName)

    % Get the number of neurons and parcels
    nNeurons = length(neuronArray);
    nParcels = length(parcelArray);
    
    % Initialize a matrix to store length values
    lengthMatrix = zeros(nNeurons, nParcels);

    % Read neuron JSON files from a specified directory
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/');

    % Load brain areas information from a JSON file
    fprintf('\nLoading brain areas from JSON file ...\n');
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    % Extract structure IDs from the loaded brain areas data
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
    
    % Loop through each parcel in the array
    for i = 1:nParcels
        parcel = parcelArray{i};

        % Display progress
        fprintf('\nLoading neurons for parcel: %s\n', parcel);

        % Extract hemisphere and parcel information
        parcelLength = strlength(parcel);
        hemisphere = cell2mat(extractBetween(parcel, 1, 3));
        parcel = cell2mat(extractBetween(parcel, 4, parcelLength));
        splitInput = split(parcel, '+');
                
        distancesToAllPointsInParcel = [];

        % Loop through each neuron in the array
        for k = 1:nNeurons  
            nInvasionsIn = 0;
            invasionSumIn = 0;

            % Display progress
            fprintf('Loading JSON file %d of %d\n', k, nNeurons);

            % Create the filename for the neuron's JSON file
            fileId = strcat(cell2mat(neuronArray(k)), '.json');
            neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId); 
            data = loadjson(neuronJsonFileName);
            
            % Extract soma information and determine hemisphere
            x = data.neurons{1,1}.soma.x;
            if(x > 5700)
                somaHemisphere = '(L)'; % hemisphere is left
            elseif(x < 5700)
                somaHemisphere = '(R)'; % hemisphere is right
            else
                somaHemisphere = '(C)'; % hemisphere is the center line
            end
            
            % Extract information about axons
            nAxons = length(data.neurons{1,1}.axon);
            for a = 1:nAxons
               parentArray(a) = data.neurons{1,1}.axon{1,a}.parentNumber; 
            end
            
            % Call traverse function to calculate divergence lengths
            [nInvasionsOut,invasionSumOut,distancesToAllPointsInParcel] = traverse(hemisphere, somaHemisphere, parcel, data, ...
                atlas, structureIds, 1, nInvasionsIn, invasionSumIn, splitInput, -1, 0, parentArray, ...
                distancesToAllPointsInParcel);
            
            % Calculate average invasions and store in lengthMatrix
            avInvasions = invasionSumOut/nInvasionsOut;
            lengthMatrix(k, i) = avInvasions;
            
            % Clear temporary array for the next iteration
            clear parentArray;
        
        end % Loop through neurons

        % Display mean path distance for the current parcel
        fprintf('Mean path distance for parcel %s is %e.\n', parcelArray{i}, mean(distancesToAllPointsInParcel));
        
        % Store various statistics about distances in arrays
        distancesToAllPointsInParcelArray{i} = distancesToAllPointsInParcel;
        distancesToAllPointsInParcelNo(i) = length(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelTotal(i) = sum(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelMean(i) = mean(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelMedian(i) = quantile(distancesToAllPointsInParcel, 0.5);
        distancesToAllPointsInParcel1stQuartile(i) = quantile(distancesToAllPointsInParcel, 0.25);
        distancesToAllPointsInParcel3rdQuartile(i) = quantile(distancesToAllPointsInParcel, 0.75);
        distancesToAllPointsInParcelMinimum(i) = min(distancesToAllPointsInParcel);
        distancesToAllPointsInParcelMaximum(i) = max(distancesToAllPointsInParcel);

    end % Loop through parcels
    
    % Create a filename for the output Excel file
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');
    divergenceLengthsPerClusterFileName = sprintf('./output/%s__divergence_lengths__for_cluster%s_%s.xlsx', ...
        regionName, clusterName, nowDateStr);

    % Prepare data for writing to Excel file
    divergenceLengthsPerCluster{1}(1, 1) = {'Neurons \ Targeted Parcels'};
    divergenceLengthsPerCluster{1}(1, 2:nParcels+1) = parcelArray;

    divergenceLengthsPerCluster{1}(2, 1) = {'N'};
    for j = 1:nParcels
        if (isnan(distancesToAllPointsInParcelNo(j)))
            divergenceLengthsPerCluster{1}(2, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(2, j+1) = num2cell(distancesToAllPointsInParcelNo(j));
        end
    end % Loop through parcels

    divergenceLengthsPerCluster{1}(3, 1) = {'Total'};
    for j = 1:nParcels
        if (isnan(distancesToAllPointsInParcelMean(j)))
            divergenceLengthsPerCluster{1}(3, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(3, j+1) = num2cell(distancesToAllPointsInParcelTotal(j));
        end
    end % Loop through parcels

    divergenceLengthsPerCluster{1}(4, 1) = {'Mean'};
    for j = 1:nParcels
        if (isnan(distancesToAllPointsInParcelMean(j)))
            divergenceLengthsPerCluster{1}(4, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(4, j+1) = num2cell(distancesToAllPointsInParcelMean(j));
        end
    end % Loop through parcels

    divergenceLengthsPerCluster{1}(5, 1) = {'Median'};
    for j = 1:nParcels
        if(isnan(distancesToAllPointsInParcelMedian(j)))
            divergenceLengthsPerCluster{1}(5, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(5, j+1) = num2cell(distancesToAllPointsInParcelMedian(j));
        end
    end % Loop through parcels

    divergenceLengthsPerCluster{1}(6, 1) = {'1st Quartile'};
    for j = 1:nParcels
        if(isnan(distancesToAllPointsInParcel1stQuartile(j)))
            divergenceLengthsPerCluster{1}(6, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(6, j+1) = num2cell(distancesToAllPointsInParcel1stQuartile(j));
        end
    end % Loop through parcels

    divergenceLengthsPerCluster{1}(7, 1) = {'3rd Quartile'};
    for j = 1:nParcels
        if(isnan(distancesToAllPointsInParcel3rdQuartile(j)))
            divergenceLengthsPerCluster{1}(7, j+1) = {'NaN'};
        else
            divergenceLengthsPerCluster{1}(7, j+1) = num2cell(distancesToAllPointsInParcel3rdQuartile(j));
        end
    end % Loop through parcels

    % Open and write to Excel file
    writecell(divergenceLengthsPerCluster{1}, divergenceLengthsPerClusterFileName);

    % Prepare for boxplot creation
    maxBoxPlot = 0;
    nPointsInParcelArray = length(distancesToAllPointsInParcelArray);
    for i = 1:nPointsInParcelArray
        maxPointsInParcelArray(i) = length(distancesToAllPointsInParcelArray{i});
        if (maxPointsInParcelArray(i) > maxBoxPlot)
            maxBoxPlot = maxPointsInParcelArray(i);
        end
    end

    % Initialize matrix for boxplot
    boxPlotMatrix = NaN(maxBoxPlot, nPointsInParcelArray);

    % Populate boxplot matrix
    for i = 1:nPointsInParcelArray
        boxPlotMatrix(1:maxPointsInParcelArray(i), i) = distancesToAllPointsInParcelArray{i};
    end

    % Create and save the boxplot
    boxplot(boxPlotMatrix);
    
    boxplotFilename = sprintf('./output/%s__divergence_box_and_whisker_plot__for_cluster%s_%s.fig', ...
        regionName, clusterName, nowDateStr);
    saveas(gcf, boxplotFilename);
    
    pngPlotFileName = sprintf('./output/%s__divergence_box_and_whisker_plot__for_cluster%s_%s.png', ...
        regionName, clusterName, nowDateStr);
    print(gcf, '-dpng', '-r800', pngPlotFileName);
    
    labelStr = sprintf('cluster%s', clusterName);

    % Call additional analysis function to determine the statistical
    % significance of different path distances
    analyze_path_distances_using_Wilcoxon_test_and_FDR(distancesToAllPointsInParcelArray, parcelArray, ...
        labelStr, nowDateStr, regionName);
       
end % divergence_get_length()