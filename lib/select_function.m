function choice = select_function()

    choices = { 'Load MouseLight JSON Files and Pre-process Data', ...
                'Shuffle Data', ...
                'Statistically Analyze Data', ...
                'Hierarchical Clustering', ...
                'Analysis of Axonal Divergence', ...
                'Analysis of Axonal Convergence', ...
                'Soma Analysis', ...
                'NNLS Analysis', ...
                'Strahler Order Analysis of the Presubiculum'};

    reply = [];
    nChoices = length(choices);    
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        % display menu
        
        clc;
        
        fprintf('Please select the function to start with from the selections below:\n\n');
        
        for i = 1:nChoices
            fprintf('%6d) %s\n', i, choices{i});
        end

        fprintf('     !) Exit\n');
        
        reply = input('\nYour selection: ', 's');
        
        % process input
        
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

end % select_function()