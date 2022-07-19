function raw = open_data_file(fileName)

    strng = sprintf('\nLoading raw counts from data file ...\n');
    disp(strng);
    
    fileNameFull = sprintf('./output/%s', fileName);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ','))+1;
    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ',');
    nRows = length(dataStr{1,1}) / nCols
    fclose(fid);
    
    for i = 1:nRows
        rawCell(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end
    
    for i = 1:nRows
        for j = 1:nCols
            raw(i, j) = str2double(rawCell{i, j});
        end % j
    end % i
    
end % open_data_file()
