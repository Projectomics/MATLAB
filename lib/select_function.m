function choice = select_function()

    choices = { 'Load Files and Binarize Data', ...
                'Shuffle', ...
                'Analyze Data', ...
                'Hierarchical Clustering', ...
                'Call Functions on One Region', ...
                'Call Functions on One Region Preserving Laterality', ...
                'Call Functions on Specific Parcels', ...
                'Call Functions on Specific Parcels Preserving Laterality', ...
                'Analysis of Divergence', ...
                'Analysis of Convergence', ...
                'Soma Analysis', ...
                'NNLS Analysis'};

    reply = [];
    
    % main loop to display menu choices and accept input
    % terminates when user chooses to exit
    while (isempty(reply))
        % display menu
        
        clc;
        
        fprintf('Please select the function to start with from the selections below:\n\n');
        
        fprintf('\t 1) Load Files and Binarize Data\n');
        fprintf('\t 2) Shuffle\n');
        fprintf('\t 3) Analyze Data\n');
        fprintf('\t 4) Hierarchical Clustering\n');
        fprintf('\t 5) Call Functions on One Region\n');
        fprintf('\t 6) Call Functions on One Region Preserving Laterality\n');
        fprintf('\t 7) Call Functions on Specific Parcels\n');
        fprintf('\t 8) Call Functions on Specific Parcels Preserving Laterality\n');
        fprintf('\t 9) Analysis of Divergence\n');
        fprintf('\t10) Analysis of Convergence\n');
        fprintf('\t11) Soma Analysis\n');
        fprintf('\t12) Non-Negative Least Squares (NNLS) Analysis\n');
        fprintf('\t !) Exit\n');
        
        reply = input('\nYour selection: ', 's');
        
        % process input
        
        if strcmp(reply, '!')
            choice = '!';
        else 
            num = str2double(reply);
            
            if ((num > 0) && (num <= 12))
                choice = choices{num};
            else
                reply = [];
            end % if num
        end

    end % while loop

end % select_function()