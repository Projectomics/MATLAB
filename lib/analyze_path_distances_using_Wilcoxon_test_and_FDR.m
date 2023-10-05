function analyze_path_distances_using_Wilcoxon_test_and_FDR(pathDistances, headers, labelStr, nowDateStr, regionStr)

    nCols = size(pathDistances, 2);
    nTests = nCols*(nCols-1)/2;

    outputFile = sprintf('./output/%s__%s__Wilcoxon_and_FDR_%s.xlsx', regionStr, labelStr, nowDateStr);

    c = 0;

    p = zeros(nTests, 1);

    for i = 1:nCols
        for j = i+1:nCols

%             p = 1;
            if (~isempty(pathDistances{i}) && ~isempty(pathDistances{j}))

                c = c + 1;
                p(c) = ranksum(pathDistances{i}, pathDistances{j});

            end

        end % j
    end % i

    pSorted = sort(p);

    pThreshold = 0;

    alpha = 0.05;

    fprintf('False Discovery Rate:\n');

    for i = 1:c

        criticalValue = (alpha * i/c);

        if (pSorted(i) < criticalValue)
            pThreshold = pSorted(i);
        end

        fprintf('%d\t%e\t%f\n', i, pSorted(i), criticalValue);

    end % i

    fprintf('p threshold = %e\n', pThreshold);

    for i = 1:nCols
        for j = i+1:nCols

            if (~isempty(pathDistances{i}) && ~isempty(pathDistances{j}))

                p = ranksum(pathDistances{i}, pathDistances{j});
    
                significanceStr = 'not significant';;
                if (p <= pThreshold)
                    significanceStr = 'significant';
                end

                ranksumStatistics{1}(1, 1) = {'Statistics'};
                ranksumStatistics{1}(1, 2) = headers(i);
                ranksumStatistics{1}(1, 3) = headers(j);

                ranksumStatistics{1}(2, 1) = {'Median'};
                ranksumStatistics{1}(2, 2) = num2cell(quantile(pathDistances{i},0.5));
                ranksumStatistics{1}(2, 3) = num2cell(quantile(pathDistances{j},0.5));

                ranksumStatistics{1}(3, 1) = {'1st Quartile'};
                ranksumStatistics{1}(3, 2) = num2cell(quantile(pathDistances{i},0.25));
                ranksumStatistics{1}(3, 3) = num2cell(quantile(pathDistances{j},0.25));

                ranksumStatistics{1}(4, 1) = {'3rd Quartile'};
                ranksumStatistics{1}(4, 2) = num2cell(quantile(pathDistances{i},0.75));
                ranksumStatistics{1}(4, 3) = num2cell(quantile(pathDistances{j},0.75));

                ranksumStatistics{1}(5, 1) = {'N'};
                ranksumStatistics{1}(5, 2) = num2cell(sum(isfinite(pathDistances{i})));
                ranksumStatistics{1}(5, 3) = num2cell(sum(isfinite(pathDistances{j})));

                ranksumStatistics{1}(6, 1) = {'p'};
                ranksumStatistics{1}(6, 2) = num2cell(p);                

                ranksumStatistics{1}(7, 1) = {'Significance'};
                ranksumStatistics{1}(7, 2) = {significanceStr};

                ranksumStatistics{1}(8, 1) = {' '};

                writecell(ranksumStatistics{1}, outputFile, 'WriteMode', 'append');

            end % if ~isempty

        end % j
    end % i

    nTestsStr = sprintf('Number of Tests = %d', c);

    writecell({nTestsStr}, outputFile, 'WriteMode', 'append');

end % analyze_path_distances_using_Wilcoxon_test_and_FDR()