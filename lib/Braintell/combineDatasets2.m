function combineDatasets2()
    mouseLightRaw = open_str_data_file2_semicolon('Agranular Insular Area_ml_processedMatrix_20210412001252.txt');
    brainTellRaw = open_str_data_file2_semicolon('Agranular Insular Area_bt_processedMatrix_20210411234436.txt');    
    mouseLightParcels = mouseLightRaw(1, :);
    brainTellParcels = brainTellRaw(1, :);
    mouseLightRaw(1, :) = [];
    brainTellRaw(1, :) = [];
    [mlRows, mlCols] = size(mouseLightRaw);
    [btRows, btCols] = size(brainTellRaw);
    mouseLight = zeros(mlRows, mlCols);
    brainTell = zeros(btRows, btCols);
    
    for r = 1:mlRows
        for c = 1:mlCols
            mouseLight(r, c) = str2num(cell2mat(mouseLightRaw(r,c)));
        end
    end
    
    for r = 1:btRows
        for c = 1:btCols
            brainTell(r, c) = str2num(cell2mat(brainTellRaw(r,c)));
        end
    end
    
    combinedTemp = zeros((mlRows + btRows), btCols);
    combinedTemp([1:btRows], :) = brainTell;
    
    idx = 1;
    for i = 1:length(brainTellParcels)
        btParcel = brainTellParcels(i);
        for k = 1:length(mouseLightParcels)
           mlParcel = mouseLightParcels(k);
           if(contains(mlParcel, btParcel))
              for row = 1:mlRows
                 newRow = btRows + row;
                 combinedTemp(newRow, i) = combinedTemp(newRow, i) + mouseLight(row, k); 
              end
              usedCols(idx) = k;
              idx = idx+1;
           end
        end
    end
    
    allML = zeros(1, mlCols);
    for i = 1:mlCols
        allML(1, i) = i;
    end
    
    excessCols = setdiff(allML, usedCols);
    combinedRows = mlRows + btRows;
    combinedCols = btCols + length(excessCols);
    combinedFinal = zeros(combinedRows, combinedCols);
    combinedFinal(:, [1:btCols]) = combinedTemp;
    combinedParcels = brainTellParcels;

    for c = 1:length(excessCols)
       column = excessCols(c);
       combinedParcels(btCols + c) = mouseLightParcels(column);
       for r = 1:combinedRows
           if(r > btRows)
               combinedFinal(r, btCols+c) = mouseLight(r-btRows, column);
           end
       end       
    end
    
    fileName = sprintf('./output/%s_combined_%s.txt', 'Agranular insular area', ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    for c = 1:combinedCols
       fprintf(fid, '%s;', cell2mat(combinedParcels(c)));        
    end
    fprintf(fid, '\n');
    for r = 1:combinedRows
       for c = 1:combinedCols
          fprintf(fid, '%d;', combinedFinal(r, c)); 
       end
       fprintf(fid, '\n');
    end
    fclose(fid);   
    
    fileName2 = sprintf('./output/%s_combinedRaw_%s.csv', 'Agranular insular area', ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid2 = fopen(fileName2, 'w');
    for r = 1:combinedRows
       for c = 1:combinedCols
          if(c ==1)
            fprintf(fid2, '%d', combinedFinal(r, c));
          else
            fprintf(fid2, ',%d', combinedFinal(r, c)); 
          end
       end
       fprintf(fid2, '\n');
    end
    fclose(fid2);       
        

end

    
    
    