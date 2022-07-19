function [doublesData, nParcelsMean, nParcelsStdev] = combine_singles(binaryData, doublesData)

    strng = sprintf('OR function applied to singles ...\n');
    disp(strng);
    
    nRows = size(binaryData, 1);
    
    c = 0; %represents the index of nParcels array
    for i = 1:nRows
        c = c + 1;
        sumRows = sum(binaryData(i, :)); %gets the sum of all the values in row i
        nParcels(c) = sumRows; %nParcels creates an array of the number of parcels found at each row(neuron)
    end % i

    nParcelsMean = mean(nParcels)
    nParcelsStdev = std(nParcels)
    nParcelsMax = max(nParcels)

    disp(' ');
    
end % combine_singles()