function doublesData = xor_doubles(binaryData)

    strng = sprintf('\nXOR function applied to doubles ...\n');
    disp(strng);
    
    nRows = size(binaryData, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            sumRows = sum(xor(binaryData(i, :), binaryData(ii, :)));
            c = c + 1;
            doublesData(c, :) = [i ii sumRows];
        end % ii
    end % i

end % combine_doubles()