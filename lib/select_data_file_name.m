function choice = select_data_file_name()
% Function to choose the base file name from a pre-prepared selection for
% the count data that is to be processed

    % Read data file name choices from an Excel file
    choices = readcell('./data/data_file_name_bases.xlsx');

    reply = [];
    nChoices = length(choices);
    
    % Main loop to display menu choices and accept input
    % Terminates when the user chooses to exit
    while (isempty(reply))

        clc; % Clear the command window
        
        % Display the menu header
        fprintf('Please select the data file name to process from the selections below:\n\n');

        % Display the menu options
        for i = 1:nChoices
            fprintf('%6d) %s\n', i, choices{i});
        end

        fprintf('     !) Exit\n');
        
        % Accept user input
        reply = input('\nYour selection: ', 's');

        
        % Process the input
        if strcmp(reply, '!')
            choice = '!'; % Set choice to exit
        else 
            num = str2double(reply);
            
            % Check if the input is within valid range
            if ((num > 0) && (num <= nChoices))
                choice = choices{num}; % Set choice to the selected data file name
            else
                reply = []; % Reset input if out of range
            end
        end % strcmp

    end % while

end % select_data_file_name()