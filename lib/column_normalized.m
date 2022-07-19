function columnNormalized = column_normalized()

   addpath('./lib/');
   
   initialMatrix = matrix_normalized();
   [rows, cols] = size(initialMatrix);
   initialMatrixNums = initialMatrix(2:rows, 2:cols);
   sum_cols = sum(cell2mat(initialMatrixNums));
   columnNormalized(1, 1:cols) = initialMatrix(1, 1:cols);
   columnNormalized(1:rows, 1) = initialMatrix(1:rows, 1);
   for r = 2:rows
       for c = 2:cols
           numerator = initialMatrix{r, c};
           denominator = sum_cols(1, c-1);
           columnNormalized{r, c} = numerator/denominator;
       end
   end
   
end % column_normalized()