function figure_scaled_histogram(binDifferences, tempDifferences)  
    
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

    % find the maximum frequency
    nBinDifferencesMax = max(nBinDifferences);
    nTempDifferencesMax = max(nTempDifferences);

    % scale the random data frequencies to the real data set maximum frequency
    nRandDifferences = nBinDifferencesMax * nTempDifferences / nTempDifferencesMax;

    clf;

    histogram('BinEdges', binDifferencesEdges, 'BinCounts', nBinDifferences);
    hold on;
    histogram('BinEdges', tempDifferencesEdges, 'BinCounts', nRandDifferences);
    
    %str = strcat('./output/figure');
    %saveas(gcf, str);

    return;
    
end
    
    
    