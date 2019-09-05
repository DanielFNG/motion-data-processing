function [left, right] = findThresholdIndices(forces, upper, lower)

for side = [2, 5]
    i = 2;
    vy = forces(:, side); 
    indices = [];
    while i < length(vy)
        if vy(i-1) > upper && vy(i) <= upper
            start = find(vy(i:end) < lower, 1, 'first');
            mid = find(vy(i:end) > upper, 1, 'first');
            last = find(vy(i:i + mid - 1) < lower, 1, 'last');
            indices = [indices (i + start - 1):(i + last - 1)]; %#ok<*AGROW>
            i = i + mid - 1;
        else
            i = i + 1;
        end
    end
    switch side
        case 2
            left = indices;
        case 5 
            right = indices;
    end
end