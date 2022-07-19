function csvFileName = select_csvfileName()

%     if (isARA == 1)
%         fileDir = sprintf('./data/*ara*.nrrd');
%     elseif (isARA == 0)
%         fileDir = sprintf('./data/*ccf*.nrrd');
%     elseif (isARA == 3)
%         fileDir = sprintf('./data/*ccf*.nrrd');
%     end
    fileDir = sprintf('./output/*.csv');
    
    csvFiles = dir(fileDir);
    nCsvFiles = length(csvFiles);

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        strng = sprintf('Please select your .csv file from the selections below:\n');
        disp(strng);

        for i = 1:nCsvFiles
            strng = sprintf('    %2d) %s', i, csvFiles(i).name);
            disp(strng);
        end % for i
        
        disp('     !) Exit');
        
        reply = input('\nYour selection: ', 's');

        
        %% process input %%
        
        if strcmp(reply, '!')
            csvFileName = '!';
        else 
            num = str2double(reply);
            
            if num <= nCsvFiles
                %csvFileName = sprintf('./output/%s', nrrdFiles(num).name);
                csvFileName = sprintf(csvFiles(num).name);
            else
                reply = [];
            end % if num
        end
        
    end % while loop

end % select_file()