function divergence_get_length(neuronArray, parcelArray, regionName)
    nNeurons = length(neuronArray);
    nParcels = length(parcelArray);
    lengthMatrix = zeros(nNeurons, nParcels);
    neuronJsonFiles = dir('./data/Mouse_Neurons/MouseLight-neurons/*.json');
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        structureIds(i) = atlas.data.brainAreas{i}.structureId;
    end % i
    
    for i = 1:nParcels
        parcel = parcelArray{i};
        parcelLength = strlength(parcel);
        hemisphere = cell2mat(extractBetween(parcel, 1, 3));
        parcel = cell2mat(extractBetween(parcel, 4, parcelLength));
        splitInput = split(parcel, '+');
                
        for k = 1:nNeurons  
            distance = 0;
            currentParcel = '';
            nInvasions = 0;
            invasionSum = 0;
            strng = 'Loading brain areas from JSON file ...\n';
            disp(strng);
            
            strng = sprintf('Loading JSON file %d of %d', k, nNeurons);
            disp(strng);

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
            lengthMatrix(k, i) = avInvasions;
        end
    end
    
    nowStr = datestr(now, 'yyyymmddHHMMSS');
    fileName = sprintf('./output/%s_divergence_lengths_cluster%d_%s.txt', regionName, nNeurons, nowStr);
    fid = fopen(fileName, 'w');
    for c = 1:nParcels
       fprintf(fid, ';%s', parcelArray{c}); 
    end
    fprintf(fid, '\n');
    
    for i = 1:nNeurons
        fprintf(fid, '%s;', cell2mat(neuronArray(i)));
        for j = 1:nParcels
            if(isnan(lengthMatrix(i, j)))
                fprintf(fid, '%s;', 'NA'); 
            else
                fprintf(fid, '%d;', lengthMatrix(i, j));
            end
        end % j
        fprintf(fid, '\n');
    end % i
    fclose(fid);
    
    nCombinations = (nParcels * (nParcels-1))/2;
    regionPairs = strings([nCombinations, 2]);
    row = 1;    
      
    statisticsTable.all = zeros(3, nParcels);
    statisticsTable.p = zeros(nCombinations, 1);
    statisticsTable.median = zeros(nCombinations, 2);
    statisticsTable.std = zeros(nCombinations, 2);
    statisticsTable.n = zeros(nCombinations, 2);
    statisticsTable.percentages = nan(nCombinations, 1);
    
    for i = 1:nParcels
       tempRegion = lengthMatrix(:, i);
       region = tempRegion(~isnan(tempRegion));
       statisticsTable.all(1, i) = median(region);
       statisticsTable.all(2, i) = std(region);
       statisticsTable.all(3, i) = length(region);
    end
    
    for i = 1:nParcels
        for k = i+1:nParcels
           regionPairs(row, 1) = parcelArray{i};
           regionPairs(row, 2) = parcelArray{k};   
           tempRegion1 = lengthMatrix(:, i);
           tempRegion2 = lengthMatrix(:, k);
           region1 = tempRegion1(~isnan(tempRegion1));
           region2 = tempRegion2(~isnan(tempRegion2));
           region1Median = statisticsTable.all(1, i);
           region2Median = statisticsTable.all(1, k);
           
           if(region1Median > region2Median)
                [p, h] = ranksum(region1, region2, 'Tail', 'right');
           elseif(region1Median < region2Median)
                [p, h] = ranksum(region1, region2, 'Tail', 'left');
           else
                p = 1;
           end              
           
           statisticsTable.p(row, 1) = p;  
           statisticsTable.median(row, 1) = region1Median;
           statisticsTable.median(row, 2) = region2Median;
           statisticsTable.std(row, 1) = statisticsTable.all(2, i);
           statisticsTable.std(row, 2) = statisticsTable.all(2, k);
           statisticsTable.n(row, 1) = statisticsTable.all(3, i);
           statisticsTable.n(row, 2) = statisticsTable.all(3, k);  
           
           if(p < 0.05)
              diff = abs(region1Median - region2Median);
              percentageDiff = (diff / region2Median) * 100;
              statisticsTable.percentages(row, 1) = percentageDiff;
           end           
           row = row+1;
           
        end
    end
    
    nowStr = datestr(now, 'yyyymmddHHMMSS');
    fileName = sprintf('./output/%s_analysis_divergence_cluster%d_%s.txt', regionName, nNeurons, nowStr);
    fid = fopen(fileName, 'w');
    
    for i = 1:nCombinations
       fprintf(fid, ';');
       fprintf(fid, '%s;', regionPairs(i, 1));
       fprintf(fid, '%s;', regionPairs(i, 2));
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
    
%     nCombinations = (nParcels * (nParcels-1))/2;
%     regionPairs = strings([nCombinations, 2]);
%     row = 1;    
%     ttestTable = zeros(nCombinations, 3);    
%     
%     for i = 1:nParcels
%         for k = i+1:nParcels
%            regionPairs(row, 1) = parcelArray{i};
%            regionPairs(row, 2) = parcelArray{k};           
%            tempRegion1 = lengthMatrix(:, i);
%            tempRegion2 = lengthMatrix(:, k);
%            region1 = tempRegion1(~isnan(tempRegion1));
%            region2 = tempRegion2(~isnan(tempRegion2));
%            
%            [h, p2Tails] = ttest2(region1, region2, 'Vartype', 'unequal');
%            [h, plTail] = ttest2(region1, region2, 'Vartype', 'unequal', 'Tail', 'left');
%            [h, prTail] = ttest2(region1, region2, 'Vartype', 'unequal', 'Tail', 'right');
%            
%            ttestTable(row, 1) = p2Tails;
%            ttestTable(row, 2) = plTail;
%            ttestTable(row, 3) = prTail;       
%            row = row+1;
%         end
%     end
%     
%     nowStr = datestr(now, 'yyyymmddHHMMSS');
%     fileName = sprintf('./output/%s_analysis_divergence_cluster%d_%s.txt', region, nNeurons, nowStr);
%     fid = fopen(fileName, 'w');
%     fprintf(fid, 'Region 1;'); 
%     fprintf(fid, 'Region 2;');
%     fprintf(fid, 'p (Two-tailed);');
%     fprintf(fid, 'p (Left-tailed);');
%     fprintf(fid, 'p (Right-tailed);');
%     fprintf(fid, '\n');
%     
%     for i = 1:nCombinations
%        fprintf(fid, '%s;', regionPairs(i, 1));
%        fprintf(fid, '%s;', regionPairs(i, 2));
%        fprintf(fid, '%d;', ttestTable(i, 1));
%        fprintf(fid, '%d;', ttestTable(i, 2));
%        fprintf(fid, '%d;', ttestTable(i, 3));
%        fprintf(fid, '\n');
%     end
%     fclose(fid)
        
end