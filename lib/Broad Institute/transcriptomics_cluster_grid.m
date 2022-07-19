function transcriptomics_cluster_grid()
    %broadFile = '../output/broad_DG_clusters - Copy.csv';
    %broadFile = 'broad_DG_clusters - Copy.csv';
    broadFile = 'broad_official_localClusters_20211104112809 - Copy.csv';
    broadClusters = readmatrix(broadFile);
    [broadRow, broadCol] = size(broadClusters);

    %ourFile = '../output/DG_localClusters_20211008095326 - Copy.csv';
    %ourFile = 'DG_localClusters_20211008095326 - Copy.csv';
    ourFile = 'broad_localClusters_20211102160337 - Copy.csv';
    ourClusters = readmatrix(ourFile);
    [ourRow, ourCol] = size(ourClusters);
    
    nNeurons = nnz(~isnan(ourClusters));
    
    data = zeros(broadRow, ourRow);
    percentData = zeros(broadRow, ourRow);
    for i = 1:nNeurons
       [bRowTemp, bColTemp] = find(broadClusters==i);
       [oRowTemp, oColTemp] = find(ourClusters==i);
       data(bRowTemp, oRowTemp) = data(bRowTemp, oRowTemp)+1;
    end
    
    sumArray = sum(data);
    for r = 1:broadRow
        for c = 1:ourRow
           percentData(r, c) = (data(r, c) / sumArray(c))*100; 
        end
    end
    
%     orderedPercentData = zeros(broadRow, ourRow);
%     orderedPercentData(:, 1) = percentData(:, 10);
%     orderedPercentData(:, 2) = percentData(:, 9);
%     orderedPercentData(:, 3) = percentData(:, 6);
%     orderedPercentData(:, 4) = percentData(:, 2);
%     orderedPercentData(:, 5) = percentData(:, 4);
%     orderedPercentData(:, 6) = percentData(:, 1);
%     orderedPercentData(:, 7) = percentData(:, 3);
%     orderedPercentData(:, 8) = percentData(:, 7);
%     orderedPercentData(:, 9) = percentData(:, 5);
%     orderedPercentData(:, 10) = percentData(:, 8);

    orderedPercentData = zeros(broadRow, ourRow);
    orderedPercentData(1, :) = percentData(16, :); %553
    orderedPercentData(2, :) = percentData(17, :); %119
    orderedPercentData(3, :) = percentData(34, :); %113
    orderedPercentData(4, :) = percentData(30, :); %103
    orderedPercentData(5, :) = percentData(9, :); %43
    orderedPercentData(6, :) = percentData(8, :); %41
    orderedPercentData(7, :) = percentData(28, :); %33
    orderedPercentData(8, :) = percentData(2, :); %27
    orderedPercentData(9, :) = percentData(25, :); %27
    orderedPercentData(10, :) = percentData(26, :); %27
    orderedPercentData(11, :) = percentData(19, :); %25
    orderedPercentData(12, :) = percentData(27, :); %25
    orderedPercentData(13, :) = percentData(7, :); %22
    orderedPercentData(14, :) = percentData(12, :); %21
    orderedPercentData(15, :) = percentData(24, :); %18
    orderedPercentData(16, :) = percentData(33, :); %18
    orderedPercentData(17, :) = percentData(32, :); %17
    orderedPercentData(18, :) = percentData(3, :); %16
    orderedPercentData(19, :) = percentData(11, :); %16
    orderedPercentData(20, :) = percentData(1, :); %14
    orderedPercentData(21, :) = percentData(5, :); %14
    orderedPercentData(22, :) = percentData(22, :); %14
    orderedPercentData(23, :) = percentData(13, :); %13
    orderedPercentData(24, :) = percentData(4, :); %12
    orderedPercentData(25, :) = percentData(14, :); %10
    orderedPercentData(26, :) = percentData(20, :); %10
    orderedPercentData(27, :) = percentData(6, :); %9
    orderedPercentData(28, :) = percentData(21, :); %9
    orderedPercentData(29, :) = percentData(10, :); %8
    orderedPercentData(30, :) = percentData(18, :); %8
    orderedPercentData(31, :) = percentData(15, :); %6
    orderedPercentData(32, :) = percentData(31, :); %6
    orderedPercentData(33, :) = percentData(23, :); %3
    orderedPercentData(34, :) = percentData(29, :); %2

    

    % Create a 3x4 array of sample data in the range of 0-255.
    %data = randi([1, 200], 50, 50);
    % Display it.
    image(orderedPercentData);
    % Initialize a color map array of 256 colors.
    %x = max(max(percentData));
    x = 100;
    colorMap = jet(x);
    % Apply the colormap and show the colorbar
    colormap(colorMap);
    colorbar;
    %yticks([1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34])
    %yticklabels({'553' '119' '113' '103' '43' '41' '33' '27' '27' '27' '25' '25' '22' '21' '18' '18' '17' '16' '16' '14' '14' '14' '13' '12' '10' '10' '9' '9' '8' '8' '6' '6' '3' '2'});
    
    xticks([1 2])
    %xticklabels({'1380' '22'})
    %xticklabels({'A501', 'B121', 'C43', 'D4', 'E3', 'F2', 'G2', 'H2', 'I1', 'J1'})

end