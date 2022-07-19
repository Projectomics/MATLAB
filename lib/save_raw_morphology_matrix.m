function fileNameRaw = save_raw_morphology_matrix(morphologyMatrix, region)

    filePath = './output/';
    fileNameRaw = sprintf('%s_raw_morphologyMatrix_%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));   
    fullFile = strcat(filePath, fileNameRaw);
    dataFullFileName = strcat('./data/', fileNameRaw);
    
    fid = fopen(fullFile, 'w'); % raw counts of points per parcel   
    for row = 1:morphologyMatrix.nRows
    
        % raw counts of points per parcel
        for col = 1:morphologyMatrix.nCols
            fprintf(fid, '%d,', morphologyMatrix.axonCounts(row, col));
        end % col
        fprintf(fid, '\n');

    end % row
    
    fclose(fid);

    copyfile(fullFile, dataFullFileName);
    
end % save_morphology_matrix()
