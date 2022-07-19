function [h,p] = pca_soma(clusterMatrix, region)

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
    withinTotal = 0;
    betweenTotal = 0;
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
        strng = 'Loading brain areas from JSON file ...\n';
        disp(strng);
        
        idx = 0;        
        for i = 1:nFiles
            strng = sprintf('Loading JSON file %d of %d', i, nFiles);
            disp(strng);

            fileId = strcat(cell2mat(clusterNeurons(i)), '.json');
            % Load JSON file
            neuronJsonFileName = sprintf('./data/Mouse_Neurons/MouseLight-neurons/%s', fileId);        
            data = loadjson(neuronJsonFileName);

            % Determine parcels invaded by axons
            x = data.neurons{1,1}.soma.x;
            if(x > 5700)
                diff = x-5700;
                x = 5700-diff;
            end
            y = data.neurons{1,1}.soma.y;
            z = data.neurons{1,1}.soma.z;      
            xyzArray{r, i} = [x, y, z];    
            idx = idx+1;
            xArray(idx) = x;
            yArray(idx) = y;
            zArray(idx) = z;
        end % i 
        
        inputMatrix = [xArray.', yArray.', zArray.'];
        standardizedData = zscore(inputMatrix);
        [coefs, score] = pca(standardizedData);
        vbls = {'X','Y','Z'};
        [scoreR, scoreC] = size(score);
        if((length(score) >= 1) && scoreC >= 3)
             biplot(coefs(:,1:3),'Scores', score(:,1:3),'VarLabels', vbls);
             pcaStr = sprintf('cluster%d_pca', r);
             str = strcat('./output/', region, pcaStr);
             saveas(gcf, str);
        %    for obs = 1:length(score)
        %        pc1(obs) = score(obs, 1);
        %        pc2(obs) = score(obs, 2);
        %        pc3(obs) = score(obs, 3);
        %    end
        %    scatter3(pc1, pc2, pc3, 10, 'filled');
        %    %scatter(pc1, pc2, 10, 'filled');
        %    xlabel('Component 1');
        %    ylabel('Component 2');
        %    zlabel('Component 3');
        %    hold on;
        %    clear pc1;
        %    clear pc2;
        %    clear pc3;
        
            stdevPC1 = std((score(:, 1)));
            stdevPC2 = std((score(:, 2)));
            stdevPC3 = std((score(:, 3)));

            ellipsoid(0, 0, 0, stdevPC1, stdevPC2, stdevPC3);
            axis equal
            ellipsoidStr = sprintf('cluster%d_ellipsoid', r);
            str2 = strcat('./output/', region, ellipsoidStr);
            saveas(gcf, str2);
        end
        
        clear clusterNeurons;
        clear xArray;
        clear yArray;
        clear zArray;
    end
    %pcaStr = sprintf('_all_clusters_pca');
    %str = strcat('./output/', region, pcaStr);
    %saveas(gcf, str);
end