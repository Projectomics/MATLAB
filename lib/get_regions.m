function get_regions(fileName, threshold)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    %clear all;
    
    %fileName = 'sortedNeurons_20200705163851_axons.csv';
        
    strng = sprintf('\nLoading sorted neurons from data file ...\n');
    disp(strng);
    
    fileNameFull = sprintf('./output/%s', fileName);
    fid = fopen(fileNameFull, 'r');
    headerStr = fgetl(fid);
    nCols = length(strfind(headerStr, ','));
    %nCols = 5000;
    frewind(fid);
    dataStr = textscan(fid, '%s', 'Delimiter', ',');
    nRows = length(dataStr{1,1}) / nCols
    fclose(fid);
    
    for i = 1:nRows
        sortedNeurons(i, 1:nCols) = dataStr{1,1}(nCols*(i-1)+1:nCols*i);
    end    
    
    regions = {};
    regionIndex = 1;
    for i = 1:nRows
        count = 0;
        for j = 2:nCols
            if(strcmpi(sortedNeurons(i,j), ''))
                %regionNeurons = [];
                break; 
            else
                count = count+1;
            end
        end
        if(count>=threshold)
            regions(regionIndex) = sortedNeurons(i, 1);
            regionIndex = regionIndex + 1;
        end
    end
    
    fileName = sprintf('./output/getRegionsThresh%d_%s.csv', threshold, ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    fprintf(fid, 'Regions Surpassing Threshold %d', threshold);
    for i = 1:length(regions)
        fprintf(fid, '\n');
        fprintf(fid, '%s', cell2mat(regions(i)));
    end % col
    fclose(fid);       
end