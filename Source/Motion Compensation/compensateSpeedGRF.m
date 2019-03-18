function grf_data = compensateSpeedGRF(grf_data, speed, direction)
% Compensate grfs for the speed of a fixed-speed reference frame.
%
% For example: motion on a treadmill.
%
% Inputs:
%           - grf_data: grf data as a MOTData object
%           - speed: speed of reference frame motion
%           - direction: direction of reference frame motion (x/y/z)
%
% Output:
%           - the adjusted grf data

    % Get the total time of motion.
    time = grf_data.getTotalTime();
    
    % Loop over the grf data labels. For every CoP trajectory in the
    % correct direction, compensate for the provided fixed speed. 
    for i=1:grf_data.NCols
        if strcmpi(grf_data.Labels{i}(end-1:end), ['p' direction])
            initial_values = grf_data.getColumn(i);
            adjusted_values = accountForMovingReferenceFrame(...
                initial_values, time, speed);
            grf_data.setColumn(i, adjusted_values);
            
        end      
    end
    
    % Re-set any CoP's to NaN if the vertical force is 0.
    for i=1:grf_data.NCols
        if strcmpi(grf_data.Labels{i}(end-1:end), 'vy')
            force_values = grf_data.getColumn(i);
            for direction = 'xyz'
                label = [grf_data.Labels{i}(1:end-2) 'p' direction];
                cop = grf_data.getColumn(label);
                cop(force_values < 1e-8) = NaN;
                grf_data.setColumn(label, cop);
            end
        end
    end

end
