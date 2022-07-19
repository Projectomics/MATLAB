function convergence_get_length(clusterMatrix, parcel, regionName)
    clusterNames = {'E6', 'D19', 'C3', 'B27', 'A38'};
    [nRows, nCols] = size(clusterMatrix);
    %lengthMatrix = strings([nRows], nCols);
    lengthMatrix = nan(nRows, nCols);
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
    
    parcelLength = strlength(parcel);
    hemisphere = cell2mat(extractBetween(parcel, 1, 3));
    parcel = cell2mat(extractBetween(parcel, 4, parcelLength));
    splitInput = split(parcel, '+');    
    
    for r = 1:nRows
        tempNeurons = clusterMatrix(r, :);
        for c = 1:length(tempNeurons)
           if(strcmpi(tempNeurons(c), ''))
              break;
           else
               clusterNeurons(c) = tempNeurons(c);
           end
        end
        
        nNeurons = length(clusterNeurons);
        for k = 1:nNeurons  
            distance = 0;
            currentParcel = '';
            nInvasions = 0;
            invasionSum = 0;
            strng = 'Loading brain areas from JSON file ...\n';
            disp(strng);
            
            strng = sprintf('Loading JSON file %d of %d', k, nNeurons);
            disp(strng);

            fileId = strcat(cell2mat(clusterNeurons(k)), '.json');
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
                sameHemisphere = 0;
                x = data.neurons{1,1}.axon{1,a}.x;
                if(x > 5700)
                    currentHemisphere = '(L)';
                elseif(x < 5700)
                    currentHemisphere = '(R)';
                else
                    currentHemisphere = '(C)';
                end
                
                if(currentHemisphere == somaHemisphere)
                    currentHemisphere = '(I)';
                else
                    currentHemisphere = '(C)';
                end
                
                if(strcmp(currentHemisphere, hemisphere)==1)
                   sameHemisphere = 1; 
                end
                
                if isempty(data.neurons{1,1}.axon{1,a}.allenId)
                    currentParcel = 'null allenId';
                else
                    idx = find(structureIds == data.neurons{1,1}.axon{1,a}.allenId);
                    currentParcel = atlas.data.brainAreas{idx}.name;               
                    for y = 1:length(splitInput)
                        tempParcel = cell2mat(splitInput(y));                      
                        %if(sameHemisphere == 1 && (((contains(currentParcel, tempParcel) == 1) && (contains(tempParcel, currentParcel)==0)) || (strcmp(tempParcel, currentParcel)==1)))
                        if(((contains(currentParcel, tempParcel) == 1) && (contains(tempParcel, currentParcel)==0)) || (strcmp(tempParcel, currentParcel)==1))   
                            currentParcel = parcel; 
                        end
                    end
                end
                
                if(a ~= 1)
                    b = a-1;
                   x1 = data.neurons{1,1}.axon{1,b}.x;
                   y1 = data.neurons{1,1}.axon{1,b}.y;
                   z1 = data.neurons{1,1}.axon{1,b}.z;
                   x2 = data.neurons{1,1}.axon{1,a}.x;
                   y2 = data.neurons{1,1}.axon{1,a}.y;
                   z2 = data.neurons{1,1}.axon{1,a}.z;
                   tempDist = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
                   distance = distance+tempDist;                
                end
                isEqual = strcmp(currentParcel, parcel);
                if(isEqual == 1 && sameHemisphere == 1)
                    nInvasions = nInvasions+1;
                    invasionSum = invasionSum+distance;
                end                
            end % a
            avInvasions = invasionSum/nInvasions;
            lengthMatrix(r, k) = avInvasions;
            %neuronID = cell2mat(clusterMatrix(r, k));
            %str = sprintf('%d [%s]', avInvasions, neuronID);
        end        
        clear clusterNeurons
    end
    
    parcel = strcat(hemisphere, parcel);
    
    nowStr = datestr(now, 'yyyymmddHHMMSS');
    fileName = sprintf('./output/%s_convergence_lengths_%s_%s.txt', regionName, parcel, nowStr);
    fid = fopen(fileName, 'w');
    for c = 1:nRows
       fprintf(fid, '%s;', clusterNames{c}); 
    end
    fprintf(fid, '\n');
    lengthMatrix = lengthMatrix.';
    [nRows, nCols] = size(lengthMatrix);
    
    for i = 1:nRows
        for j = 1:nCols
            neuronID = cell2mat(clusterMatrix(j, i));
            isEqual = strcmp(neuronID, '');
            if(isEqual == 1)
                fprintf(fid, '%s;', '');
            elseif(isnan(lengthMatrix(i, j)))
                fprintf(fid, 'NA [%s];', neuronID); 
            else
                fprintf(fid, '%d [%s];', lengthMatrix(i, j), neuronID); 
            end
        end % j
        fprintf(fid, '\n');
    end % i
    fclose(fid)
    
    nCombinations = (nCols * (nCols-1))/2;
    clusterPairs = strings([nCombinations, 2]);
    row = 1; 
    
    statisticsTable.all = zeros(3, nCols);
    statisticsTable.p = zeros(nCombinations, 1);
    statisticsTable.median = zeros(nCombinations, 2);
    statisticsTable.std = zeros(nCombinations, 2);
    statisticsTable.n = zeros(nCombinations, 2);  
    statisticsTable.percentages = nan(nCombinations, 1);
    
    for i = 1:nCols
       tempCluster = lengthMatrix(:, i);
       cluster = tempCluster(~isnan(tempCluster));
       statisticsTable.all(1, i) = median(cluster);
       statisticsTable.all(2, i) = std(cluster);
       statisticsTable.all(3, i) = length(cluster);
    end
    
    for i = 1:nCols
        for k = i+1:nCols
           clusterPairs(row, 1) = clusterNames{i};
           clusterPairs(row, 2) = clusterNames{k};           
           tempCluster1 = lengthMatrix(:, i);
           tempCluster2 = lengthMatrix(:, k);
           cluster1 = tempCluster1(~isnan(tempCluster1));
           cluster2 = tempCluster2(~isnan(tempCluster2));
           cluster1Median = statisticsTable.all(1, i);
           cluster2Median = statisticsTable.all(1, k);
           
           if(cluster1Median > cluster2Median)
                %[h, p] = ttest2(cluster1, cluster2, 'Vartype', 'unequal', 'Tail', 'right');
                [p, h] = ranksum(cluster1, cluster2, 'Tail', 'right');
           elseif(cluster1Median < cluster2Median)
                %[h, p] = ttest2(cluster1, cluster2, 'Vartype', 'unequal', 'Tail', 'left');
                [p, h] = ranksum(cluster1, cluster2, 'Tail', 'left');
           else
                p = 1;
           end              
           
           statisticsTable.p(row, 1) = p;  
           statisticsTable.median(row, 1) = cluster1Median;
           statisticsTable.median(row, 2) = cluster2Median;
           statisticsTable.std(row, 1) = statisticsTable.all(2, i);
           statisticsTable.std(row, 2) = statisticsTable.all(2, k);
           statisticsTable.n(row, 1) = statisticsTable.all(3, i);
           statisticsTable.n(row, 2) = statisticsTable.all(3, k);    
           
           if(p < 0.05)
              diff = abs(cluster1Median - cluster2Median);
              percentageDiff = (diff / cluster2Median) * 100;
              statisticsTable.percentages(row, 1) = percentageDiff;
           end
           
           row = row+1;
        end
    end
    
    nowStr = datestr(now, 'yyyymmddHHMMSS');
    fileName = sprintf('./output/%s_analysis_convergence_%s_%s.txt', regionName, parcel, nowStr);
    fid = fopen(fileName, 'w');
    
    for i = 1:nCombinations
       fprintf(fid, ';');
       fprintf(fid, '%s;', clusterPairs(i, 1));
       fprintf(fid, '%s;', clusterPairs(i, 2));
       fprintf(fid, '\n');
       fprintf(fid, 'Median;');
       fprintf(fid, '%d;', statisticsTable.median(i, 1));
       fprintf(fid, '%d;', statisticsTable.median(i, 2));
       fprintf(fid, '\n');
       fprintf(fid, 'St. Dev;');
       fprintf(fid, '%d;', statisticsTable.std(i, 1));
       fprintf(fid, '%d;', statisticsTable.std(i, 2));
       fprintf(fid, '\n');
       fprintf(fid, 'n;');
       fprintf(fid, '%d;', statisticsTable.n(i, 1));
       fprintf(fid, '%d;', statisticsTable.n(i, 2));
       fprintf(fid, '\n');
       fprintf(fid, 'p;');
       fprintf(fid, '%d;', statisticsTable.p(i, 1));
       fprintf(fid, '\n');
       fprintf(fid, 'Percent Diff;');
       fprintf(fid, '%d;', statisticsTable.percentages(i, 1));
       fprintf(fid, '\n');
       fprintf(fid, '\n');
    end
    fclose(fid);
    
%     nCombinations = (nCols * (nCols-1))/2;
%     clusterPairs = strings([nCombinations, 2]);
%     row = 1;    
%     ttestTable = zeros(nCombinations, 3); 
    
%     for i = 1:nCols
%         for k = i+1:nCols
%            clusterPairs(row, 1) = clusterNames{i};
%            clusterPairs(row, 2) = clusterNames{k};           
%            tempCluster1 = lengthMatrix(:, i);
%            tempCluster2 = lengthMatrix(:, k);
%            cluster1 = tempCluster1(~isnan(tempCluster1));
%            cluster2 = tempCluster2(~isnan(tempCluster2));
%            
%            [h, p2Tails] = ttest2(cluster1, cluster2, 'Vartype', 'unequal');
%            [h, plTail] = ttest2(cluster1, cluster2, 'Vartype', 'unequal', 'Tail', 'left');
%            [h, prTail] = ttest2(cluster1, cluster2, 'Vartype', 'unequal', 'Tail', 'right');
%            
%            ttestTable(row, 1) = p2Tails;
%            ttestTable(row, 2) = plTail;
%            ttestTable(row, 3) = prTail;       
%            row = row+1;
%         end
%     end
%     
%     nowStr = datestr(now, 'yyyymmddHHMMSS');
%     fileName = sprintf('./output/%s_analysis_convergence_%s_%s.txt', regionName, parcel, nowStr);
%     fid = fopen(fileName, 'w');
%     fprintf(fid, 'Cluster 1;'); 
%     fprintf(fid, 'Cluster 2;');
%     fprintf(fid, 'p (Two-tailed);');
%     fprintf(fid, 'p (Left-tailed);');
%     fprintf(fid, 'p (Right-tailed);');
%     fprintf(fid, '\n');
%     
%     for i = 1:nCombinations
%        fprintf(fid, '%s;', clusterPairs(i, 1));
%        fprintf(fid, '%s;', clusterPairs(i, 2));
%        fprintf(fid, '%d;', ttestTable(i, 1));
%        fprintf(fid, '%d;', ttestTable(i, 2));
%        fprintf(fid, '%d;', ttestTable(i, 3));
%        fprintf(fid, '\n');
%     end
%     fclose(fid);    
    
end