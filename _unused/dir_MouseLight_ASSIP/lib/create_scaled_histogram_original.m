function create_scaled_histogram()
    binDifferences = cell2mat({1,2,2,3,3,3,4}); 
    tempDifferences = cell2mat({1, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4});
    
    %binDifferences = cell2mat(binInput);
    %tempDifferences = cell2mat(randInput);
    binMaxFrequency = 3;
    tempMaxFrequency = 8;
    for i = 1:length(tempDifferences)
       randDifferences(i) = (binMaxFrequency * tempDifferences(i)) / tempMaxFrequency;
    end 
    binMaxBins = max(binDifferences)+1
    randMaxBins = max(randDifferences)+1;
    binTemp = [0:1:binMaxBins];
    randTemp = [0:1:randMaxBins];
    histogram(binDifferences, binTemp);
    xlabel('Number of Pathway Differences');
    ylabel('Number of Neuron Pairs');
    hold on;
    histogram(randDifferences, randTemp);
    %str = strcat('./output/', region, '_histogram.fig');
    %saveas(gcf, str);
    
end
    
    
    