function save_summary_matrix(morphologyMatrix)
   
    fileNameRaw = sprintf('./output/summary_%s.txt', ...
        datestr(now, 'yyyymmddHHMMSS'));    
    
    fid1 = fopen(fileNameRaw, 'w'); % raw counts of points per parcel
    
    for col = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%s', cell2mat(morphologyMatrix.parcels(col)));
    end % col
    fprintf(fid1, '\n');
    
    fprintf(fid1, 'Total Somata in Parcel');
    totalSomata = sum(morphologyMatrix.somaCounts);
    for i = 1:morphologyMatrix.nCols  
       fprintf(fid1, ';%d', totalSomata(i)); 
    end     
    fprintf(fid1, '\n');
    
    fprintf(fid1, 'Total Regions Invaded by Axons of Neurons in Parcel');
    for i = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%d', morphologyMatrix.numAxonInvasions(i));
    end
    fprintf(fid1, '\n');
    
    fprintf(fid1, 'Max Regions Invaded by Axons of Neurons in Parcel');
    for i = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%d', morphologyMatrix.maxAxonInvasions(i));
    end
    fprintf(fid1, '\n'); 
    
    fprintf(fid1, 'Min Regions Invaded by Axons of Neurons in Parcel');
    for i = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%d', morphologyMatrix.minAxonInvasions(i));
    end
    fprintf(fid1, '\n'); 
    
    fprintf(fid1, 'Mean Regions Invaded by Axons of Neurons in Parcel');
    for i = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%d', morphologyMatrix.meanAxonInvasions(i));
    end
    fprintf(fid1, '\n');  
    
    fprintf(fid1, 'St. Dev Regions Invaded by Axons of Neurons in Parcel');
    for i = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%d', morphologyMatrix.stdAxonInvasions(i));
    end
            
    fclose(fid1);
    
end 
