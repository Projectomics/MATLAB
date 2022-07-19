function morphologyMatrix = save_axon_summaries(morphologyMatrix)
   
    fileNameRaw = sprintf('./output/rawCounts_%s.txt', ...
        datestr(now, 'yyyymmddHHMMSS'));    
    fileNameBin = sprintf('./output/axonParcelInvasions_%s.txt', ...
        datestr(now, 'yyyymmddHHMMSS')); 
    
    fid1 = fopen(fileNameRaw, 'w'); % raw counts of points per parcel
    fid2 = fopen(fileNameBin, 'w'); 
    
    fprintf(fid1, ';Location of Soma');
    fprintf(fid2, ';Location of Soma');
    for col = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%s', cell2mat(morphologyMatrix.parcels(col)));
        fprintf(fid2, ';%s', cell2mat(morphologyMatrix.parcels(col)));
    end % col
    fprintf(fid2, ';Number of Regions Axon Invades');
    fprintf(fid1, '\n');
    fprintf(fid2, '\n');
    
    morphologyMatrix.totalRegionsInvaded = zeros(1, length(morphologyMatrix.neuronTypes));
    
    for row = 1:morphologyMatrix.nRows    
        % raw counts of points per parcel
        fprintf(fid1, '%s', cell2mat(morphologyMatrix.neuronTypes(row)));
        fprintf(fid1, ';%s', cell2mat(morphologyMatrix.matchedSomaLocations(row)));
        fprintf(fid2, '%s', cell2mat(morphologyMatrix.neuronTypes(row)));
        fprintf(fid2, ';%s', cell2mat(morphologyMatrix.matchedSomaLocations(row)));
        
        for col = 1:morphologyMatrix.nCols
            fprintf(fid1, ';%d', morphologyMatrix.axonCounts(row, col));
            if(morphologyMatrix.axonCounts(row, col) > 0)
                morphologyMatrix.axonParcelInvasions(row, col) = 1;
            else
                morphologyMatrix.axonParcelInvasions(row, col) = 0;
            end
            fprintf(fid2, ';%d', morphologyMatrix.axonParcelInvasions(row, col));
        end % col
        totalRegions = sum(morphologyMatrix.axonParcelInvasions(row, :));
        morphologyMatrix.totalRegionsInvaded(row) = totalRegions;
        fprintf(fid2, ';%d', totalRegions);
        fprintf(fid1, '\n');
        fprintf(fid2, '\n');
        
    end % row
    
    totalAxonData = sum(morphologyMatrix.axonCounts);
    fprintf(fid1, 'Total Axonal Data Points');
    fprintf(fid1, ';-');
    for i = 1:morphologyMatrix.nCols  
       fprintf(fid1, ';%d', totalAxonData(i)); 
    end  
    
    fprintf(fid1, '\n');
    totalAxons = sum(morphologyMatrix.axonParcelInvasions);
    fprintf(fid1, 'Total Axons Invading');
    fprintf(fid1, ';-');
    for i = 1:morphologyMatrix.nCols  
       fprintf(fid1, ';%d', totalAxons(i)); 
    end 
    
    fprintf(fid1, '\n');
    totalSoma = sum(morphologyMatrix.somaCounts);
    fprintf(fid1, 'Total Somata');
    fprintf(fid1, ';-');
    for i = 1:morphologyMatrix.nCols  
       fprintf(fid1, ';%d', totalSoma(i)); 
    end 
    
    fclose(fid1);
    fclose(fid2);
    
end % save_morphology_matrix()
