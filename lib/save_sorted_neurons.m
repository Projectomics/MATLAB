function save_sorted_neurons(groupings)
    fileNameRaw = sprintf('./output/sortedNeurons_%s_axons.csv', ...
        datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fileNameRaw, 'w');
    
    for row = 1:length(groupings.brainRegions)
        fprintf(fid, '%s', cell2mat(groupings.brainRegions(row)));
        for col = 1:length(groupings.neurons)
            fprintf(fid, ',%s', groupings.neurons(row, col));
        end % col
        fprintf(fid, '\n');
    end
    
    fclose(fid);
end