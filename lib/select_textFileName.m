function txtFileName = select_textFileName(instructionStr)

    fileDir = sprintf('./data/*.txt');
    
    txtFiles = dir(fileDir);
    nTxtFiles = length(txtFiles);

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        fprintf('%s\n\n', instructionStr);
        fprintf('Please select your .txt file from the selections below:\n\n');

        strng = sprintf('%s:\n', instructionStr);
        disp(strng);

        for i = 1:nTxtFiles
            strng = sprintf('    %2d) %s', i, txtFiles(i).name);
            disp(strng);
        end % for i
        
        disp('     !) Exit');
        
        reply = input('\nYour selection: ', 's');

        
        %% process input %%
        
        if strcmp(reply, '!')
            txtFileName = '!';
        else 
            num = str2double(reply);
            
            if num <= nTxtFiles
                %csvFileName = sprintf('./output/%s', nrrdFiles(num).name);
                txtFileName = sprintf(txtFiles(num).name);
            else
                reply = [];
            end % if num
        end
        
    end % while loop

end % select_textFileName()