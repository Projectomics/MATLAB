function [doublesData, nParcelsMean, nParcelsStdev] = combine_doubles(binaryData, doublesData)

    strng = sprintf('OR function applied to doubles ...\n');
    disp(strng);
    
    nRows = size(binaryData, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            c = c + 1;
            sumRows = sum(binaryData(i, :) | binaryData(ii, :)); %finds the sum of the or of two consecutive rows
            if (sumRows > 0)
                if (doublesData(sumRows) == 0) %if that sumRows index in doublesData is 0, put in 2 
                    doublesData(sumRows) = 2;
                end
            end
            nParcels(c) = sumRows; %makes an array of the unions between two rows
        end % ii
    end % i

    nParcelsMean = mean(nParcels)
    nParcelsStdev = std(nParcels)
    nParcelsMax = max(nParcels)
    
end % combine_doubles()