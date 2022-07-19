function histogram_figure2()
    addpath('../output/');
    addpath('../../dir_MouseLight_ASSIP/');
    addpath('../../dir_shuffle_ASSIP/');
    
    aStdev = 600;
    aMean = 50;
    %setA = aStdev.*randn(600,1) + aMean;
    for i = 1:600
       setA(i) = round(normrnd(aMean,aStdev)); 
    end    
    
    bStdev = 600;
    bMean = 150;
    %setB = bStdev.*randn(600, 1) + bMean;
    for i = 1:600
       setB(i) = round(normrnd(bMean,bStdev)); 
    end  
    
    for n = 1:1200
       if(n <= 600)
            combinedSet(n) = setA(n);
       else
            combinedSet(n) = setB(n-600);
       end
    end
    
    cMean = mean(combinedSet);
    cStdev = std(combinedSet/2);    
    %setC = cStdev.*randn(1040, 1) + cMean;
    for i = 1:2100
        setC(i) = round(normrnd(cMean,cStdev)); 
    end  
    
    c = 0;
    for i = 1:2100
        for ii = i+1:2100
            c = c+1;
            singleDistribution(c) = round(setC(i) - setC(ii));
        end
    end 
    
    c = 0;
    for i = 1:1200
        for ii = i+1:1200
            c = c+1;
            combinedDistributions(c) = round(combinedSet(i) - combinedSet(ii));
            %singleDistribution(c) = round(setC(i) - setC(ii));
        end
    end 
   
    
    %figure_scaled_histogram(combinedSet, setC);
    mask = combinedDistributions < 0;  
    histogram(combinedDistributions, 'FaceColor', 'r', 'EdgeColor', 'r');
    hold on;
    histogram(combinedDistributions(~mask), 'FaceColor','b', 'EdgeColor', 'b');  
    hold on;
    %histogram(singleDistribution, 'DisplayStyle', 'stairs', 'EdgeColor', 'm', 'Linewidth', 4);
    histogram(singleDistribution, 'FaceColor', 'm', 'EdgeColor', 'm');
    
    str = '../output/histogram6.fig';
    saveas(gcf, str);

end