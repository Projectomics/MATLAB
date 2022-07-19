function save_sorted_parcels(groupings)
    fileNameRaw = sprintf('./output/sortedParcels_%s.txt', ...
        datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fileNameRaw, 'w');
    
    for row = 1:length(groupings.brainRegions)
        fprintf(fid, '%s', cell2mat(groupings.brainRegions(row)));
        for col = 1:length(groupings.neurons)
            fprintf(fid, ';%s', groupings.neurons(row, col));
        end % col
        fprintf(fid, '\n');
    end
    
    fclose('all');
end