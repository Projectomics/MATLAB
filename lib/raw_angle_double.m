function doublesData = raw_angle_double(data)

%     strng = sprintf('\nXOR function applied to doubles ...\n');
%     disp(strng);
    
    nRows = size(data, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            vector1 = data(i, :);
            vector2 = data(ii, :);
            dotProduct = dot(vector1, vector2);
            mag1 = norm(vector1);
            mag2 = norm(vector2);
            angle = acosd(dotProduct/(mag1 * mag2));
            angle = round(angle);
            c = c + 1;
            doublesData(c, :) = [i ii angle];
        end % ii
    end % i

end % combine_doubles()