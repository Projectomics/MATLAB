function nnls_all()
% acts as a menu selector for nnls normalizing techniques

    addpath('./lib/');

    str = select_normalization();

    if (str == "matrix_normalized")
        matrix = matrix_normalized();
    elseif (str == "column_normalized")
        matrix = column_normalized();
    elseif (str == "row_normalized")
        matrix = row_normalized();
    elseif (str == "tract_normalized")
        matrix = tract_normalized();
    elseif (str == "binormalized")
        matrix = binormalized();
    else
        disp("Invalid input");
    end
    
    table = cell2table(matrix);
    outFileName = strcat('./output/NNLS_', str, '.csv');
    writetable(table, outFileName, 'WriteVariableNames', 0);

end % nnls_all()