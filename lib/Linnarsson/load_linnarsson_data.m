function load_linnarsson_data()
    addpath('../output/');
    matrix = readmatrix('expression_mRNA_17-Aug-2014.csv'); 
    matrix = matrix.';
    [rawRow, rawCol] = size(matrix);
        
    s = sum(matrix);
    new = s>=25;
    newCol = sum(new);
    filteredMatrix = zeros(rawRow, newCol);
    filteredCol = 1;
    
    for c = 1:rawCol
       if new(c) == 1
           filteredMatrix(:, filteredCol) = matrix(:, c);
           filteredCol = filteredCol+1;
       end
    end
    
    r = corrcoef(filteredMatrix);
    r2 = r.*~eye(size(r));
    rSquare = squareform(r2);
    percentile = prctile(rSquare,90);
    
    
    removeGene = zeros(1, newCol);
    for i = 1:newCol
        temp = r(:, i) >= percentile;
        tempSum = sum(temp)-1;
        if tempSum < 5
           removeGene(i) = 1; 
        end
    end
    
    sumRemoveGene = sum(removeGene);
    newCol2 = length(removeGene)- sumRemoveGene;
    newFilteredMatrix = zeros(rawRow, newCol2);
    newCol2Idx = 1;
    for i = 1:newCol
        if removeGene(i) == 0
            newFilteredMatrix(:, newCol2Idx) = filteredMatrix(:, i);
            newCol2Idx = newCol2Idx+1;
        end
    end
    
    statisticsMatrix = zeros(4, newCol2);
    for i = 1:newCol2
       temp = newFilteredMatrix(:, i);
       x = mean(temp);  
       z = std(temp);
       y = z/x;
       statisticsMatrix(1, i) = x;
       statisticsMatrix(2, i) = y; 
       theoreticalVal = (x.^-0.55)+0.64;
       statisticsMatrix(3, i) = theoreticalVal;
       statisticsMatrix(4, i) = abs(theoreticalVal-y);
       
    end    
    
    [rankedVal, rankedIdx] = sort(statisticsMatrix(4, :));
    toRemove = newCol2 - 5000;
    for i = 1:toRemove
        rankedVal(:, 5001) = [];
        rankedIdx(:, 5001) = [];
    end
    
    finalMatrix = zeros(rawRow, 5000);
    finalMatrixIdx = 1;
    for k = 1:newCol2
       if (ismember(k, rankedIdx))
           finalMatrix(:, finalMatrixIdx) = newFilteredMatrix(:, k);
           finalMatrixIdx = finalMatrixIdx+1;
       end
    end

    writematrix(finalMatrix, 'processed_linnarsson_data.csv');

%     [coeff,score,latent,tsquared,explained,mu] = pca(matrix);
%     idx = find(cumsum(explained)>99,1);
%     scoreTrain95 = score(:,1:idx);
%     
%     newScore = round(scoreTrain95);
%     newScore = abs(newScore);
%     
%     writematrix(newScore, 'test_pca_linnarson.csv');
    
   
end