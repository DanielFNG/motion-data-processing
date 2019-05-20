function marker_data = compensateSpeedMarkers(...
    marker_data, speed, direction)
% Compensate markers for the speed of a fixed-speed reference frame.
%
% For example: motion on a treadmill.
%
% Inputs:
%           - marker_data: marker data as a TRCData object
%           - speed: array of speeds of reference frame or single speed
%           - direction: direction of reference frame motion (x/y/z)
%
% Output:
%           - the adjusted marker_data

    % Get time array.
    time = marker_data.getColumn('time');

    % Construct speed array - depends on form of input.
    if length(speed) == 1
        speed = ones(size(time))*speed;
    end
    
    % Loop over the marker data labels. For every trajectory in the correct
    % direction, compensate for the provided fixed speed.
    for i=1:marker_data.NCols
        if strcmpi(marker_data.Labels{i}(end), direction)
            initial_values = marker_data.getColumn(i);
            adjusted_values = accountForReferenceFrameMovement(...
                initial_values, time, speed);
            marker_data.setColumn(i, adjusted_values);
        end
    end

end