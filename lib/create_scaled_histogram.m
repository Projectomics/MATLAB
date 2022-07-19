function [p, stats] = create_scaled_histogram(binInput, randInput, region)
    
    % find the maximum bin for the histogram from the data
    binDifferences = cell2mat(binInput);
    tempDifferences = cell2mat(randInput);
    
    binDifferencesMax = max(binDifferences);
    tempDifferencesMax = max(tempDifferences);

    % create an array for the edges of the histogram bins
    % first find the unique value in the data
    binDifferencesUnique = unique(binDifferences);
    tempDifferencesUnique = unique(tempDifferences);

    % second create an array of edges values
    binDifferencesEdges = [0:binDifferencesUnique(end)+1];
    tempDifferencesEdges = [0:tempDifferencesUnique(end)+1];

    % tally up the frequencies of the values in the data set
    nBinDifferences = zeros(1, binDifferencesMax+1);
    for i=1:length(binDifferences)
       nBinDifferences(binDifferences(i)+1) = nBinDifferences(binDifferences(i)+1)+1; 
    end
    nTempDifferences = zeros(1, tempDifferencesMax+1);
    for i=1:length(tempDifferences)
       nTempDifferences(tempDifferences(i)+1) = nTempDifferences(tempDifferences(i)+1)+1; 
    end

    % find the maximum frequency
    nBinDifferencesMax = max(nBinDifferences);
    nTempDifferencesMax = max(nTempDifferences);

    % scale the random data frequencies to the real data set maximum frequency
    nRandDifferences = nBinDifferencesMax * nTempDifferences / nTempDifferencesMax;

    clf;

    histogram('BinEdges', binDifferencesEdges, 'BinCounts', nBinDifferences);
    titleStr = sprintf('Number of Pathway Differences Between Neuron Pairs: real variance = %.2f; rand variance = %.2f', var(binDifferences), var(tempDifferences));
    title(titleStr);
    xlabel('Angle Between Neuron Pairs');
    ylabel('Number of Neuron Pairs');
    hold on;
    histogram('BinEdges', tempDifferencesEdges, 'BinCounts', nRandDifferences);
    hold on;
    line([mean(binDifferences), mean(binDifferences)], [nBinDifferencesMax+2 nBinDifferencesMax+2], 'LineWidth', 1, 'Color', 'none');
    line([mean(binDifferences), mean(binDifferences)], [nBinDifferencesMax nBinDifferencesMax], 'LineWidth', 1, 'Color', 'none');
    
    num = ((mean(binDifferences) + mean(tempDifferences)))/2;
    num = num-1;

    if(var(tempDifferences) > var(binDifferences))
        legendStr = 'NS';
        p = 'NA';
        stats = 'NA';
    else
        matrix = [binDifferences(:), tempDifferences(:)];
        [p, stats] = vartestn(matrix,'TestType','LeveneAbsolute','Display','off');

        if (p <= 0.001)
            str = {'***'};
            legendStr = 'p <= 0.001';
            num = num-1;
        elseif (0.01 >= p & p > 0.001)
            str = {'**'};
            legendStr = '0.01 >= p >0.001';
            num = num-1;
        elseif (0.05 >= p & p > 0.01)
            str = {'*'};
            legendStr = '0.05 >= p > 0.01';
        else
            str = {'ns'};
            legendStr = 'p > 0.05';
            num = num+0.5;
        end 
    end   
    
    pValueStr = sprintf('p = %e', p);

    hold off;
    legend('Real Data', 'Randomized Data', legendStr, pValueStr, 'Location', 'northwest');
    
    str = strcat('./output/', region, '_histogram_', datestr(now, 'yyyymmddHHMMSS'), '.fig');
    saveas(gcf, str);

    return;
    
end % create_scaled_histogram()    