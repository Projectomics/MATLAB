function idClusters = bt_save_clusters(groups, region)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    addpath('../dir_MouseLight_ASSIP/lib');
    addpath('../dir_shuffle_ASSIP/lib');
    
    strng = sprintf('\nSaving neuron clusters ...\n');
    disp(strng);
    
    fileName = sprintf('./output/%s_localClusters_%s.csv', region, ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    [nRows, nCols] = size(groups);
    idClusters = strings(nRows, nCols);
    for r = 1:nRows
        clusterArray = groups(r, :);
        clusterArray = nonzeros(clusterArray);
        clusterArray = clusterArray.';
        for i = 1:length(clusterArray)
            fprintf(fid, '%d,', clusterArray(i));
        end 
        fprintf(fid, '\n');
        fprintf(fid, '\n');
    end % col
    fclose(fid);
end