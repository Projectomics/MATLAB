function choice = select_normalization()

    choices = { 'matrix_normalized', ...
                'column_normalized', ...
                'row_normalized', ...
                'tract_normalized', ...
                'bi-normalized'};

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        % display menu
        
        clc;
        
        fprintf('Please select the normalization scheme from the selections below:\n\n');
        
        fprintf('\t1) Matrix Normalized\n');
        fprintf('\t2) Column Normalized\n');
        fprintf('\t3) Row Normalized\n');
        fprintf('\t4) Tract Normalized\n');
        fprintf('\t5) Bi-normalized\n');
        fprintf('\t!) Exit\n');
        
        reply = input('\nYour selection: ', 's');
        
        % process input
        
        if strcmp(reply, '!')
            choice = '!';
        else 
            num = str2double(reply);
            
            if ((num > 0) && (num <= 5))
                choice = choices{num};
            else
                reply = [];
            end % if num
        end

    end % while loop

end % select_normalization()