function [left, right] = findThresholdIndices(forces, upper, lower)
% This function finds indices in filtered force data at which the vertical force 
% is between an upper and lower bound. This complex implementation (compared to 
% find(fy < upper & fy < lower) for example) allows us to ignore any 
% oscillations around FY = 0 in the data between gait cycles which commonly 
% results from the filtering process. 

for side = [2, 5]
    vy = forces(:, side);
    j = find(vy > upper, 1, 'first');
    i = find(vy(1:j) < lower, 1, 'last') + 1;
    if isempty(i)  % There's no data to be thresholded from the start
        i = 2;
        indices = [];
    else  % There is data to be thresholded from the start
        indices = 1:(i - 1);
    end
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