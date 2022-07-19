function regionNeurons = get_region_neurons(fileName, brainRegion)
    
    strng = sprintf('\nLoading sorted neurons from data file ...\n');
    disp(strng);
    
    fileNameFull = sprintf('./data/%s', fileName);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ','));

    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ',');
    nRows = length(dataStr{1,1}) / nCols;
    fclose(fid);
    
    for i = 1:nRows
        sortedNeurons(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end    
    
    for i = 1:nRows
        if(strcmpi(sortedNeurons(i, 1), brainRegion))
            for j = 2:nCols
               if(strcmpi(sortedNeurons(i,j), ''))
                  break; 
               else
                   regionNeurons(j-1) = sortedNeurons(i, j);
               end
            end
        end
    end % i

end % get_region_neurons()