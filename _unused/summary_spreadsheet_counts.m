function summary_spreadsheet_counts
    addpath('./lib/');
    addpath('./output/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    addpath('../dir_MouseLight_ASSIP/lib/');
    
    mouseLightParcelMatrix = open_str_data_file2_semicolon('sortedParcels_20200715004728.txt');
    braintellParcelMatrix = open_str_data_file2_semicolon('braintell_sorted_parcels_20201121005141.txt');
    mouseLightParcel = mouseLightParcelMatrix(:, 1);
    braintellParcel = braintellParcelMatrix(:, 1);
    allParcels = union(mouseLightParcel, braintellParcel);
    countMatrixParcel = zeros(length(allParcels), 3);
    
    for r = 1:length(allParcels)
       reg = allParcels(r);
       idx = find(ismember(reg, mouseLightParcel));
       if(isempty(idx))
           countMatrixParcel(r, 1) = 0;   
       else
           for r2  = 1:length(mouseLightParcel.')
                if(strcmp(mouseLightParcel(r2), reg))
                    temp = mouseLightParcelMatrix(r2, :);
                    indices = find(~cellfun(@isempty,temp));
                    count = indices(length(indices))-1;
                    countMatrixParcel(r, 1) = count;
                end
           end
       end
       idx = find(ismember(reg, braintellParcel));
       if(isempty(idx))
           countMatrixParcel(r, 2) = 0;           
       else
           for r2  = 1:length(braintellParcel.')
                if(strcmp(braintellParcel(r2), reg))
                    temp = braintellParcelMatrix(r2, :);
                    indices = find(~cellfun(@isempty,temp));
                    count = indices(length(indices))-1;
                    countMatrixParcel(r, 2) = count;
                end
           end
       end       
    end
    
    for i = 1:length(countMatrixParcel)
        countMatrixParcel(i, 3) = countMatrixParcel(i, 1)+countMatrixParcel(i, 2); 
    end    
    
    mouseLightRegionMatrix = open_str_data_file2('sortedNeurons_20201126081639_axons.csv');
    braintellRegionMatrix = open_str_data_file2('braintell_sorted_regions_20201121005141.csv');
    mouseLightRegion = mouseLightRegionMatrix(:, 1);
    braintellRegion = braintellRegionMatrix(:, 1);
    allRegions = union(mouseLightRegion, braintellRegion);
    countMatrixRegion = zeros(length(allRegions), 3);
    
    for r = 1:length(allRegions)
       reg = allRegions(r);
       idx = find(ismember(reg, mouseLightRegion));
       if(isempty(idx))
           countMatrixRegion(r, 1) = 0;   
       else
           for r2  = 1:length(mouseLightRegion.')
                if(strcmp(mouseLightRegion(r2), reg))
                    temp = mouseLightRegionMatrix(r2, :);
                    indices = find(~cellfun(@isempty,temp));
                    count = indices(length(indices))-1;
                    countMatrixRegion(r, 1) = count;
                end
           end
       end
       idx = find(ismember(reg, braintellRegion));
       if(isempty(idx))
           countMatrixRegion(r, 2) = 0;           
       else
           for r2  = 1:length(braintellRegion.')
                if(strcmp(braintellRegion(r2), reg))
                    temp = braintellRegionMatrix(r2, :);
                    indices = find(~cellfun(@isempty,temp));
                    count = indices(length(indices))-1;
                    countMatrixRegion(r, 2) = count;
                end
           end
       end       
    end
    
    for i = 1:length(countMatrixRegion)
        countMatrixRegion(i, 3) = countMatrixRegion(i, 1)+countMatrixRegion(i, 2); 
    end       
    
    fileName1 = sprintf('./output/summary_counts_region%s.csv', datestr(now, 'yyyymmddHHMMSS'));
    fileName2 = sprintf('./output/summary_counts_parcel%s.txt', datestr(now, 'yyyymmddHHMMSS'));
    
    fid1 = fopen(fileName1, 'w');
    fid2 = fopen(fileName2, 'w');
    
    fprintf(fid1, '%s,', 'Region');
    fprintf(fid1, '%s,', 'MouseLight Counts');
    fprintf(fid1, '%s,', 'Braintell Counts');
    fprintf(fid1, '%s,', 'Sum');
    fprintf(fid1, '%s,', 'Gain%');
    fprintf(fid1, '\n');
    for row = 1:length(allRegions)
        if~(countMatrixRegion(row, 3)==0) 
            fprintf(fid1, '%s,', cell2mat(allRegions(row)));
            for col = 1:3
                fprintf(fid1, '%d,', countMatrixRegion(row, col));
            end % col            
            if(countMatrixRegion(row, 1) > countMatrixRegion(row, 2))
                gain = (countMatrixRegion(row, 2)/countMatrixRegion(row, 1))*100;
            else
                gain = (countMatrixRegion(row, 1)/countMatrixRegion(row, 2))*100;
            end
            fprintf(fid1, '%d,', gain);
            fprintf(fid1, '\n'); 
        end       
    end % row
    fclose(fid1);
    
    fprintf(fid2, '%s;', 'Parcel');
    fprintf(fid2, '%s;', 'MouseLight Counts');
    fprintf(fid2, '%s;', 'Braintell Counts');
    fprintf(fid2, '%s;', 'Sum');
    fprintf(fid2, '%s;', 'Gain%');
    fprintf(fid2, '\n');
    for row = 1:length(allParcels)
        if~(countMatrixParcel(row, 3)==0) 
            fprintf(fid2, '%s;', cell2mat(allParcels(row)));
            for col = 1:3
                fprintf(fid2, '%d;', countMatrixParcel(row, col));
            end % col
            if(countMatrixParcel(row, 1) > countMatrixParcel(row, 2))
                gain = (countMatrixParcel(row, 2)/countMatrixParcel(row, 1))*100;
            else
                gain = (countMatrixParcel(row, 1)/countMatrixParcel(row, 2))*100;
            end
            fprintf(fid2, '%d;', gain);
            fprintf(fid2, '\n'); 
        end        
    end % row
    fclose(fid2);
       
    
end