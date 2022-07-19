function [quadruplesData, nParcelsMean, nParcelsStdev] = combine_quadruples(binaryData, quadruplesData)
    
    strng = sprintf('\nOR function applied to quadruples ...\n');
    disp(strng);
    
    nRows = size(binaryData, 1);
    
    nParcels = zeros(nRows*(nRows-1)*(nRows-2)*(nRows-3)/2, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            for iii = ii+1:nRows
                for iv = iii+1:nRows
                    c = c + 1;
                    sumRows = sum(binaryData(i, :) | binaryData(ii, :) | binaryData(iii, :) | binaryData(iv, :));
                    if (sumRows > 0)  
                        if (quadruplesData(sumRows) == 0)
                            quadruplesData(sumRows) = 4;
                        end
                    end
                    nParcels(c) = sumRows;
                end % iv
            end % iii
        end % ii
    end % i

    idx = find(nParcels > 0);
    
    nParcelsMean = mean(nParcels(idx))
    nParcelsStdev = std(nParcels(idx))
    nParcelsMax = max(nParcels(idx))

    fid = fopen('./output/quadruples.csv', 'w');
    for i = 1:c
        fprintf(fid, '%d\n', nParcels(i));
    end
    fclose(fid);
    
end % combine_triples()