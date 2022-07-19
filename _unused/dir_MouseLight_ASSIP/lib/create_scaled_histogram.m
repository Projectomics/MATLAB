function [p, stats] = create_scaled_histogram(binInput, randInput, region)
    
    % find the maximum bin for the histogram from the data
    binDifferences = cell2mat(binInput);
    tempDifferences = cell2mat(randInput);
    %binCoVar = std(binDifferences)/mean(binDifferences);
    %randCoVar = std(tempDifferences)/mean(tempDifferences);
    %coVarMatrix = [binCoVar, randCoVar];    
    
    binDifferencesMax = max(binDifferences);
    tempDifferencesMax = max(tempDifferences);

    % create an array for the edges of the histogram bins
    % first find the unique value in the data
    binDifferencesUnique = unique(binDifferences);
    tempDifferencesUnique = unique(tempDifferences);
    % second create an array of edges values
    binDifferencesEdges = [0:binDifferencesUnique(end)+1];
    %binDifferencesEdges = [binDifferencesUnique(1):binDifferencesUnique(end) (binDifferencesMax+1)];
    tempDifferencesEdges = [0:tempDifferencesUnique(end)+1];
    %tempDifferencesEdges = [tempDifferencesUnique(1):tempDifferencesUnique(end) (tempDifferencesMax)];

    % tally up the frequencies of the values in the data set
    %nBinDifferences = histcounts(binDifferences, binDifferencesMax);
    nBinDifferences = zeros(1, binDifferencesMax+1);
    for i=1:length(binDifferences)
       nBinDifferences(binDifferences(i)+1) = nBinDifferences(binDifferences(i)+1)+1; 
    end
    nTempDifferences = zeros(1, tempDifferencesMax+1);
    for i=1:length(tempDifferences)
       nTempDifferences(tempDifferences(i)+1) = nTempDifferences(tempDifferences(i)+1)+1; 
    end
    %nTempDifferences = histcounts(tempDifferences, tempDifferencesMax);
    %nTempDifferences = histcounts(tempDifferences, binDifferencesMax);

    % find the maximum frequency
    nBinDifferencesMax = max(nBinDifferences);
    nTempDifferencesMax = max(nTempDifferences);

    % scale the random data frequencies to the real data set maximum frequency
    nRandDifferences = nBinDifferencesMax * nTempDifferences / nTempDifferencesMax;

    clf;

    histogram('BinEdges', binDifferencesEdges, 'BinCounts', nBinDifferences);
    title('Number of Pathway Differences Between Neuron Pairs');
    %xlabel('Number of Pathway Differences');
    xlabel('Angle Between Neuron Pairs');
    ylabel('Number of Neuron Pairs');
    hold on;
    histogram('BinEdges', tempDifferencesEdges, 'BinCounts', nRandDifferences);
    hold on;
    %ylim([0, nBinDifferencesMax+100]);
    line([mean(binDifferences), mean(binDifferences)], [nBinDifferencesMax+2 nBinDifferencesMax+2], 'LineWidth', 1, 'Color', 'none');
    line([mean(binDifferences), mean(binDifferences)], [nBinDifferencesMax nBinDifferencesMax], 'LineWidth', 1, 'Color', 'none');
    
    num = ((mean(binDifferences) + mean(tempDifferences)))/2;
    num = num-1;
    %[h, p, ci, stats] = vartest2(binDifferences, tempDifferences, 'Tail', 'right');
    disp(var(binDifferences));
    disp(var(tempDifferences));
    if(var(tempDifferences) > var(binDifferences))
        legendStr = 'NS';
        p = 'NA';
        stats = 'NA';
    else
        matrix = [binDifferences(:), tempDifferences(:)];
        [p, stats] = vartestn(matrix,'TestType','LeveneAbsolute','Display','off')
        %p = p * 14;
        disp(p);

        if(p <= 0.001)
            str = {'***'};
            legendStr = 'p <= 0.001';
            num = num-1;
        elseif(0.01 >= p & p > 0.001)
            str = {'**'};
            legendStr = '0.01 >= p >0.001';
            num = num-1;
        elseif(0.05 >= p & p > 0.01)
            str = {'*'};
            legendStr = '0.05 >= p > 0.01';
        else
            str = {'ns'};
            legendStr = 'p > 0.05';
            num = num+0.5;
            disp(p);
        end 
    end   
    
    pValueStr = sprintf('p = %e', p);

    hold off;
    legend('Real Data', 'Randomized Data', legendStr, pValueStr);
    
    str = strcat('./output/', region, '_histogram.fig');
    saveas(gcf, str);

    return;
    
end
    
    
    