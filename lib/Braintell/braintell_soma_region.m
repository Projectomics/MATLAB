function fileName = braintell_soma_region()
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    
    %a = {'red', 'blue', 'green'};
    %b = 'purple';
    %idx = find(ismember(a, b));  
    %if(isempty(idx))
    %   disp('empty'); 
    %end  
        
    reply = [];
    while (isempty(reply))
        reply = select_csvFileName();
        if strcmp(reply, '!')
            disp('Exiting');
        else
            fid2 = fopen(reply);
            if(fid2 == -1)
                reply = [];
            else
                fclose(fid2);
                matrix = open_str_data_file(reply);                    
            end
        end                              
    end
    
    atlas = loadjson('./data/brainAreas.json');
    nBrainAreas = length(atlas.data.brainAreas);
    
    for i = 1:nBrainAreas
        acronymIds{i} = atlas.data.brainAreas{i}.acronym;
    end % i
    
    [nRows, nCols] = size(matrix);
    parcelMatrix = strings(nRows, 1);
    parcelMatrix(1, 1) = 'soma_parcel';
    updatedMatrix = matrix;
    for r = 2:nRows
       c = 1;
       regionAcronym = char(matrix(r, c));
       if(strcmp(regionAcronym, 'unknown') == 1)
            regionLayerFull = regionAcronym;
            regionFull = regionAcronym;
       else
           idx = find(ismember(acronymIds, regionAcronym));
           regionFull = atlas.data.brainAreas{idx}.name;           
           layer = char(matrix(r, 2));
           if(strcmp(layer, 'unknown') == 0)
               regionLayerAcronym = strcat(regionAcronym, layer);
               idx2 = find(ismember(acronymIds, regionLayerAcronym));
               if(isempty(idx2))
                   regionLayerFull = [regionFull ', layer ' layer];
               else
                   regionLayerFull = atlas.data.brainAreas{idx2}.name;
               end
           else
               regionLayerFull = regionFull;
           end
       end
       parcelMatrix(r, c) = cellstr(regionLayerFull);
       updatedMatrix(r, c) = cellstr(regionFull);
    end
    
    strng = sprintf('\nUpdating data spreadsheet ...\n');
    disp(strng);
    
    nowStr = datestr(now, 'yyyymmddHHMMSS');
    filePath = './output/';
    fileName = sprintf('updatedBraintell_%s.txt', nowStr);
    outFile = strcat(filePath, fileName); 
    fid = fopen(outFile, 'w');
    for r = 1:nRows
       fprintf(fid, '%s;', parcelMatrix(r, 1));
       for c = 1:nCols
            fprintf(fid, '%s;', cell2mat(updatedMatrix(r, c)));           
       end    
       fprintf(fid, '\n');
    end
    fclose(fid);
end


    
    
    