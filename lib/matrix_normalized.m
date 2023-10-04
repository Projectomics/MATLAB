function matrixNormalizedMatrix = matrix_normalized(originalMatrix)
% This function takes a matrix as input and normalizes each cell value in
% the matrix based on the sum of all values.

   % Get the number of rows and columns in the original matrix.
   [nRows, nCols] = size(originalMatrix);

   % Extract the numerical values from the original matrix, excluding the label row,
   % the label column, and the tract values (last) column.
   matrixOriginalNums = originalMatrix(2:nRows, 2:nCols-1);

   % Calculate the sum of all numerical values in the matrix.
   sumMatrix = sum(cell2mat(matrixOriginalNums), 'all');
   
   % Initialize the output matrix as the original matrix.
   matrixNormalizedMatrix = originalMatrix;

   % Iterate through rows and columns (excluding the label row, the label
   % column, and the tract values column) to perform matrix normalization.
   for r = 2:nRows
       for c = 2:nCols-1
           % Normalize each cell value by dividing it by the sum of all values.
           matrixNormalizedMatrix{r, c} = (originalMatrix{r, c} / sumMatrix);
       end
   end
   
end % matrix_normalized()