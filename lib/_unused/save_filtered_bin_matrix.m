function fileNameAxon = save_filtered_bin_matrix(filteredBinMatrix, region)
   %fileNameBinary = sprintf('./output/bnmorphologyMatrix.txt', ...
   %     datestr(now, 'yyyymmddHHMMSS'));
   
   filePath = './output/';
   fileNameAxon = sprintf('%s_filtered_bnmorphologyMatrix[A]%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));
   
   fileNameBinaryAxon = strcat(filePath, fileNameAxon);
   
   % binary data from matrix
   fid = fopen(fileNameBinaryAxon, 'w');
  
   % Traverses through all columns in bnMorphologyMatrx
   %for col = 1:binMorphologyMatrix.nCols
       %if (col>1)
           % Formats and writes the data from bnMorphologyMatrx into fid
           % The cell2mat function converts cell array to ordinary array
           % %s means print a string in matlab
           %fprintf(fid, ';%s', cell2mat(morphologyMatrix.parcels(col)));
       %end
   %end % col
 
   % puts a new line in the fid file
   %fprintf(fid,'\n')
 
   % Traverses through all rows in bnMorphologyMatrx
   for row = 1:filteredBinMatrix.nRows
       % Formats and writes data from bnMorphologyMatrx into fid
       %fprintf(fid,'%s [A]', cell2mat(morphologyMatrix.neuronTypes(row)));
 
       % Traverse through the columns in bnMorphologyMatrx
       for col = 1:filteredBinMatrix.nCols
           % print axon counts into fid
           if col==1
               fprintf(fid, '%d', filteredBinMatrix.axonCounts(row,col));
           else
               fprintf(fid, ',%d', filteredBinMatrix.axonCounts(row,col));
           end
       end % col
 
       % puts a new line in the fid file
       fprintf(fid, '\n');
 
   end % row
 
   % close the file
   fclose(fid);
 
end % save_bnMorphologyMatrx()
