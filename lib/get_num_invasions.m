function morphologyMatrix = get_num_invasions(groupings, morphologyMatrix)
    morphologyMatrix.numAxonInvasions = zeros(1, morphologyMatrix.nCols);
    morphologyMatrix.maxAxonInvasions = zeros(1, morphologyMatrix.nCols);
    morphologyMatrix.minAxonInvasions = zeros(1, morphologyMatrix.nCols);
    morphologyMatrix.meanAxonInvasions = zeros(1, morphologyMatrix.nCols);
    morphologyMatrix.stdAxonInvasions = zeros(1, morphologyMatrix.nCols);
    
    [rows, cols] = size(groupings.neurons);
    for i = 1:morphologyMatrix.nCols
        regionNeurons = [];
        regionNeuronsIndex = 1;   
        indivInvasions = [];
        indivInvasionsIndex = 1;
        for j = 1:cols
           if(strcmpi(groupings.neurons(i,j), ''))
                break;
           else
               str = groupings.neurons(i, j);
               num = str2num(extractAfter(str, 2));
               if(num > 1094)
                   num = 1094;
               end
               regionNeurons(regionNeuronsIndex) = num;
               regionNeuronsIndex = regionNeuronsIndex+1;
               indivInvasions(indivInvasionsIndex) = morphologyMatrix.totalRegionsInvaded(num);
               indivInvasionsIndex = indivInvasionsIndex+1;
           end
        end
        
        if(length(regionNeurons)==0)
            morphologyMatrix.numAxonInvasions(i) = 0;
            morphologyMatrix.maxAxonInvasions(i) = 0;
            morphologyMatrix.minAxonInvasions(i) = 0;
            morphologyMatrix.meanAxonInvasions(i) = 0;
            morphologyMatrix.stdAxonInvasions(i) = 0;
        else
            num = regionNeurons(1);
            collectivePathway = morphologyMatrix.axonParcelInvasions(num, :);
            for idx = 1:length(regionNeurons)
                num = regionNeurons(idx);
                currentPathway = morphologyMatrix.axonParcelInvasions(num, :);
                collectivePathway = collectivePathway | currentPathway;                
            end
            sumPathway = sum(collectivePathway);
            morphologyMatrix.numAxonInvasions(i) = sumPathway;
            morphologyMatrix.maxAxonInvasions(i) = max(indivInvasions);
            morphologyMatrix.minAxonInvasions(i) = min(indivInvasions);
            morphologyMatrix.meanAxonInvasions(i) = mean(indivInvasions);
            morphologyMatrix.stdAxonInvasions(i) = std(indivInvasions);
        end  
        
    end     
end