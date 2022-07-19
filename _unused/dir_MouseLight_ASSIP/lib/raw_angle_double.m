function doublesData = raw_angle_double(binaryData)

    strng = sprintf('\nXOR function applied to doubles ...\n');
    disp(strng);
    
    nRows = size(binaryData, 1);
    
    c = 0;
    for i = 1:nRows
        for ii = i+1:nRows
            vector1 = binaryData(i, :);
            vector2 = binaryData(ii, :);
            dotProduct = dot(vector1, vector2);
            mag1 = norm(vector1);
            mag2 = norm(vector2);
            angle = acosd(dotProduct/(mag1 * mag2));
            angle = round(angle);
            c = c + 1;
            doublesData(c, :) = [i ii angle];
        end % ii
    end % i

%     magnitudes = zeros(nRows, 1);
%     for r = 1:nRows
%        vector = binaryData(r, :);
%        magnitudes(r, 1) = norm(vector);
%     end
% 
%     c = 0;
%     for i = 1:nRows
%         for ii = i+1:nRows
%             vector1 = binaryData(i, :);
%             vector2 = binaryData(ii, :);
%             dotProduct = dot(vector1, vector2);
%             mag1 = magnitudes(i);
%             mag2 = magnitudes(ii);
%             angle = acosd(dotProduct/(mag1 * mag2));
%             angle = round(angle);
%             c = c + 1;
%             doublesData(c, :) = [i ii angle];
%         end % ii
%     end % i



end % combine_doubles()