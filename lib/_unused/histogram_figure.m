function histogram_figure()
    addpath('../output/');
    addpath('../../dir_MouseLight_ASSIP/');
    addpath('../../dir_shuffle_ASSIP/');
    
    aStdev = 300;
    aMean = 50;
    setA = aStdev.*randn(600,1) + aMean;
    %for i = 1:600
       %setA(i) = round(normrnd(aMean,aStdev)); 
    %end    
    
    bStdev = 300;
    bMean = 500;
    setB = bStdev.*randn(600, 1) + bMean;
    %for i = 1:600
       %setB(i) = round(normrnd(bMean,bStdev)); 
    %end 
    
    for n = 1:1200
       if(n <= 600)
            combinedSetDiv{n} = [setA(n), 1];
       else
            combinedSetDiv{n} = [setB(n-600), 2];
       end
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
    setC = cStdev.*randn(1200, 1) + cMean;
    %for i = 1:1200
    %    setC(i) = round(normrnd(cMean,cStdev)); 
    %end  
    
    c = 0;
    sameIndex = 0;
    diffIndex = 0;
    for i = 1:1200
        for ii = i+1:1200
            c = c+1;
            combinedDistributions(c) = round(combinedSet(i) - combinedSet(ii));
            combinedDistributions2(c) = round(combinedSetDiv{i}(1) - combinedSetDiv{ii}(1));
            singleDistribution(c) = round(setC(i) - setC(ii));
            if(combinedSetDiv{i}(2) == combinedSetDiv{ii}(2))
                sameIndex = sameIndex+1;
                sameClass(sameIndex) = combinedDistributions2(c);
            else
                diffIndex = diffIndex+1;
                diffClass(diffIndex) = combinedDistributions2(c);
            end
        end
    end 
       
    %figure_scaled_histogram(combinedSet, setC);
    histogram(combinedDistributions2, 'FaceColor', 'none', 'EdgeColor', 'r');
    hold on;
    %histogram(sameClass, 'FaceColor', 'b', 'EdgeColor', 'none');
    %histogram(sameClass, 'DisplayStyle', 'stairs', 'EdgeColor', 'b', 'Linewidth', 2);
    %hold on;
    %histogram(diffClass, 'DisplayStyle', 'stairs', 'EdgeColor', 'r', 'Linewidth', 2);
    
    histogram(singleDistribution, 'DisplayStyle', 'stairs', 'EdgeColor', 'm');
    
    str = '../output/histogramF.fig';
    saveas(gcf, str);

end