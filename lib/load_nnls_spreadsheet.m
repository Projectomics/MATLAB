function nnlsSpreadsheetMatrix = load_nnls_spreadsheet()

    regionStr = [];
    regionStr = input('\nEnter the abbreviation for the parcel being analyzed (e.g., PRE for presubiculum): ', 's');

    nnlsPrefix = strcat(regionStr, '_matrix');

    reply = select_xlsx_file_name('Please select a file of axonal counts per neuron per parcel for a non-negative least squares analysis.', nnlsPrefix);
    
    if strcmp(reply, '!')
        nnlsSpreadsheetMatrix = reply;
        return;
    end
    
    nnlsSpreadsheetMatrix = open_str_xlsx_data_file(reply);

end % load_nnls_spreadsheet()