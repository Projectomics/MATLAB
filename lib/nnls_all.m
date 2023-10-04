function nnls_all(axonalCountsPerParcelPerClusterCellArray, axonalCountsPerParcelPerClusterFileName)
% acts as a menu selector for nnls normalizing techniques

    addpath('./lib/');

    selectionStr = select_normalization();

    if (selectionStr == "matrix_normalized")
        normalizedAxonalCountsPerParcelPerClusterCellArray = matrix_normalized(axonalCountsPerParcelPerClusterCellArray);
    elseif (selectionStr == "column_normalized")
        normalizedAxonalCountsPerParcelPerClusterCellArray = column_normalized(axonalCountsPerParcelPerClusterCellArray);
    elseif (selectionStr == "row_normalized")
        normalizedAxonalCountsPerParcelPerClusterCellArray = row_normalized(axonalCountsPerParcelPerClusterCellArray);
    elseif (selectionStr == "tract_normalized")
        normalizedAxonalCountsPerParcelPerClusterCellArray = tract_normalized();
    elseif (selectionStr == "bi-normalized")
        normalizedAxonalCountsPerParcelPerClusterCellArray = binormalized();
    else
        return;
    end
    
    nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

    outFileName = sprintf('./output/%s__%s_%s.xlsx', axonalCountsPerParcelPerClusterFileName(1:end-5), selectionStr, nowDateStr);
    writecell(normalizedAxonalCountsPerParcelPerClusterCellArray, outFileName);

end % nnls_all()