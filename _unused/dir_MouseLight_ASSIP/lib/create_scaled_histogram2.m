function create_scaled_histogram()
    binDifferences = cell2mat({1,2,2,3,3,3,4}); 
    randDifferences = cell2mat({1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4});
    
    %binDifferences = cell2mat(binInput);
    %tempDifferences = cell2mat(randInput);
    binMax = max(binDifferences);
    for i = 1:length(binDifferences)
        scaledBinDifferences(i) = binDifferences(i)/binMax;
    end
    randMax = max(randDifferences);
    for i = 1:length(randDifferences)
       scaledRandDifferences(i) = randDifferences(i)/randMax; 
    end    
    
    binMaxBins = max(scaledBinDifferences)+1;
    randMaxBins = max(scaledRandDifferences)+1;
    binTemp = [0:1:binMaxBins];
    randTemp = [0:1:randMaxBins];
    histogram(scaledBinDifferences, binTemp);
    xlabel('Number of Pathway Differences');
    ylabel('Number of Neuron Pairs');
    hold on;
    histogram(scaledRandDifferences, randTemp);
    %str = strcat('./output/', region, '_histogram.fig');
    %saveas(gcf, str);
    
end
    
    
    