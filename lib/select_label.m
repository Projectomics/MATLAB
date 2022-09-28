function choice = select_label()

    choices = readcell('./data/labels.txt');

    reply = [];
    nChoices = length(choices);
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        %% display menu %%
        
        clc;
        
        disp('Please select the function to start with from the selections below:');

        fprintf('\n');

        for i = 1:nChoices
            fprintf('%6d) %s\n', i, choices{i});
        end

        fprintf('     !) Exit\n');
        
        reply = input('\nYour selection: ', 's');

        
        %% process input %%
        if strcmp(reply, '!')
            choice = '!';
        else 
            num = str2double(reply);
            
            if ((num > 0) && (num <= nChoices))
                choice = choices{num};
            else
                reply = [];
            end % if num
        end

    end % while loop

end % select_label()