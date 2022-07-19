function analysis_divergence(clusterMatrix, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    % Select JSON files to load
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
        
        dispStr = sprintf('Enter list of parcels for analysis for cluster %s (input ! to exit)', num2str(r));
        disp(dispStr);
        
        reply = [];
        parcelIndex = 1;
        while (isempty(reply) | reply ~= '!')
           reply = input('\nYour selection: ', 's');
            if ~strcmp(reply, '!')
                count = 1;
                h1 = strcat('(I) ', reply);
                h2 = strcat('(C) ', reply);
                parcelArray{parcelIndex} = h1;
                parcelIndex = parcelIndex+1;
                parcelArray{parcelIndex} = h2;
                parcelIndex = parcelIndex+1;
            end  
        end
        if(count == 0)
           disp('Exiting'); 
        else
            divergence_get_length_updated(clusterNeurons, parcelArray, region);
        end          
        
        clear clusterNeurons;
        clear parcelArray;
    end    
    
end % analysis_divergence()