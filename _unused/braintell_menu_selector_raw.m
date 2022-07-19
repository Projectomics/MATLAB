function braintell_menu_selector_raw()
    
    addpath('./lib/');
    addpath('./output/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    addpath('../dir_MouseLight_ASSIP/lib/');

    clear all;
    
    choice = select_function();
    %disp(choice);
    reply = [];
        
    if strcmp(choice, 'Load Files and Binarize Data')        
        %fileName = braintell_soma_region();
        %braintell_sort_by_region(fileName);
        disp('Enter file to binarize.');
        while (isempty(reply))
            reply = select_csvFileName();
            if strcmp(reply, '!')
                disp('Exiting');
            else
                fid = fopen(reply);
                if(fid == -1)
                    reply = [];
                else
                    fclose(fid);
                    braintell_binarize(reply, 'all');
                end
            end            
        end
    
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
                    braintell_shuffle_raw(reply, 'test');
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
                    binDifferences = raw_MouseLight(reply);
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
                    randDifferences = raw_MouseLight(reply);
                    %create_histogram(randDifferences, 'all');
                    [p, stats] = create_scaled_histogram(binDifferences, randDifferences, 'Zona incerta');
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
                    rawFileName = braintell_load_region_matrix(regionNeurons, reply2);
                    %binFileName = braintell_binarize(rawFileName, reply2);
                    %rawFileName = 'Agranular insular area_combinedRaw_20210425224012.csv';
                    randFileName = braintell_shuffle_raw(rawFileName, reply2);
                    rawDifferences = raw_Braintell(rawFileName);
                    randDifferences = raw_Braintell(randFileName);
                    [p, stats] = create_scaled_histogram(rawDifferences, randDifferences, reply2);
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
                        rawFileName = braintell_load_region_matrix(regionNeurons, '-');
                        %binFileName = braintell_binarize(rawFileName, '-');                        
                        randFileName = braintell_shuffle_raw(rawFileName, '-');
                        rawDifferences = raw_MouseLight(rawFileName);
                        %create_histogram(binDifferences, reply2);
                        randDifferences = raw_MouseLight(randFileName);
                        %create_histogram(randDifferences, reply2);
                        [p, stats] = create_scaled_histogram(rawDifferences, randDifferences, '-');
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
                    idClusters = hierarchical_clustering_updated(reply, 'Agranular insular area');
                    %histogram_soma(idClusters, 'Presubiculum');
                    %cluster_scatterplot_soma(idClusters, 'Presubiculum');                    
                end
            end                              
        end     
    elseif strcmp(choice, 'All')
        binFileName = braintell_binarize('Braintell_all_raw.csv', 'all');
        randFileName = braintell_shuffle_both_constraints(binFileName, 'all');
        binDifferences = MouseLight(binFileName);
        randDifferences = MouseLight(randFileName);
        [p, stats] = create_scaled_histogram(binDifferences, randDifferences, reply2);        
    else
        disp('Exiting');
    end
end
    