function idClusters = save_clusters(clusters, region)
    
    strng = sprintf('\nSaving neuron clusters ...\n');
    disp(strng);
    
    fileName = sprintf('./output/%s_localClusters_%s.csv', region, datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    [nRows, nCols] = size(clusters);
    idClusters = strings(nRows, nCols);
    for row = 1:nRows
        clusterArray = clusters(row, :);
        clusterArray = nonzeros(clusterArray);
        clusterArray = clusterArray.';
        for i = 1:length(clusterArray)
            fprintf(fid, '%d', clusterArray(i));
            if (i < length(clusterArray))
                fprintf(fid, ',');
            end
        end 
        fprintf(fid, '\n');
        fprintf(fid, '\n');
    end % col
    fclose(fid);

end % save_clusters()