function rawCell = open_str_xlsx_data_file(fileName)

    fprintf('\nLoading clustered neurons from data file ...\n');
    
    fileNameFull = sprintf('./data/%s', fileName);

    dataStr{1} = readcell(fileNameFull);

    rawCell = dataStr{1};

end % open_str_xlsx_data_file()
