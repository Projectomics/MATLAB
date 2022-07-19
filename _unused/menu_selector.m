function menu_selector()
    
    addpath('./lib/');
    addpath('./output/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');

    clear all;
    
    %neuronArray = [2, 4, 6, 11, 12, 15, 23, 24, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 46, 47, 48, 49, 51];
    %neuronArray = [1, 3, 5, 7, 8, 9, 10, 13, 14, 16, 18, 19, 20, 21, 22, 25, 44, 45, 50];	
    %call_all_functions(neuronArray, 2);
    
    choice = select_function();
    %disp(choice);
    reply = [];
        
    if strcmp(choice, 'Load Files and Binarize Data')
        morphologyMatrix = load_files();
        %morphologyMatrix = load_files_hemispheres();
        %binMorphologyMatrix = binarize_morphology_matrix(morphologyMatrix);
        %save_bnMorphologyMatrx(binMorphologyMatrix, morphologyMatrix, 'all');   
        %filteredBinMatrix = filter_bin_matrix(binMorphologyMatrix);
        %save_filtered_bin_matrix(filteredBinMatrix, 'all');
        
        groupings = sort_brain_regions(morphologyMatrix); 
        save_sorted_neurons(groupings);
        
        %groupings = sort_brain_parcels(morphologyMatrix); 
        %save_sorted_parcels(groupings); 
        %morphologyMatrix = get_num_invasions(groupings, morphologyMatrix);
        %save_summary_matrix(morphologyMatrix);
     
    elseif strcmp(choice, 'Shuffle')
        while (isempty(reply))
            %disp('Please select a file to shuffle.');
            %reply = input('\nYour selection: ', 's');
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid = fopen(reply);
                if(fid == -1)
                    reply = [];
                else
                    fclose(fid);
                    %shuffle_preserve_rows(reply, 'Subiculum');
                    %shuffle_preserve_cols(reply, 'Primary motor area');
                    %shuffle_random(reply, 'Presubiculum');
                    shuffle_both_constraints(reply, 'deep_layers_binary');
                end
            end            
        end
        
    elseif strcmp(choice, 'Analyze Data')
        while (isempty(reply))
            %disp('Please select the first file to call MouseLight on.');
            %reply = input('\nYour selection: ', 's');
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid = fopen(reply);
                if(fid == -1)
                    reply = [];
                else
                    fclose(fid);
                    binDifferences = MouseLight(reply);
                    %create_histogram(binDifferences, 'all');
                end
            end                              
        end
        reply = [];
        while (isempty(reply))
            %disp('Please select the second file to call MouseLight on.');
            %reply = input('\nYour selection: ', 's');
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(reply);
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    randDifferences = MouseLight(reply);
                    %[p, stats] = create_scaled_histogram_levenes(binDifferences, randDifferences, 'Primary motor area');
                    [p, stats] = create_scaled_histogram(binDifferences, randDifferences, 'deep_layers_binary');
                    disp(p);
                end
            end                  
        end
        
    elseif strcmp(choice, 'Call Functions on One Region')  
        while (isempty(reply))
            %disp('Please select a file with neurons sorted by region.');
            %reply = input('\nYour selection: ', 's');
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(reply);
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
                    %morphologyMatrix = load_region_files_laterality(regionNeurons, reply2);
                    binMorphologyMatrix = binarize_morphology_matrix(morphologyMatrix);    
                    binFileName = save_bnMorphologyMatrx(binMorphologyMatrix, morphologyMatrix, reply2);
                    filteredBinMatrix = filter_bin_matrix(binMorphologyMatrix, morphologyMatrix, reply2);
                    binFileName = save_filtered_bin_matrix(filteredBinMatrix, reply2);                   
                    randFileName = shuffle_both_constraints(binFileName, reply2);
                    %randFileName = shuffle_preserve_cols(binFileName, reply2);
                    binDifferences = MouseLight(binFileName);
                    randDifferences = MouseLight(randFileName);
                    [p, stats] = create_scaled_histogram(binDifferences, randDifferences, reply2);
                end
            end                              
        end  
    elseif strcmp(choice, 'Call Functions on Specific Parcels')
        while (isempty(reply))
            %disp('Please select a file with neurons sorted by region.');
            %reply = input('\nYour selection: ', 's');
            reply = select_textFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(reply);
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
                    if(count == 0)
                       disp('Exiting'); 
                    else
                        regionNeurons = get_parcel_neurons(reply, parcelArray);
                        morphologyMatrix = load_region_files(regionNeurons, 'pma_layer6');
                        %morphologyMatrix = load_region_files_laterality(regionNeurons, 'pma_layer6');
                        binMorphologyMatrix = binarize_morphology_matrix(morphologyMatrix);    
                        binFileName = save_bnMorphologyMatrx(binMorphologyMatrix, morphologyMatrix, 'pma_layer6');
                        filteredBinMatrix = filter_bin_matrix(binMorphologyMatrix, morphologyMatrix, 'pma_layer6');
                        binFileName = save_filtered_bin_matrix(filteredBinMatrix, 'pma_layer6');
                        randFileName = shuffle_both_constraints(binFileName, 'pma_layer6');
                        %randFileName = shuffle_both_constraints_laterality(binFileName, 'pma_layer6', filteredBinMatrix);
                        binDifferences = MouseLight(binFileName);
                        %create_histogram(binDifferences, reply2);
                        randDifferences = MouseLight(randFileName);
                        %create_histogram(randDifferences, reply2);
                        [p, stats] = create_scaled_histogram(binDifferences, randDifferences, 'pma_layer6');
                    end
                end
            end                              
        end  
    elseif strcmp(choice, 'Get Regions to Call Functions on')
        while (isempty(reply))
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(reply);
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    reply2 = [];
                    while (isempty(reply2))
                        disp('Please input a numeric threshold.');
                        reply2 = str2double(input('\nYour selection: ', 's'));       
                    end
                    get_regions(reply, reply2);
                end
            end                              
        end
    elseif strcmp(choice, 'Hierarchical Clustering')        
        while (isempty(reply))
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid2 = fopen(reply);
                if(fid2 == -1)
                    reply = [];
                else
                    fclose(fid2);
                    hierarchical_clustering_updated(reply, 'Presubiculum');
                end
            end                              
        end     
    elseif strcmp(choice, 'Test Methodology')
        [setA, setB, setADifferences, setBDifferences] = validate_method();
        validate_hierarchical_clustering(reply, 'setA', setA, setADifferences);
    elseif strcmp(choice, 'All')
        morphologyMatrix = load_files();
        binMorphologyMatrix = binarize_morphology_matrix(morphologyMatrix);    
        binFileName = save_bnMorphologyMatrx(binMorphologyMatrix, morphologyMatrix, 'all');
        filteredBinMatrix = filter_bin_matrix(binMorphologyMatrix);
        binFileName = save_filtered_bin_matrix(filteredBinMatrix, 'all');
        
        randFileName = shuffle_both_constraints(binFileName, 'all');
        binDifferences = MouseLight(binFileName);
        %create_histogram(binDifferences, 'all');
        randDifferences = MouseLight(randFileName);
        %create_histogram(randDifferences, 'all');
        [p, stats] = create_scaled_histogram(binDifferences, randDifferences, 'all');
        groupings = sort_brain_regions(morphologyMatrix); 
        save_sorted_neurons(groupings);
        groupings = sort_brain_parcels(morphologyMatrix); 
        save_sorted_parcels(groupings); 
        morphologyMatrix = get_num_invasions(groupings, morphologyMatrix);
        save_summary_matrix(morphologyMatrix);
        
    else
        disp('Exiting');
    end
end
    