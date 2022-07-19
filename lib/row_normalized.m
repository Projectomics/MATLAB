function rowNormalized = row_normalized()

   addpath('./lib/');
   
   tracts = run_tracts();
   initialMatrix = matrix_normalized();
   [rows, cols] = size(initialMatrix);
   initialMatrixNums = initialMatrix(2:rows, 2:cols);
   sumRows = sum(cell2mat(initialMatrixNums), 2);
   rowNormalized(1, 1:cols) = initialMatrix(1, 1:cols);
   rowNormalized(1:rows, 1) = initialMatrix(1:rows, 1);
   
   for r = 2:rows
       for c = 2:cols
           division = (initialMatrix{r,c}/sumRows(r-1,1));
           rowNormalized{r,c} = division * 6 * tracts{r-1,1};
       end
   end

end % row_normalized()