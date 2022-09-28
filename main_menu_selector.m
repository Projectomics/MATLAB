function main_menu_selector(varargin)

    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('./lib/COMP_GEOM_TLBX');

    if (nargin == 0)
        nShuffles = 1000000000;
    else
        nShuffles = varargin{1};
    end

    labelBase = select_label();

    nShufflesLabel = configure_label(nShuffles, labelBase);
    
    choice = select_function();

    reply = [];
        
    if strcmp(choice, 'Load Files and Binarize Data')
        morphologyMatrix = load_files(); 
        filteredRawMatrix = filter_bin_matrix(morphologyMatrix, morphologyMatrix, 'all');
        save_raw_morphology_matrix(filteredRawMatrix, 'all');
        
        groupings = sort_brain_regions(morphologyMatrix); 
        save_sorted_neurons(groupings);
        
        groupings = sort_brain_parcels(morphologyMatrix); 
        save_sorted_parcels(groupings); 
        morphologyMatrix = get_num_invasions(groupings, morphologyMatrix);
        save_summary_matrix(morphologyMatrix);
     
    elseif strcmp(choice, 'Shuffle')

        while (isempty(reply))

            reply = sprintf('%s.csv', labelBase);

            if strcmp(reply, '!')
                fprintf('\nExiting\n');
            else
                fid = fopen(strcat('./data/', reply));
                if (fid == -1)
                    reply = [];
                else
                    fclose(fid);
		            shuffle_raw_updated(reply, nShufflesLabel, nShuffles);
                end
            end

        end % while
        
    elseif strcmp(choice, 'Analyze Data')

        while (isempty(reply))
        
            reply = sprintf('%s.csv', labelBase);

            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid = fopen(strcat('./data/', reply));
                if(fid == -1)
                    reply = [];
                else
                    fclose(fid);
                    binDifferences = raw_MouseLight(reply, nShufflesLabel, 1);
                end
            end                           
        
        end % while

        reply = [];
        while (isempty(reply))

            clc;

            fprintf('Please select the shuffled data file to call MouseLight on.\n\n');
            reply = select_csvFileName('Select shuffled data file:', [nShufflesLabel,'_matrix_fullyShuffled_']);

            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    randDifferences = raw_MouseLight(reply, nShufflesLabel, 0);
                    [p, stats] = create_scaled_histogram(binDifferences, randDifferences, nShufflesLabel);
                end
            end

        end % while
        
    elseif strcmp(choice, 'Hierarchical Clustering')
        while (isempty(reply))
            reply = select_csvFileName('Select differences_doublesAxon file:');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    idClusters = hierarchical_clustering_optimized(reply, nShufflesLabel, nShuffles);
                end
            end
        end

    elseif strcmp(choice, 'Call Functions on One Region')  
        while (isempty(reply))
            reply = select_csvFileName('Please select a file with neurons sorted by region.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    reply2 = [];
                    while (isempty(reply2))
                        disp('Please input a brain region to call functions on (i.e. Primary motor area).');
                        reply2 = input('\nYour selection: ', 's');                
                    end
                    regionNeurons = get_region_neurons(reply, reply2);
                    morphologyMatrix = load_region_files(regionNeurons, reply2);
                    filteredRawMatrix = filter_bin_matrix(morphologyMatrix, morphologyMatrix, reply2);
                    rawFileName = save_raw_morphology_matrix(filteredRawMatrix, reply2);
                    randFileName = shuffle_raw_updated(rawFileName, reply2, nShuffles);
                    binDifferences = raw_MouseLight(rawFileName, nShufflesLabel, 1);
                    randDifferences = raw_MouseLight(randFileName, nShufflesLabel, 0);
                    [p, stats] = create_scaled_histogram(binDifferences, randDifferences, reply2);
                end
            end                              
        end  

    elseif strcmp(choice, 'Call Functions on One Region Preserving Laterality')  
        while (isempty(reply))
            reply = select_csvFileName('Please select a file with neurons sorted by region.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    reply2 = [];
                    while (isempty(reply2))
                        disp('Please input a brain region to call functions on (i.e. Primary motor area).');
                        reply2 = input('\nYour selection: ', 's');                
                    end
                    regionNeurons = get_region_neurons(reply, reply2);
                    morphologyMatrix = load_region_files_laterality(regionNeurons, reply2);
                    filteredRawMatrix = filter_bin_matrix(morphologyMatrix, morphologyMatrix, reply2);
                    rawFileName = save_raw_morphology_matrix(filteredRawMatrix, reply2);
                    randFileName = shuffle_raw_laterality(rawFileName, reply2, filteredRawMatrix, nShuffles);
                    binDifferences = raw_MouseLight(rawFileName, nShufflesLabel, 1);
                    randDifferences = raw_MouseLight(randFileName, nShufflesLabel, 0);
                    [p, stats] = create_scaled_histogram(binDifferences, randDifferences, reply2);
                end
            end                              
        end  

    elseif strcmp(choice, 'Call Functions on Specific Parcels')
        while (isempty(reply))
            reply = select_textFileName('Please select a file with neurons sorted by region.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    reply2 = [];
                    parcelIndex = 1;
                    count = 0;
                    while (isempty(reply2) | reply2 ~= '!')
                        disp('Please input the parcels to call functions on (input ! to exit).');
                        reply2 = input('\nYour selection: ', 's');
                        if ~strcmp(reply2, '!')
                            count = 1;
                            parcelArray{parcelIndex} = reply2;
                            parcelIndex = parcelIndex+1;
                        end  
                    end
                    if (count == 0)
                       disp('Exiting'); 
                    else
                        regionNeurons = get_parcel_neurons(reply, parcelArray);
                        morphologyMatrix = load_region_files(regionNeurons, 'pma_layer6');
                        filteredRawMatrix = filter_bin_matrix(morphologyMatrix, morphologyMatrix, 'pma_layer6');
                        rawFileName = save_raw_morphology_matrix(filteredRawMatrix, 'pma_layer6');
                        randFileName = shuffle_raw_updated(rawFileName, 'pma_layer6', nShuffles);
                        binDifferences = raw_MouseLight(rawFileName, nShufflesLabel, 1);
                        randDifferences = raw_MouseLight(randFileName, nShufflesLabel, 0);
                        [p, stats] = create_scaled_histogram(binDifferences, randDifferences, 'pma_layer6');
                    end
                end
            end                              
        end  

    elseif strcmp(choice, 'Call Functions on Specific Parcels Preserving Laterality')
        while (isempty(reply))
            reply = select_textFileName('Please select a file with neurons sorted by region.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    reply2 = [];
                    parcelIndex = 1;
                    count = 0;
                    while (isempty(reply2) | reply2 ~= '!')
                        disp('Please input the parcels to call functions on (input ! to exit).');
                        reply2 = input('\nYour selection: ', 's');
                        if ~strcmp(reply2, '!')
                            count = 1;
                            parcelArray{parcelIndex} = reply2;
                            parcelIndex = parcelIndex+1;
                        end  
                    end
                    if (count == 0)
                       disp('Exiting'); 
                    else
                        regionNeurons = get_parcel_neurons(reply, parcelArray);
                        morphologyMatrix = load_region_files_hemispheres(regionNeurons, 'pma_layer6');
                        filteredRawMatrix = filter_bin_matrix(morphologyMatrix, morphologyMatrix, 'pma_layer6');
                        rawFileName = save_raw_morphology_matrix(filteredRawMatrix, 'pma_layer6');
                        randFileName = shuffle_raw_laterality(rawFileName, 'pma_layer6', filteredRawMatrix, nShuffles);
                        binDifferences = raw_MouseLight(rawFileName, nShufflesLabel, 1);
                        randDifferences = raw_MouseLight(randFileName, nShufflesLabel, 0);
                        [p, stats] = create_scaled_histogram(binDifferences, randDifferences, 'pma_layer6');
                    end
                end
            end                              
        end  

    elseif strcmp(choice, 'Analysis of Divergence')
        while (isempty(reply))
            reply = select_csvFileName('Please select a file for an analysis of divergence.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    matrix = open_str_data_file2(reply);
                    analysis_divergence(matrix, 'PRE');
                end
            end                              
        end

    elseif strcmp(choice, 'Analysis of Convergence')
        while (isempty(reply))
            reply = select_csvFileName('Please select a file for an analysis of convergence.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    matrix = open_str_data_file2(reply);
                    analysis_convergence(matrix, 'PRE');
                end
            end                              
        end

    elseif strcmp(choice, 'Soma Analysis')
        while (isempty(reply))
            reply = select_csvFileName('Please select a file for a soma analysis.');
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(strcat('./data/', reply));
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    matrix = open_str_data_file2(reply);
                    convexHull_outliers(matrix, 'PRE');
                end
            end                              
        end
        
    elseif strcmp(choice, 'NNLS Analysis')
        nnls_all();
        
    else
        fprintf('\nExiting\n');
    end

    fprintf('\nExiting\n');

end % main_menu_selector()
    