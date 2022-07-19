function filteredBinMatrix = filter_bin_matrix(binMorphologyMatrix, morphologyMatrix, region)
    filteredBinMatrix.axonCounts = zeros(binMorphologyMatrix.nRows, binMorphologyMatrix.nCols);
    filteredBinMatrix.parcels = {'parcels'};
    sumCols = sum(binMorphologyMatrix.axonCounts);
    filteredCol = 1;
    
    for c = 1:binMorphologyMatrix.nCols
       if(sumCols(c)==0) 
            continue
       else
           for r = 1:binMorphologyMatrix.nRows
                filteredBinMatrix.axonCounts(r, filteredCol) = binMorphologyMatrix.axonCounts(r, c);
                filteredBinMatrix.parcels(filteredCol) = morphologyMatrix.parcels(c);
           end
           filteredCol = filteredCol + 1;
       end
    end   
    filteredBinMatrix.nRows = binMorphologyMatrix.nRows;
    filteredBinMatrix.nCols = filteredCol-1;
    
    fileName = sprintf('./output/%s_filteredParcels_%s.txt', region, ...
        datestr(now, 'yyyymmddHHMMSS'));   
    fid = fopen(fileName, 'w');
    for col = 1:filteredBinMatrix.nCols
       fprintf(fid, '%s;', cell2mat(filteredBinMatrix.parcels(col)));        
    end
    fclose(fid);

end