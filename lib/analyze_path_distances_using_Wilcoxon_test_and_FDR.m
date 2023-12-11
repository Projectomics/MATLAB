% Function to analyze path distances using Wilcoxon test and False Discovery Rate correction
function analyze_path_distances_using_Wilcoxon_test_and_FDR(pathDistances, headers, labelStr, nowDateStr, regionStr)

    % Calculate the number of tests based on the number of columns
    nCols = size(pathDistances, 2);
    nTests = nCols * (nCols - 1) / 2;

    % Output file name based on region, label, and date
    outputFile = sprintf('./output/%s__%s__Wilcoxon_and_FDR_%s.xlsx', regionStr, labelStr, nowDateStr);

    % Initialize variables
    c = 0;
    p = zeros(nTests, 1);

    % Loop through all pairs of columns for Wilcoxon test
    for i = 1:nCols
        for j = i + 1:nCols

            c = c + 1;

            % Check for empty columns and assign p-values accordingly
            if (isempty(pathDistances{i}) || isempty(pathDistances{j}))
                p(c) = 1;
            else
                p(c) = ranksum(pathDistances{i}, pathDistances{j});
            end

        end % j
    end % i

    % Sort p-values for False Discovery Rate (FDR) correction
    pSorted = sort(p);

    % FDR correction parameters
    pThreshold = 0;
    alpha = 0.05;

    fprintf('False Discovery Rate:\n');

    % Loop through sorted p-values and calculate FDR
    for i = 1:c
        criticalValue = (alpha * i / c);

        if (pSorted(i) < criticalValue)
            pThreshold = pSorted(i);
        end

        fprintf('%d\t%e\t%f\n', i, pSorted(i), criticalValue);

    end % i

    fprintf('p threshold = %e\n', pThreshold);

    % Loop through pairs again to calculate statistics and write to Excel file
    for i = 1:nCols
        for j = i + 1:nCols

            if (~isempty(pathDistances{i}) && ~isempty(pathDistances{j}))

                % Perform Wilcoxon test
                p = ranksum(pathDistances{i}, pathDistances{j});

                % Determine significance based on p-value and threshold
                significanceStr = 'not significant';
                if (p <= pThreshold)
                    significanceStr = 'significant';
                end

                % Create a cell array for ranksum statistics
                ranksumStatistics{1}(1, 1) = {'Statistics'};
                ranksumStatistics{1}(1, 2) = headers(i);
                ranksumStatistics{1}(1, 3) = headers(j);

                % Populate statistics in the cell array
                ranksumStatistics{1}(2, 1) = {'Median'};
                ranksumStatistics{1}(2, 2) = num2cell(quantile(pathDistances{i}, 0.5));
                ranksumStatistics{1}(2, 3) = num2cell(quantile(pathDistances{j}, 0.5));

                ranksumStatistics{1}(3, 1) = {'1st Quartile'};
                ranksumStatistics{1}(3, 2) = num2cell(quantile(pathDistances{i},0.25));
                ranksumStatistics{1}(3, 3) = num2cell(quantile(pathDistances{j},0.25));

                ranksumStatistics{1}(4, 1) = {'3rd Quartile'};
                ranksumStatistics{1}(4, 2) = num2cell(quantile(pathDistances{i},0.75));
                ranksumStatistics{1}(4, 3) = num2cell(quantile(pathDistances{j},0.75));

                ranksumStatistics{1}(5, 1) = {'Minimum'};
                ranksumStatistics{1}(5, 2) = num2cell(min(pathDistances{i}));
                ranksumStatistics{1}(5, 3) = num2cell(min(pathDistances{j}));

                ranksumStatistics{1}(6, 1) = {'Maximum'};
                ranksumStatistics{1}(6, 2) = num2cell(max(pathDistances{i}));
                ranksumStatistics{1}(6, 3) = num2cell(max(pathDistances{j}));

                ranksumStatistics{1}(7, 1) = {'N'};
                ranksumStatistics{1}(7, 2) = num2cell(sum(isfinite(pathDistances{i})));
                ranksumStatistics{1}(7, 3) = num2cell(sum(isfinite(pathDistances{j})));

                ranksumStatistics{1}(8, 1) = {'p'};
                ranksumStatistics{1}(8, 2) = num2cell(p);                

                ranksumStatistics{1}(9, 1) = {'Significance'};
                ranksumStatistics{1}(9, 2) = {significanceStr};

                ranksumStatistics{1}(10, 1) = {' '};

                % Write statistics to the Excel file
                writecell(ranksumStatistics{1}, outputFile, 'WriteMode', 'append');

            end % if ~isempty

        end % j
    end % i

    % Write the number of tests to the Excel file
    nTestsStr = sprintf('Number of Tests = %d', c);
    writecell({nTestsStr}, outputFile, 'WriteMode', 'append');

end % analyze_path_distances_using_Wilcoxon_test_and_FDR()