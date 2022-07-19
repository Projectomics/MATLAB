function matrixNormalized = matrix_normalized()
% first normalization scheme

   addpath('./lib/');
   
   matrixOriginal = non_neg_least_squares();
   matrixNormalized = matrixOriginal;
   [rows, cols] = size(matrixOriginal);
   matrixOriginal_nums = matrixOriginal(2:rows, 2:cols);
   sum_cols = sum(cell2mat(matrixOriginal_nums), 'all');
   
   for r = 2:rows
       for c = 2:cols
           numerator = matrixOriginal{r, c}*6;
           matrixNormalized{r, c} = (numerator/sum_cols);
       end
   end
   
end % matrix_normalized()