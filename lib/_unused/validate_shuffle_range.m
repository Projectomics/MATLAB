function [range, start] = validate_shuffle_range(neuronArray)
    maximum = max(neuronArray);
    minimum = min(neuronArray);
    minBound = 0;
    maxBound = 0;
    
    if(minimum < -0.55)
        minBound = -1;
    elseif(minimum < -0.05)
        minBound = -0.55;
    elseif(minimum < 0.45)
        minBound = -0.05;
    elseif(minimum < 0.9)
        minBound = 0.45;
    else
        minBound = 0.9;
    end
    
    if(maximum > 0.55)
        maxBound = 1;
    elseif(maximum > 0.05)
        maxBound = 0.55;
    elseif(maximum > -0.45)
        maxBound = 0.05;
    elseif(maximum > -0.9)
        maxBound = -0.45;
    else
        maxBound = -0.9;
    end
    
    range = abs(maxBound - minBound);
    start = minBound;
    
end