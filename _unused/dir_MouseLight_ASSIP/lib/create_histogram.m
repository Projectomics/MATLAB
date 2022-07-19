function create_histogram(input, region)
    %differences = cell2mat({1,2,2,3,3,3,4});  
    differences = cell2mat(input);
    maximum = max(differences)+1;
    temp = [0:1:maximum];
    histogram(differences, temp);
    xlabel('Number of Pathway Differences');
    ylabel('Number of Neuron Pairs');
    hold on;
    str = strcat('./output/', region, '_histogram.fig');
    saveas(gcf, str);
    
end
    
    
    