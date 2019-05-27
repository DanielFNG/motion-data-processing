function speed = calculateSpeedArray(speed_data, filter, threshold)
% Function mostly here incase we ever want to extend this to split belt
% case. Currently assumes left speed = right speed.

    speed_data.filter4LP(filter);
    speed = speed_data.getColumn('Speed');
    % Uglily support two current forms of speed formatting. 
    if size(speed, 2) == 0
        speed = speed_data.getColumn('Right Speed');
    end 
    speed(speed < threshold) = 0;

end