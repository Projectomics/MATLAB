function tractNormalized = tract_normalized()

    addpath('./lib/');
   
   initialMatrix = matrix_normalized();
   [rows, cols] = size(initialMatrix);
   initialMatrixNums = initialMatrix(2:rows, 2:cols);
   sumRows = sum(cell2mat(initialMatrixNums), 2);
   tractNormalized(1, 1:cols) = initialMatrix(1, 1:cols);
   tractNormalized(1:rows, 1) = initialMatrix(1:rows, 1);
   
   for r = 2:rows
       for c = 2:cols
           division = (initialMatrix{r,c}/sumRows(r-1,1));
           tractNormalized{r,c} = division * 6 * (1/93);
       end
   end

end % tract_normalized()