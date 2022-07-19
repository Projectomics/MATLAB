function finalFormat = non_neg_least_squares()
% formats matrix-original so that it can be normalized

    addpath('./lib/');
    
    clusters = ["A28", "B29", "C5", "D15", "E8", "F8"];
    finalFormat = generate_spreadsheet();
    [rows, cols] = size(finalFormat);
    for c = 2:(length(clusters)+1)
        [finalMatrix, num] = neurons_per_cluster(clusters(c-1));
        sumFinal = save_sum_clusters(finalMatrix, num);
        column = 1;
        
        for r = 2:rows
            finalFormat{r, c} = sumFinal(1, column);
            column = column + 1;
        end % r

    end % c

end % non_neg_least_squares()