function fileName = braintell_load_region_matrix(regionNeurons, region)
    matrix = open_str_data_file('Braintell_raw_labels.csv');
    [rows, cols] = size(matrix);
    binMatrix.axonCounts = zeros(length(regionNeurons), cols);
    binMatrix.nRows = length(regionNeurons);
    binMatrix.nCols = cols;
    binMatrix.parcels = matrix(1, :);
    matrix(1, :) = [];
    
    for r = 1:binMatrix.nRows
        for c = 1:binMatrix.nCols
            temp = str2num(cell2mat(regionNeurons(r)));
            binMatrix.axonCounts(r, c) = str2double(matrix(temp, c));
        end        
    end
    
    %rows are off bc for-loop starts w 2
    
    filteredMatrix.axonCounts = zeros(binMatrix.nRows, binMatrix.nCols);
    filteredMatrix.parcels = {'parcels'};
    sumCols = sum(binMatrix.axonCounts);
    filteredCol = 1;
    
    for c = 1:binMatrix.nCols
       if(sumCols(c)==0) 
            continue
       else
           for r = 1:binMatrix.nRows
                filteredMatrix.axonCounts(r, filteredCol) = binMatrix.axonCounts(r, c);
                filteredMatrix.parcels(filteredCol) = binMatrix.parcels(c);
           end
           filteredCol = filteredCol + 1;
       end
    end   
    filteredMatrix.nRows = binMatrix.nRows;
    filteredMatrix.nCols = filteredCol-1;
    
   filePath = './output/';
   fileName = sprintf('%s_braintell_raw%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));   
   fullFileName = strcat(filePath, fileName);
   
   % binary data from matrix
   fid = fopen(fullFileName, 'w');
   
   % Traverses through all rows in bnMorphologyMatrx
   for row = 1:filteredMatrix.nRows
       for col = 1:filteredMatrix.nCols
           % print axon counts into fid
           if col==1
               fprintf(fid, '%d', filteredMatrix.axonCounts(row,col));
           else
               fprintf(fid, ',%d', filteredMatrix.axonCounts(row,col));
           end
       end % col
 
       % puts a new line in the fid file
       fprintf(fid, '\n');
 
   end % row
 
   % close the file
   fclose(fid);
   
   filePath2 = './output/';
   fileName2 = sprintf('%s_braintell_filtered_cols%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));   
   fullFileName2 = strcat(filePath2, fileName2);
   
   % binary data from matrix
   fid2 = fopen(fullFileName2, 'w');
   
   for col = 1:filteredMatrix.nCols
       % print axon counts into fid
       fprintf(fid2, '%s,', cell2mat(filteredMatrix.parcels(col)));
   end % col
    
   fclose(fid2);
end