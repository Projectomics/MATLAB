function cluster_scatterplot_soma(clusterMatrix, region)

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

        for i = 1:nFiles
            strng = sprintf('Loading JSON file %d of %d', i, nFiles);
            disp(strng);

            fileId = strcat(cell2mat(clusterNeurons(i)), '.json');
            % Load JSON file
            neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);        
            data = loadjson(neuronJsonFileName);

            % Determine parcels invaded by axons
            x(i) = data.neurons{1,1}.soma.x;
            if(x(i) > 5700)
                diff = x(i)-5700;
                x(i) = 5700-diff;
            end
            y(i) = data.neurons{1,1}.soma.y;
            z(i) = data.neurons{1,1}.soma.z;         
        end % i    
        scatter3(x, y, z, 10, 'filled');
        hold on;
        clear clusterNeurons;
    end
    
    str = strcat('./output/', region, '_soma_cluster_scatterplot.fig');
    saveas(gcf, str);
    
end