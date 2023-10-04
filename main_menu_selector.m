function main_menu_selector(varargin)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');

    if (nargin == 0)
        nShuffles = 100000;
        isUseOriginalAlgorithm = 1;
    else
        nShuffles = varargin{1};
        isUseOriginalAlgorithm = varargin{2};
    end

    choice = select_function();

    rng(0);
    
    reply = [];
        
    if strcmp(choice, 'Load MouseLight JSON Files and Pre-process Data')

        % Store the current date and time in a string
        nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

        % Load all MouseLight reconstruction JSON files from the data
        % directory; store the somatic, dendritic, and axonal data in a 
        % structure array; and save the structure array to an Excel file
        morphologyMatrix = load_MouseLight_JSON_files(nowDateStr);

        % Remove all the parcel columns with no axonal counts from the
        % structure array and save the resulting structure array to an
        % Excel file
        filteredRawMatrix = filter_matrix(morphologyMatrix, 'ALL', nowDateStr);
        save_axonal_counts_per_parcel(filteredRawMatrix, 'ALL', nowDateStr);
        
%         groupings = sort_brain_regions(morphologyMatrix); 
%         save_neurons_sorted_by_region(groupings, 'ALL', nowDateStr);
%         
%         groupings = sort_brain_parcels(morphologyMatrix); 
%         save_neurons_sorted_by_parcel(groupings, 'ALL', nowDateStr);
% 
%         morphologyMatrix = get_num_axonal_invasions(groupings, morphologyMatrix);
%         save_summary_matrix(morphologyMatrix, 'ALL');
     
    elseif strcmp(choice, 'Shuffle Data')

        % Choose the base file name from a pre-prepared selection for the
        % count data that is to be processed
        dataFileNameBase = select_data_file_name();

        % Exit the program when the user chooses to exit
        if strcmp(dataFileNameBase, '!')
            fprintf('\nExiting\n\n');
            return;
        end
    
        % Configure a label consisting of the data's base file name and a
        % short-hand description of the number of shuffles that the user
        % selected
        nShufflesLabel = configure_shuffles_label(nShuffles, dataFileNameBase);
    
        % Generate the data's Excel file name
        xlsxDataFileNameBase = sprintf('%s.xlsx', dataFileNameBase);

        % Randomize a matrix a user-selected number of times using one of two
        % algorithms and save the resulting shuffled matrix to an Excel file
        shuffle_data(xlsxDataFileNameBase, nShufflesLabel, nShuffles, isUseOriginalAlgorithm);
        
    elseif strcmp(choice, 'Statistically Analyze Data')

        % Choose the base file name from a pre-prepared selection for the
        % count data that is to be processed
        dataFileNameBase = select_data_file_name();
    
        % Exit the program when the user chooses to exit
        if strcmp(dataFileNameBase, '!')
            fprintf('\nExiting\n\n');
            return;
        end
    
        % Configure a label consisting of the data's base file name and a
        % short-hand description of the number of shuffles that the user
        % selected
        nShufflesLabel = configure_shuffles_label(nShuffles, dataFileNameBase);
    
        % Generate the data's Excel file name
        xlsxDataFileNameBase = sprintf('%s.xlsx', dataFileNameBase);

        % Store the current date and time in a string
        nowDateStr = datetime('now', 'Format', 'yyyyMMddHHmmSS');

        isUseShufflesLabel = 1;

        % Calculate the angle between pairs of vectors (rows of a matrix)
        % and save the results to file
        origAngles = determine_vector_angles(xlsxDataFileNameBase, ...
            nShufflesLabel, isUseShufflesLabel, nowDateStr);
        
        % Select an Excel file name to process
        fprintf('Please select the shuffled data file to call analyze.\n\n');
        reply = select_xlsx_file_name('Select shuffled data file:', strcat(nShufflesLabel,'__fully_shuffled'));

        % Exit the program when the user chooses to exit
        if strcmp(reply, '!')
            fprintf('\nExiting\n\n');
            return;
        end

        isUseShufflesLabel = 0;

        % Calculate the angle between pairs of vectors (rows of a matrix)
        % and save the results to file
        randAngles = determine_vector_angles(reply, nShufflesLabel, ...
            isUseShufflesLabel, nowDateStr);

        % Create histograms from the original and randomized sets of angle
        % data in which the maximum of the histogram of the randomized data
        % is scaled to equal to that of the original data and to conduct
        % Levene's statistical comparison of variances on the two
        % distributions of angle data 
        create_scaled_histogram(origAngles, randAngles, nShufflesLabel, nowDateStr);

    elseif strcmp(choice, 'Hierarchical Clustering')

        % Choose the base file name from a pre-prepared selection for the
        % count data that is to be processed
        dataFileNameBase = select_data_file_name();
    
        % Exit the program when the user chooses to exit
        if strcmp(dataFileNameBase, '!')
            fprintf('\nExiting\n\n');
            return;
        end
    
        % Configure a label consisting of the data's base file name and a
        % short-hand description of the number of shuffles that the user
        % selected
        nShufflesLabel = configure_shuffles_label(nShuffles, dataFileNameBase);
    
        % Select an Excel file name to process
        reply = select_xlsx_file_name('Select angles data file:', strcat(nShufflesLabel,'__angles'));

        % Exit the program when the user chooses to exit
        if strcmp(reply, '!')
            fprintf('\nExiting\n\n');
            return;
        else
            % Perform unsupervised hierarchical clustering based on
            % Levene's statistical test for comparison of variances to
            % decide if a splitting in the dendrogram is significant and
            % should be continued
            hierarchical_clustering(reply, dataFileNameBase, nShufflesLabel, nShuffles, isUseOriginalAlgorithm);
        end

    elseif strcmp(choice, 'Analysis of Axonal Divergence')

        % Select an Excel file name to process
        reply = select_xlsx_file_name('Please select a file of neuron names by cluster for an analysis of axonal divergence.', 'divergence');
        
        % Exit the program when the user chooses to exit
        if strcmp(reply, '!')
            fprintf('\nExiting\n\n');
            return;
        end

        % Store in a cell array the neuron names broken down by cluster
        neuronNamesByClusterCellArray = open_str_xlsx_data_file(reply);

        % Select a parcel abbreviation for tagging saved files
        parcelAbbreviation = input('\nEnter the abbreviation for the parcel being analyzed (e.g., PRE for presubiculum): ', 's');

        % 
        analysis_divergence(neuronNamesByClusterCellArray, parcelAbbreviation);

    elseif strcmp(choice, 'Analysis of Axonal Convergence')

        reply = select_xlsx_file_name('Please select a file of neuron names by cluster for an analysis of axonal convergence.', 'convergence');
        
        if strcmp(reply, '!')
            fprintf('\nExiting\n\n');
            return;
        end

        neuronNamesByClusterCellArray = open_str_xlsx_data_file(reply);

        parcelAbbreviation = [];
        parcelAbbreviation = input('\nEnter the abbreviation for the parcel being analyzed (e.g., PRE for presubiculum): ', 's');

        parcelsFileFullFileName = sprintf('./data/%s__convergence_parcels.xlsx', parcelAbbreviation);
    
        fid = fopen(parcelsFileFullFileName);
        if (fid == -1)
            fprintf('Failed to open data file.\n\n');
            return;
        end
        fclose(fid);

        parcelsCellArray = readcell(parcelsFileFullFileName);

        analysis_convergence(neuronNamesByClusterCellArray, parcelsCellArray, parcelAbbreviation);

    elseif strcmp(choice, 'Soma Analysis')

        reply = select_xlsx_file_name('Please select a file of neuron names by cluster for a somatic convex hull analysis.', 'somata');
        
        if strcmp(reply, '!')
            fprintf('\nExiting\n\n');
            return;
        end

        neuronNamesByClusterCellArray = open_str_xlsx_data_file(reply);

        parcelAbbreviationStr = [];
        parcelAbbreviationStr = input('\nEnter the abbreviation for the parcel being analyzed (e.g., PRE for presubiculum): ', 's');

        convex_hull_outliers(neuronNamesByClusterCellArray, parcelAbbreviationStr);

    elseif strcmp(choice, 'NNLS Analysis')
        
        reply = select_xlsx_file_name('Please select a file of axonal counts per parcel per cluster for non-negative least squares analysis.', 'NNLS');
        
        if strcmp(reply, '!')
            fprintf('\nExiting\n\n');
            return;
        end

        axonalCountsPerParcelPerClusterCellArray = open_str_xlsx_data_file(reply);

        nnls(axonalCountsPerParcelPerClusterCellArray, reply);
    
    elseif strcmp(choice, 'Strahler Order Analysis of the Presubiculum')

        Strahler();
        
    end

    fprintf('\nExiting\n\n');

end % main_menu_selector()
    