function binMorphologyMatrix = binarize_morphology_matrix(morphologyMatrix)

   % Creating a matrix that will hold the binarized axon and dendrite counts
   nNeuronsMax = morphologyMatrix.nRows;
   nParcelsMax = morphologyMatrix.nCols;
   binMorphologyMatrix.axonCounts = zeros(nNeuronsMax,nParcelsMax);
   binMorphologyMatrix.dendriteCounts = zeros(nNeuronsMax, nParcelsMax);
   binMorphologyMatrix.nRows = nNeuronsMax;
   binMorphologyMatrix.nCols = nParcelsMax;
   
   % Obtains and parses axon and dendrite threshold values
   thresholdArray = gui_threshold();   
   axonThreshold = str2num(thresholdArray{1});
   dendriteThreshold = str2num(thresholdArray{2});
   %axonThreshold = 30;
   %dendriteThreshold = 30;
   
   % Updates the matrix to hold the binary values of the axon counts
   for row = 1:morphologyMatrix.nRows
      for col = 1:morphologyMatrix.nCols
         if morphologyMatrix.axonCounts(row, col) >= axonThreshold
            binMorphologyMatrix.axonCounts(row, col) = 1;
         end 
      end % col
   end % row
   
   % Updates the matrix to hold the binary values of the dendrite count
   for row = 1:morphologyMatrix.nRows
      for col = 1:morphologyMatrix.nCols
         if morphologyMatrix.dendriteCounts(row, col) >= dendriteThreshold
            binMorphologyMatrix.dendriteCounts(row, col) = 1;
         end 
      end % col
   end % row
   
end % binarize_morphology_matrix





