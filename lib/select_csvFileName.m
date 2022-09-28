function csvFileName = select_csvFileName(instructionStr, fileNameBase)

    fileDir = sprintf('./data/%s*.csv', fileNameBase);
    
    csvFiles = dir(fileDir);
    nCsvFiles = length(csvFiles);

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))

        % display menu
        
        fprintf('%s\n\n', instructionStr);
        fprintf('Please select your .csv file from the selections below:\n\n');

        for i = 1:nCsvFiles
            fprintf('%6d) %s\n', i, csvFiles(i).name);
        end % for i
        
        fprintf('     !) Exit\n');
        
        reply = input('\nYour selection: ', 's');
        
        % process input
        
        if strcmp(reply, '!')
            csvFileName = '!';
        else 
            num = str2double(reply);

            if (num <= nCsvFiles)
                csvFileName = sprintf(csvFiles(num).name);
            else
                reply = [];
            end % if num
        end

    end % while loop

end % select_csvFileName()