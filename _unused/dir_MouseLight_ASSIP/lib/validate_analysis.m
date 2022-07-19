function [distances, doublesData] = validate_analysis(data, dataName)
    
    nRows = size(data, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            difference = abs(data(i) - data(ii));
            c = c+1;
            doublesData(c, :) = [i ii difference];
        end % ii
    end % i
       
    nDoublesRows = size(doublesData, 1);
    distances = {};
    distIndex = 1;
    
    fullFileName = sprintf('./output/%s_differences_%s.csv', dataName, datestr(now, 'yyyymmddHHMMSS'));
    fid = fopen(fullFileName, 'w');
    for i = 1:nDoublesRows
        fprintf(fid, '%d,%d,%d\n', doublesData(i, 1), doublesData(i, 2), doublesData(i, 3));
        distances{distIndex} = doublesData(i, 3);
        distIndex=distIndex+1;
    end % i
    fclose(fid)
    
    %fullFileName = sprintf('./output/%s_dataset_%s.csv', dataName, datestr(now, 'yyyymmddHHMMSS'));
    %fid = fopen(fullFileName, 'w');
    %for i = 1:nRows
    %    fprintf(fid, '%d\n', data);
    %end % i
    %fclose(fid)

end % combine_doubles()