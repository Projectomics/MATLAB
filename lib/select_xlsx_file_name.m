function xlsxFileName = select_xlsx_file_name(instructionStr, fileNameBase)

    fileDir = sprintf('./data/%s*.xlsx', fileNameBase);
    
    xlsxFiles = dir(fileDir);
    nXlsxFiles = length(xlsxFiles);

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))

        % display menu
        
        clc;
        
        fprintf('%s\n\n', instructionStr);
        fprintf('Please select your .xlsx file from the selections below:\n\n');

        for i = 1:nXlsxFiles
            fprintf('%6d) %s\n', i, xlsxFiles(i).name);
        end % for i
        
        fprintf('     !) Exit\n');
        
        reply = input('\nYour selection: ', 's');
        
        % process input
        
        if strcmp(reply, '!')
            xlsxFileName = '!';
        else 
            num = str2double(reply);

            if (num <= nXlsxFiles)
                xlsxFileName = sprintf(xlsxFiles(num).name);
            else
                reply = [];
            end % if num
        end

    end % while loop

end % select_xlsx_file_name()