function combineDatasets1()
    mlData.matrix = open_raw_data_file('Agranular insular area_raw_morphologyMatrix_20210411203037.csv');
    [rows, cols] = size(mlData.matrix);
    for r = 1:rows
       for c = 1:cols
          x = mlData.matrix(r, c);
          mlData.matrix(r, c) = x * (104.878/10);
       end
    end
    
    mlData.parcels = open_str_data_file2_semicolon('Agranular insular area_filteredParcels_20210411203037.txt');
    fileName = sprintf('./output/%s_ml_processedMatrix_%s.txt', 'Agranular Insular Area', ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    for c = 1:cols
       fprintf(fid, '%s;', cell2mat(mlData.parcels(c)));        
    end
    fprintf(fid, '\n');
    for r = 1:rows
        for c = 1:cols
            fprintf(fid, '%d;', mlData.matrix(r, c));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
    
    
    btCols.matrix = open_str_data_file2('Agranular insular area_braintell_filtered_cols20210411233308.csv');
    [rows, cols] = size(btCols.matrix);
    btCols.nCols = cols;
    for c = 1 : btCols.nCols
        str = btCols.matrix(c);
        strNew = extractAfter(str, '_');
        btCols.matrix(c) = strNew;        
    end

    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        acronymIds{i} = atlas.data.brainAreas{i}.acronym;
    end % i
    
    btCols.parcelMatrix = strings(1, btCols.nCols);
    for c = 1:btCols.nCols
       r = 1;
       regionAcronym = char(btCols.matrix(r, c));
       disp(regionAcronym);
       if(strcmp(regionAcronym, 'unknown') == 1)
            %regionLayerFull = regionAcronym;
            regionFull = regionAcronym;
       else
           idx = find(ismember(acronymIds, regionAcronym));
           if(length(idx) == 0)
                regionFull = regionAcronym; 
           else
                regionFull = atlas.data.brainAreas{idx}.name; 
           end
           %layer = char(btCols.matrix(r, 2));
           %if(strcmp(layer, 'unknown') == 0)
           %    regionLayerAcronym = strcat(regionAcronym, layer);
           %    idx2 = find(ismember(acronymIds, regionLayerAcronym));
           %    if(isempty(idx2))
           %        regionLayerFull = [regionFull ', layer ' layer];
           %    else
           %        regionLayerFull = atlas.data.brainAreas{idx2}.name;
           %    end
           %else
           %    regionLayerFull = regionFull;
           %end
       end
       btCols.parcelMatrix(r, c) = cellstr(regionFull);
    end
    
    btData.matrix = open_data_file('Agranular insular area_braintell_raw20210411233306.csv');
    [rows, cols] = size(btData.matrix);
    btData.nRows = rows;
    btCols.condensedParcels = unique(btCols.parcelMatrix, 'stable');
    btData.condensedMatrix = zeros(btData.nRows, length(btCols.condensedParcels));
    for c = 1:btCols.nCols
       str = btCols.parcelMatrix(c);
       idx = find(btCols.condensedParcels == str);
       btData.condensedMatrix(:, idx) = btData.condensedMatrix (:, idx) + btData.matrix(:, c);
    end

    fileName = sprintf('./output/%s_bt_processedMatrix_%s.txt', 'Agranular Insular Area', ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    for col = 1:length(btCols.condensedParcels)
       fprintf(fid, '%s;', cell2mat(btCols.condensedParcels(col)));        
    end
    fprintf(fid, '\n');
    for row = 1:btData.nRows
        for col = 1:length(btCols.condensedParcels)
            fprintf(fid, '%d;', btData.condensedMatrix(row, col));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
    
    
end
