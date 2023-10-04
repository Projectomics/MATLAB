function fileName = save_axonal_counts_per_parcel(morphologyMatrix, regionStr, nowDateStr)
% Function to save the axonal counts per parcel from the morphologyMatrix
% structure array to an Excel file

    fprintf('\nSaving axonal counts per parcel ...\n');
    
    % Define the output file path and generate the output file name
    filePath = './output/';
    fileName = sprintf('%s__axonal_counts_per_parcel_%s.xlsx', regionStr, nowDateStr);   
    outputFullFileName = strcat(filePath, fileName);

    % Write the axonal counts matrix to an Excel file
    writematrix(morphologyMatrix.axonCounts, outputFullFileName);

    % Copy the output file to the data directory
    dataFullFileName = strcat('./data/', fileName);
    copyfile(outputFullFileName, dataFullFileName);

end % save_axonal_counts_per_parcel