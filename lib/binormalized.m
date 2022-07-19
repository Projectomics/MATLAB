function binormalizedMatrix = binormalized()

   addpath('./lib/');
   
   initialMatrix = tract_normalized();
   [rows, cols] = size(initialMatrix);
   initialMatrixNums = initialMatrix(2:rows, 2:cols);
   sumCols = sum(cell2mat(initialMatrixNums));
   binormalizedMatrix(1, 1:cols) = initialMatrix(1, 1:cols);
   binormalizedMatrix(1:rows, 1) = initialMatrix(1:rows, 1);
   for r = 2:rows
       for c = 2:cols
           numerator = initialMatrix{r, c};
           denominator = sumCols(1, c-1);
           binormalizedMatrix{r, c} = numerator/denominator;
       end
   end
   
end % binormalized()