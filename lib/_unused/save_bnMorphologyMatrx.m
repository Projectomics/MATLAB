function fileNameAxon = save_bnMorphologyMatrx(binMorphologyMatrix, morphologyMatrix, region)
   %fileNameBinary = sprintf('./output/bnmorphologyMatrix.txt', ...
   %     datestr(now, 'yyyymmddHHMMSS'));
   
   filePath = './output/';
   fileNameAxon = sprintf('%s_bnmorphologyMatrix[A]%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));
   fileNameDendrite = sprintf('%s_bnmorphologyMatrix[D]%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));
   
   fileNameBinaryAxon = strcat(filePath, fileNameAxon);
   fileNameBinaryDendrite = strcat(filePath, fileNameDendrite);
   
   % binary data from matrix
   fid1 = fopen(fileNameBinaryAxon, 'w');
   fid2 = fopen(fileNameBinaryDendrite, 'w');
  
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
   for row = 1:binMorphologyMatrix.nRows
       % Formats and writes data from bnMorphologyMatrx into fid
       %fprintf(fid,'%s [A]', cell2mat(morphologyMatrix.neuronTypes(row)));
 
       % Traverse through the columns in bnMorphologyMatrx
       for col = 1:binMorphologyMatrix.nCols
           % print axon counts into fid
           if col==1
               fprintf(fid1, '%d', binMorphologyMatrix.axonCounts(row,col));
           else
               fprintf(fid1, ',%d', binMorphologyMatrix.axonCounts(row,col));
           end
       end % col
 
       % puts a new line in the fid file
       fprintf(fid1, '\n');
 
       %fprintf(fid, '%s [D]', cell2mat(morphologyMatrix.neuronTypes(row)));
       for col = 1:binMorphologyMatrix.nCols
           if col==1
               fprintf(fid2, '%d', binMorphologyMatrix.dendriteCounts(row,col));
           else
               fprintf(fid2, ',%d', binMorphologyMatrix.dendriteCounts(row,col));
           end
       end % col
       fprintf(fid2, '\n');
   end % row
 
   % close the file
   fclose(fid1);
   fclose(fid2);
 
end % save_bnMorphologyMatrx()
