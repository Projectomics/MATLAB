function [triplesData, nParcelsMean, nParcelsStdev] = combine_triples(binaryData, triplesData)
    
    strng = sprintf('\nOR function applied to triples ...\n');
    disp(strng);
    
    nRows = size(binaryData, 1);
    
    nParcels = zeros(nRows*(nRows-1)*(nRows-2)/2, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            for iii = ii+1:nRows
                c = c + 1;
                sumRows = sum(binaryData(i, :) | binaryData(ii, :) | binaryData(iii, :));
                if (sumRows > 0)
                    %disp(sumRows);
                    if (triplesData(sumRows) == 0)
                        triplesData(sumRows) = 3;
                    end
                end
                nParcels(c) = sumRows;
            end % iii
        end % ii
    end % i

    idx = find(nParcels > 0);
    
    nParcelsMean = mean(nParcels(idx))
    nParcelsStdev = std(nParcels(idx))
    nParcelsMax = max(nParcels(idx))

end % combine_triples()