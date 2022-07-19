function p = call_all_functions_lateral(neuronArray)
    addpath('./lib/');
    addpath('./lib/jsonlab-1.5');
    addpath('../dir_MouseLight_ASSIP/');
    addpath('../dir_shuffle_ASSIP/');
    addpath('../dir_MouseLight_ASSIP/lib');
    addpath('../dir_shuffle_ASSIP/lib');

    if(length(neuronArray) <= 2) % 2 neurons or less
        p = 1*14;
    else
        %reply = [];
        %while (isempty(reply)) % enter filtered binary matrix for region
        %        reply = select_csvFileName();
        %        if strcmp(reply, '!')
        %            disp('Exiting');
        %        else
        %            fid2 = fopen(reply);
        %            if(fid2 == -1)
        %                reply = [];
        %            else
        %                fclose(fid2);
        %                rawBinMatrix = open_data_file(reply); % read binary matrix
        %            end
        %        end
        %end
        rawBinMatrix = open_data_file('pma_layer6_filtered_bnmorphologyMatrix[A]20201230090517.csv');
        
        % Create binary matrix for only the neurons in the cluster
        
        [nRows, nCols] = size(rawBinMatrix);
        binMatrix = zeros(length(neuronArray), nCols);
        for row = 1:length(neuronArray)
            for col = 1:nCols
                binMatrix(row, col) = rawBinMatrix(neuronArray(row), col); 
            end        
        end
                              
        % Shuffle binary matrix
        
        parcels = open_str_data_file2_semicolon('pma_layer6_filteredParcels_20201230090517.txt');
        
        shuffleMatrix = binMatrix;
        [nRows, nCols] = size(shuffleMatrix);        
        count=0;
        isFullShuffle = 1;
        %for iShuffle = 1:nShuffles
        while count <= 100000
            if isFullShuffle
                countLoop = 0;
                randRow1 = randi([1, nRows-1], 1, 1);
                randCol1 = randi([1, nCols-1], 1, 1);
                topLeft = shuffleMatrix(randRow1, randCol1);
                
                while(countLoop < 100)
                    randCol2 = randi([randCol1+1, nCols], 1, 1);
                    topRight = shuffleMatrix(randRow1, randCol2);
                    if(randCol2 ~= randCol1 & topRight ~= topLeft)
                        break;
                    end
                    countLoop = countLoop+1;
                end
                countLoop = 0;
                
                while(countLoop < 100)
                    randRow2 = randi([randRow1+1, nRows], 1, 1);
                    bottomLeft = shuffleMatrix(randRow2, randCol1);
                    if(randRow2 ~= randRow1 & bottomLeft ~= topLeft)
                        break;
                    end
                    countLoop = countLoop+1;
                end
                bottomRight = shuffleMatrix(randRow2, randCol2);     
                                
                if((topLeft == bottomRight) & (bottomLeft == topRight) & (topLeft ~= bottomLeft) & (topRight ~= bottomRight))
                    first = cell2mat(parcels(randCol1));
                    second = cell2mat(parcels(randCol2));
                    if(first(1:3) == second(1:3))
                        sumBefore = sum(shuffleMatrix(randRow1, :));
                        shuffleMatrix(randRow1, randCol1) = bottomLeft;
                        newTopLeft = shuffleMatrix(randRow1, randCol1);
                        shuffleMatrix(randRow2, randCol1) = topLeft;
                        newBottomLeft = shuffleMatrix(randRow2, randCol1);
                        shuffleMatrix(randRow1, randCol2) = bottomRight;
                        newTopRight = shuffleMatrix(randRow1, randCol2);
                        shuffleMatrix(randRow2, randCol2) = topRight;
                        newBottomRight = shuffleMatrix(randRow2, randCol2);
                        sumAfter = sum(shuffleMatrix(randRow1, :));
                        if(sumBefore ~= sumAfter)
                           disp(randRow1);
                        end
                        count = count+1;
                    end
                end
                tag = 'fullyShuffled';
            end % if isFullShuffle
        end % iShuffle
        disp(sprintf('Total times swapped: %d', count));
        
        % MouseLight
        
        xorBinaryData = xor_doubles(binMatrix);
        xorShuffledData = xor_doubles(shuffleMatrix);
    
        nXorRows = size(xorBinaryData, 1);
        binDifferences = {};
        binDiffIndex = 1;
        randDifferences = {};
        randDiffIndex = 1;

        for i = 1:nXorRows
            binDifferences{binDiffIndex} = xorBinaryData(i, 3);
            binDiffIndex=binDiffIndex+1;
            randDifferences{randDiffIndex} = xorShuffledData(i, 3);
            randDiffIndex=randDiffIndex+1;
        end % i
        
        % Conduct f-test
        
        binDifferencesMat = cell2mat(binDifferences);
        randDifferencesMat = cell2mat(randDifferences);
        if(var(randDifferencesMat) > var(binDifferencesMat))
            p = 1*14;
        else
            matrix = [binDifferencesMat(:), randDifferencesMat(:)];
            [p, stats] = vartestn(matrix,'TestType','LeveneAbsolute','Display','off')
            p = p * 14;
        end
        
        %[p, stats] = vartest2(cell2mat(binDifferences), cell2mat(randDifferences), 'Tail', 'right');
        %p = p * 14;
        
    end
end