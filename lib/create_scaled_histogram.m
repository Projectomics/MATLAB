function create_scaled_histogram(origInput, randInput, regionStr, nowDateStr)
% Function to create histograms from the original and randomized sets of
% angle data in which the maximum of the histogram of the randomized data
% is scaled to equal to that of the original data and to conduct Levene's
% statistical comparison of variances on the two distributions of angle data 
    
    fprintf('\nConstructing histogram ...\n');
    
    % Extract angles from the cell arrays and find their maximum values
    origAngles = cell2mat(origInput);
    randAngles = cell2mat(randInput);
    
    origAnglesMax = max(origAngles);
    randAnglesMax = max(randAngles);

    % Find unique values in the angles and create edges for the histogram bins
    origAnglesUnique = unique(origAngles);
    randAnglesUnique = unique(randAngles);

    origAnglesEdges = 0:origAnglesUnique(end)+1;
    randAnglesEdges = 0:randAnglesUnique(end)+1;

    % Calculate the frequencies of the angles
    nOrigAngles = zeros(1, origAnglesMax+1);
    for i=1:length(origAngles)
       nOrigAngles(origAngles(i)+1) = nOrigAngles(origAngles(i)+1)+1; 
    end
    nRandAngles = zeros(1, randAnglesMax+1);
    for i=1:length(randAngles)
       nRandAngles(randAngles(i)+1) = nRandAngles(randAngles(i)+1)+1; 
    end

    % Find the maximum frequencies
    nOrigAnglesMax = max(nOrigAngles);
    nRandAnglesMax = max(nRandAngles);

    % Scale the random data frequencies to match the real dataset maximum frequency
    nRandAngles = nOrigAnglesMax * nRandAngles / nRandAnglesMax;

    clf;

    % Create and customize the histograms
    histogram('BinEdges', origAnglesEdges, 'BinCounts', nOrigAngles);
    titleStr = sprintf('Number of Pathway Angles Between Neuron Pairs: real variance = %.2f; rand variance = %.2f', var(origAngles), var(randAngles));
    title(titleStr);
    xlabel('Angle Between Neuron Pairs');
    ylabel('Number of Neuron Pairs');
    hold on;
    histogram('BinEdges', randAnglesEdges, 'BinCounts', nRandAngles);
    hold on;
    line([mean(origAngles), mean(origAngles)], [nOrigAnglesMax+2 nOrigAnglesMax+2], 'LineWidth', 1, 'Color', 'none');
    line([mean(origAngles), mean(origAngles)], [nOrigAnglesMax nOrigAnglesMax], 'LineWidth', 1, 'Color', 'none');
    
    % Check if the variance of the randomized angle data is greater
    % than that of the original angle data
    if (var(randAngles) > var(origAngles))
        legendStr = 'NS'; % Not Significant
        p = 'NA'; % Not Applicable
        statistics = 'NA'; % Not Applicable
    else
        % Conduct Levene's statistical comparison of variances when the
        % variance of the randomized angle data is less than that of the
        % original angle data
        matrix = [origAngles(:), randAngles(:)];
        [p, statistics] = vartestn(matrix, 'TestType', 'LeveneAbsolute', 'Display', 'off');

        % Perform legend handling
        if (p <= 0.001)
            str = {'***'};
            legendStr = 'p <= 0.001';
        elseif (0.01 >= p && p > 0.001)
            str = {'**'};
            legendStr = '0.01 >= p > 0.001';
        elseif (0.05 >= p && p > 0.01)
            str = {'*'};
            legendStr = '0.05 >= p > 0.01';
        else
            str = {'ns'};
            legendStr = 'p > 0.05';
        end 
    end   
    
    pValueStr = sprintf('p = %e', p);

    hold off;
    legend('Original Data', 'Randomized Data', legendStr, pValueStr, 'Location', 'northwest');
    
    % Save the figures and results
    str = sprintf('./output/%s__histogram_%s.fig', regionStr, nowDateStr);
    saveas(gcf, str);

    pngPlotFileName = sprintf('./output/%s__histogram_%s.png', regionStr, nowDateStr);
    print(gcf, '-dpng', '-r800', pngPlotFileName);

    pValueFileName = sprintf('./output/%s__histogram__Levene_p_value_%s.xlsx', regionStr, nowDateStr);
    writematrix(p, pValueFileName);

    statisticsFileName = sprintf('./output/%s__histogram__Levene_statistics_%s.xlsx', regionStr, nowDateStr);
    writestruct(statistics, statisticsFileName);

end % create_scaled_histogram()