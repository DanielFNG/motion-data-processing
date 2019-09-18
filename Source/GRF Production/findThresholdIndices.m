function [left, right] = findThresholdIndices(forces, upper, lower)

for side = [2, 5]
    vy = forces(:, side); 
    i = find(vy > lower, 1, 'first') + 1;
    indices = 1:(i - 2);
    while i < length(vy)
        if vy(i - 1) > upper && vy(i) <= upper
            start = find(vy(i:end) < lower, 1, 'first');
            if ~isempty(start)
                mid = find(vy(i:end) > upper, 1, 'first');
                if isempty(mid)
                    last = find(vy(i:end) < lower, 1, 'last');
                    indices = [indices (i + start - 1):(i + last - 1)];%#ok<*AGROW>
                    i = length(vy);
                else
                    last = find(vy(i:i + mid - 1) < lower, 1, 'last');
                    indices = [indices (i + start - 1):(i + last - 1)];
                    i = i + mid - 1;
                end
            else
                break;
            end
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