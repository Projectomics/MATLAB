function regionNeurons = get_parcel_neurons(fileName, parcelArray)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    
    strng = sprintf('\nLoading sorted neurons from data file ...\n');
    disp(strng);
    
    fileNameFull = sprintf('./data/%s', fileName);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ';'));
    %nCols = 5000;
    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ';');
    nRows = length(dataStr{1,1}) / nCols
    fclose(fid);
    
    for i = 1:nRows
        sortedNeurons(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end
    
    regionNeuronsIndex = 1;
    for k = 1:length(parcelArray)
        brainRegion = parcelArray{k};
        for i = 1:nRows
            if(strcmpi(sortedNeurons(i, 1), brainRegion))
                for j = 2:nCols
                   if(strcmpi(sortedNeurons(i,j), ''))
                       %regionNeurons = [];
                      break; 
                   else
                       regionNeurons(regionNeuronsIndex) = sortedNeurons(i, j);
                       regionNeuronsIndex = regionNeuronsIndex+1;
                   end
                end
            end
        end
    end

end % get_parcel_neurons()