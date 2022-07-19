function sumColumns = save_sum_clusters(cellArray, num)
% finds the sum of axonal counts in each region for each cluster

    addpath('./lib/');
    
    [rows, cols] = size(cellArray);
    for r = 2:rows
        for c = 2:cols
            newCellArray{r-1, c-1} = str2num(cellArray{r, c});
        end
    end
    
    matrix = cell2mat(newCellArray);
    sumColumns = sum(matrix); 

end % save_sum_clusters