function histogram_soma(clusterMatrix, region)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');

    %clear all;

    % Select JSON files to load
    % neuronJsonFiles = dir('./data/JSON/*.json');
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    
    [nRows, nCols] = size(clusterMatrix);
    xyzArray = cell(nRows,nCols);
    
    index=0;
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
            x = data.neurons{1,1}.soma.x;
            y = data.neurons{1,1}.soma.y;
            z = data.neurons{1,1}.soma.z;      
            xyzArray{r, i} = [x, y, z];            
            
        end % i 
        
        xyzTemp = xyzArray(r, :);
        xyzCluster = xyzTemp(1:nFiles);
        
        for i = 1:nFiles
            for ii = i+1:nFiles
                cell1 = xyzCluster(i);
                cell2 = xyzCluster(ii);
                x1 = cell1{1}(1);
                y1 = cell1{1}(2);
                z1 = cell1{1}(3);
                
                x2 = cell2{1}(1);
                y2 = cell2{1}(2);
                z2 = cell2{1}(3);
                
                a = [x1, y1, z1];
                b = [x2, y2, z2];
                distance = norm(b-a);                
                index = index + 1;
                withinClusterDistances(index) = distance;
            end % ii
        end % i        
        clear clusterNeurons;
    end
    histogram(withinClusterDistances);
    hold on;
    
    c = 0;
    for r1 = 1:nRows-1
        for c1 = 1:nCols
            for r2 = r1+1:nRows
                for c2 = 1:nCols
                    if ~(isempty(xyzArray{r1, c1}) || isempty(xyzArray{r2, c2}))
                       x1 = xyzArray{r1, c1}(1);
                            y1 = xyzArray{r1, c1}(2);
                            z1 = xyzArray{r1, c1}(3);
                            
                            x2 = xyzArray{r2, c2}(1);
                            y2 = xyzArray{r2, c2}(2);
                            z2 = xyzArray{r2, c2}(3);
                          
                            a = [x1, y1, z1];
                            b = [x2, y2, z2];
                            distance = norm(b-a);
                            c=c+1;
                            betweenClusterDifferences(c) = distance;
                    end
                end                
            end
        end
    end
    histogram(betweenClusterDifferences);    
    str = strcat('./output/', region, '_soma_distances_histogram.fig');
    saveas(gcf, str);
end