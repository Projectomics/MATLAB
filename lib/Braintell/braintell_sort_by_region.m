function braintell_sort_by_region(fileName)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');

    
    fileNameFull = sprintf('./output/%s', fileName);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ';'));
    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ';');
    nRows = length(dataStr{1,1}) / nCols
    fclose(fid);
    
    for i = 1:nRows
        rawCell(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end
    
    matrix = rawCell(:, 2);
    matrix = matrix.';
    matrix = matrix(2: length(matrix));
    allRegions.region = {};
    index = 0;
    for r = 1:length(matrix)
        region = matrix(r);
        idx = strfind(region{1}, ',');
		if(length(idx) > 0)
            region = extractBetween(region{1}, 1, idx(1)-1);
        else
            idx = strfind(region{1}, '/');
            if(length(idx)>0)
                region = extractBetween(region{1}, 1, idx(1)-1);
            end
		end % if        
        idx = find(ismember(region, allRegions.region));
        if(isempty(idx))
           index = index+1;
           allRegions.region(index) = region;
        end
    end
    allRegions.neurons = zeros(length(allRegions.region), 5000);
    for i = 1:length(matrix)
        neuronRegion = matrix(i); 
        idx = strfind(neuronRegion{1}, ',');
		if(length(idx) > 0)
            neuronRegion = extractBetween(neuronRegion{1}, 1, idx(1)-1);
        else
            idx = strfind(neuronRegion{1}, '/');
            if(length(idx)>0)
                neuronRegion = extractBetween(neuronRegion{1}, 1, idx(1)-1);
            end
		end % if        
        
        for row = 1:length(allRegions.region)
           reg = allRegions.region(row)
           if(strcmp(reg, neuronRegion)) 
               temp = allRegions.neurons(row, :);
               if(temp(1) == 0)
                  col = 1;
               else
                  col = find(temp, 1, 'last') +1; 
               end
               allRegions.neurons(row, col) = i;
           end
        end
    end
    
    matrix = rawCell(:, 1);
    matrix = matrix.';
    matrix = matrix(2: length(matrix));
    allParcels.parcel = {};
    index = 0;
    for r = 1:length(matrix)
        parcel = matrix(r);
        idx = find(ismember(parcel, allParcels.parcel));
        if(isempty(idx))
           index = index+1;
           allParcels.parcel(index) = parcel;
        end
    end
    allParcels.neurons = zeros(length(allParcels.parcel), 5000);
    for i = 1:length(matrix)
        neuronParcel = matrix(i);
        for row = 1:length(allParcels.parcel)
           reg = allParcels.parcel(row)
           if(strcmp(reg, neuronParcel)) 
               temp = allParcels.neurons(row, :);
               if(temp(1) == 0)
                  col = 1;
               else
                  col = find(temp, 1, 'last') +1; 
               end
               allParcels.neurons(row, col) = i;
           end
        end
    end
    
    fileNameRegion = sprintf('./output/braintell_sorted_regions_%s.csv', ...
        datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fileNameRegion, 'w');
    
    fileNameParcel = sprintf('./output/braintell_sorted_parcels_%s.txt', ...
        datestr(now, 'yyyymmddHHMMSS'));
    fid2 = fopen(fileNameParcel, 'w');
    
    for row = 1:length(allRegions.region)
        fprintf(fid, '%s', cell2mat(allRegions.region(row)));
        for col = 1:5000
            if(~(allRegions.neurons(row, col) == 0))
                fprintf(fid, ',%d', allRegions.neurons(row, col));
            else
                fprintf(fid, ',');
            end
        end % col
        fprintf(fid, '\n');
    end    
    fclose(fid);
    
    for row = 1:length(allParcels.parcel)
        fprintf(fid2, '%s', cell2mat(allParcels.parcel(row)));
        for col = 1:5000
            if(~(allParcels.neurons(row, col) == 0))
                fprintf(fid2, ';%d', allParcels.neurons(row, col));
            else
                fprintf(fid2, ';');
            end
        end % col
        fprintf(fid2, '\n');
    end    
    fclose(fid2);
    

end