function save_morphology_matrix(morphologyMatrix, region)

    %fileNameRaw = sprintf('scratch/dwheele5/ADS/morphologyMatrix_%s_rawcounts.txt', ...
    %    datestr(now, 'yyyymmddHHMMSS'));
    %fileNameSoma = sprintf('scratch/dwheele5/ADS/morphologyMatrix_%s_soma.txt', ...
    %    datestr(now, 'yyyymmddHHMMSS'));
    
    fileNameRaw = sprintf('./output/%s_morphologyMatrix_%s_rawcounts.txt', region, ...
        datestr(now, 'yyyymmddHHMMSS'));    
    fileNameSoma = sprintf('./output/%s_morphologyMatrix_%s_soma.txt', region, ...
        datestr(now, 'yyyymmddHHMMSS'));
    
    fid1 = fopen(fileNameRaw, 'w'); % raw counts of points per parcel
    fid2 = fopen(fileNameSoma, 'w'); % soma locations
    
    for col = 1:morphologyMatrix.nCols
        fprintf(fid1, ';%s', cell2mat(morphologyMatrix.parcels(col)));
        fprintf(fid2, ';%s', cell2mat(morphologyMatrix.parcels(col)));
    end % col
    fprintf(fid1, '\n');
    fprintf(fid2, '\n');
    
    for row = 1:morphologyMatrix.nRows
    
        % raw counts of points per parcel
        fprintf(fid1, '%s [A]', cell2mat(morphologyMatrix.neuronTypes(row)));
        for col = 1:morphologyMatrix.nCols
            %if (col > 1)
            fprintf(fid1, ';%d', morphologyMatrix.axonCounts(row, col));
            %else
            %    temp = sprintf(';%d', morphologyMatrix.axonCounts(row, col));
            %    disp(temp);
            %end
        end % col
        fprintf(fid1, '\n');

        fprintf(fid1, '%s [D]', cell2mat(morphologyMatrix.neuronTypes(row)));
        for col = 1:morphologyMatrix.nCols
            %if (col > 1)
            fprintf(fid1, ';%d', morphologyMatrix.dendriteCounts(row, col));
            %else
            %    temp2 = sprintf(';%d', morphologyMatrix.dendriteCounts(row, col));
            %    disp(temp2);
            %end
        end % col
        fprintf(fid1, '\n');
        
        % soma locations
        fprintf(fid2, '%s', cell2mat(morphologyMatrix.neuronTypes(row)));
        for col = 1:morphologyMatrix.nCols
            %if (col > 1)
             if (morphologyMatrix.somaCounts(row, col) >= 1)
                fprintf(fid2, ';1');
             else
                fprintf(fid2, ';0');
             end
            %end
        end % col
        fprintf(fid2, '\n');

    end % row
    
    fclose(fid1);
    fclose(fid2);
    
end % save_morphology_matrix()
