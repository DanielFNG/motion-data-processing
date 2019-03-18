function marker_data = compensateSpeedMarkers(marker_data, speed, direction)
% Compensate markers for the speed of a fixed-speed reference frame.
%
% For example: motion on a treadmill.
%
% Inputs:
%           - marker_data: marker data as a TRCData object
%           - speed: speed of reference frame motion
%           - direction: direction of reference frame motion (x/y/z)
%
% Output:
%           - the adjusted marker_data

    % Get the total time of motion.
    time = marker_data.getTotalTime();
    
    % Loop over the marker data labels. For every trajectory in the correct
    % direction, compensate for the provided fixed speed.
    for i=1:marker_data.NCols
        if strcmpi(marker_data.Labels{i}(end), direction)
            initial_values = marker_data.getColumn(i);
            adjusted_values = accountForMovingReferenceFrame(...
                initial_values, time, speed);
            marker_data.setColumn(i, adjusted_values);
        end
    end

end