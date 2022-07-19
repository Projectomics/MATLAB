function p = call_all_functions_raw_laterality(neuronArray, matfile)
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
        %                rawBinMatrix = open_raw_data_file(reply); % read binary matrix
        %            end
        %        end
        %end
        rawBinMatrix = readmatrix(matfile);
        
        % Create binary matrix for only the neurons in the cluster
        
        [nRows, nCols] = size(rawBinMatrix);
        rawMatrix = zeros(length(neuronArray), nCols);
        for row = 1:length(neuronArray)
            for col = 1:nCols
                rawMatrix(row, col) = rawBinMatrix(neuronArray(row), col); 
            end        
        end
                              
        % Shuffle binary matrix
        
        parcels = open_str_data_file2_semicolon('pma_layer6_filteredParcels_20210601161606.txt');
        
        shuffleMatrix = rawMatrix;
        [nRows, nCols] = size(shuffleMatrix);        
        count=0;
        isFullShuffle = 1;
        %for iShuffle = 1:nShuffles
        while count <= 100000
            if isFullShuffle
                randRow1 = randi(nRows);
                randRow2 = randRow1;
                while(randRow1 == randRow2)
                   randRow2 = randi(nRows); 
                end
                if(randRow1 < randRow2)
                    bottomRow = randRow2;
                    topRow = randRow1;
                else
                    bottomRow = randRow1;
                    topRow = randRow2;
                end                
                
                randCol1 = randi(nCols);
                randCol2 = randCol1;
                while(randCol1 == randCol2)
                   randCol2 = randi(nCols); 
                end
                if(randCol1 < randCol2)
                    leftColumn = randCol1;
                    rightColumn = randCol2;
                else
                    leftColumn = randCol2;
                    rightColumn = randCol1;
                end
                
                first = cell2mat(parcels(leftColumn));
                second = cell2mat(parcels(rightColumn));
                if(first(1:3) == second(1:3))
                    topLeft = shuffleMatrix(topRow, leftColumn);
                    topRight = shuffleMatrix(topRow, rightColumn);
                    bottomLeft = shuffleMatrix(bottomRow, leftColumn);
                    bottomRight = shuffleMatrix(bottomRow, rightColumn);
                    if(topLeft < bottomRight)
                        maxBound = topLeft;
                    else
                        maxBound = bottomRight;
                    end
                    if(maxBound == 0)
                        if(topRight ~= 0 && bottomLeft ~= 0)
                            if(topRight < bottomLeft)
                                maxBound = topRight;
                            else
                                maxBound = bottomLeft;
                            end
                            value = randi(maxBound);
                            shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)+value;
                            shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)-value;
                            shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)-value;
                            shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)+value;               
                            count = count+1;
                        end                          
                    else
                        value = randi(maxBound);
                        shuffleMatrix(topRow, leftColumn) = shuffleMatrix(topRow, leftColumn)-value;
                        shuffleMatrix(bottomRow, leftColumn) = shuffleMatrix(bottomRow, leftColumn)+value;
                        shuffleMatrix(topRow, rightColumn) = shuffleMatrix(topRow, rightColumn)+value;
                        shuffleMatrix(bottomRow, rightColumn) = shuffleMatrix(bottomRow, rightColumn)-value;               
                        count = count+1;
                    end
                end                                
            end % if isFullShuffle
        end % iShuffle
        tag = 'fullyShuffled';
        disp(sprintf('Total times swapped: %d', count));
        
        % MouseLight
        
        rawData = raw_angle_double(rawMatrix);
        shuffledData = raw_angle_double(shuffleMatrix);
    
        nXorRows = size(rawData, 1);
        rawDifferences = {};
        rawDifferencesIndex = 1;
        randDifferences = {};
        randDiffIndex = 1;

        for i = 1:nXorRows
            rawDifferences{rawDifferencesIndex} = rawData(i, 3);
            rawDifferencesIndex=rawDifferencesIndex+1;
            randDifferences{randDiffIndex} = shuffledData(i, 3);
            randDiffIndex=randDiffIndex+1;
        end % i
        
        % Conduct f-test
        
        rawDifferencesMat = cell2mat(rawDifferences);
        randDifferencesMat = cell2mat(randDifferences);
        if(var(randDifferencesMat) > var(rawDifferencesMat))
            p = 1*14;
        else
            shuffleMatrix = [rawDifferencesMat(:), randDifferencesMat(:)];
            [p, stats] = vartestn(shuffleMatrix,'TestType','LeveneAbsolute','Display','off')
            p = p * 14;
        end
        
        %[p, stats] = vartest2(cell2mat(binDifferences), cell2mat(randDifferences), 'Tail', 'right');
        %p = p * 14;
        
    end
end