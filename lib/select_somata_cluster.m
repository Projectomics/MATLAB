function choice = select_somata_cluster(clusterNames, nthPosition)

    reply = [];
    nClusterNames = length(clusterNames);    
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        % display menu
        
        clc;
        
        fprintf('Please select the %s cluster for somatic analysis from the selections below:\n\n', nthPosition);
        
        for i = 1:nClusterNames
            fprintf('%6d) %s\n', i, clusterNames{i});
        end

        fprintf('     !) Exit\n');
        
        reply = input('\nYour selection: ', 's');
        
        % process input
        
        if strcmp(reply, '!')
            choice = '!';
        else 
            num = str2double(reply);
            
            if ((num > 0) && (num <= nClusterNames))
                choice = num;
            else
                reply = [];
            end % if num
        end

    end % while loop

end % select_somata_cluster()