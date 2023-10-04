function nnlsSpreadsheetMatrix = load_nnls_parcels()

    reply = select_xlsx_file_name('Please select a file of parcels for a non-negative least squares analysis.', 'NNLS_parcels');
    
    if strcmp(reply, '!')
        nnlsSpreadsheetMatrix = reply;
        return;
    end
    
    nnlsSpreadsheetMatrix = open_str_xlsx_data_file(reply);

end % load_nnls_parcels()