function fileName = braintell_binarize(inFile, region)
    
    rawCounts = open_data_file(inFile);
    [nRows, nCols] = size(rawCounts);
    binarizedMatrix.axonCounts = zeros(nRows, nCols); 
    binarizedMatrix.nRows = nRows;
    binarizedMatrix.nCols = nCols;

    thresholdArray = gui_threshold();   
    threshold = str2num(thresholdArray{1});
    
    for row = 1:nRows
      for col = 1:nCols
         if rawCounts(row, col) >= threshold
            binarizedMatrix.axonCounts(row, col) = 1;             
         end 
      end % col
   end % row
   
   filteredBinMatrix = filter_bin_matrix(binarizedMatrix);
   fileName = save_filtered_bin_matrix(filteredBinMatrix, region);
end