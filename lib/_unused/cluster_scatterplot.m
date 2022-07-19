function cluster_scatterplot(clusterMatrix, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');

    %clear all;

    % Select JSON files to load
    % neuronJsonFiles = dir('./data/JSON/*.json');
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    [nRows, nCols] = size(clusterMatrix);
    
    for r = 1:nRows
        tempNeurons = clusterMatrix(r, :);
        for c = 1:length(tempNeurons)
           if(strcmpi(tempNeurons(c), ''))
              break;
           else
               clusterNeurons(c) = tempNeurons(c);
           end
        end
        
        nFiles = length(clusterNeurons);
        %nFiles = 5;

        strng = 'Loading brain areas from JSON file ...\n';
        disp(strng);

        index = 1;
        for i = 1:nFiles
            strng = sprintf('Loading JSON file %d of %d', i, nFiles);
            disp(strng);

            fileId = strcat(cell2mat(clusterNeurons(i)), '.json');
            % Load JSON file
            neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);        
            data = loadjson(neuronJsonFileName);

            % Determine parcels invaded by axons
            nAxons = length(data.neurons{1,1}.axon);
            for a = 1:nAxons
                x(index) = data.neurons{1,1}.axon{1,a}.x;
                y(index) = data.neurons{1,1}.axon{1,a}.y;
                z(index) = data.neurons{1,1}.axon{1,a}.z;
                index = index+1;
            end % a            
        end % i    
        scatter3(x, y, z, 5);
        hold on;
        clear clusterNeurons;
    end
    
    str = strcat('./output/', region, '_cluster_scatterplot.fig');
    saveas(gcf, str);
    
end