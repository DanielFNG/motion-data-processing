classdef MarkerData < MotionData
    % Concrete class for working with marker data.
    
    methods
       
        function obj = MarkerData(input_file, system, offset)
            
            obj.Motion = produceMarkers(input_file, system, offset);
            
            % Load data.
            obj.Motion = Data(input_file);
            
            % Convert units to 'm'.
            obj.Motion.convertUnits('m');
            
            % Convert coordinates to OpenSim.
            obj.Motion.convert(system);
            
            % Account for coordinate system offsets.
            obj.Motion = applyOffsets(obj.Motion, offset);
            
        end
        
    end
    
    methods (Access = protected)
        
        function cycle_times = getSegmentationTimes(obj, side)
        % Get segmentation times according to approximation of hip angle.
            % Segments according to the point of maximum EXTENSION of the 
            % chosen side.
            %
            % This assumes that the input motion data is in the OpenSim
            % coordinate system (X forward from subject, Y up, Z to the
            % right). This will be the case assuming the system input to
            % this object was correct.
            
            % Switch marker labels as appropriate.
            switch side 
                case 'left'
                    upper_str = 'L_ASIS';
                    front_str = 'L_Thigh_Front';
                case 'right'
                    upper_str = 'R_ASIS';
                    front_str = 'R_Thigh_Front';
            end
            
            % Calculate the angle between these markers.
            upper_x = obj.Motion.getColumn([upper_str '_X']);
            upper_y = obj.Motion.getColumn([upper_str '_Y']);
            front_x = obj.Motion.getColumn([front_str '_X']);
            front_y = obj.Motion.getColumn([front_str '_Y']);
            angle = atan((front_x - upper_x)./(upper_y - front_y));
            
            % Find the crossing points.
            crossing_points = [];
            for i=2:length(angle)
                if angle(i) > 0 && angle(i - 1) <= 0
                    crossing_points = [crossing_points i];
                end
            end
            
            % Find the largest peak between each pair of crossing points,
            % discarding the positive ones.
            indices = [];
            for i=2:length(crossing_points)
                temp = ones(size(angle))*100;
                range = crossing_points(i - 1):crossing_points(i);
                temp(range) = angle(range);
                [~, idx] = min(temp);
                indices = [indices idx];  %#ok<*AGROW>
            end
            
            % Note: motion_data must be in OpenSim coordinate system!
            n_cycles = length(indices) - 1;
            cycle_times = cell(1, n_cycles);
            timesteps = obj.Motion.getColumn('time');
            
            for i=1:n_cycles
                cycle_times{i} = timesteps(indices(i):indices(i+1) - 1);
            end
            
        end
        
        function compensateSpeed(obj, speed, direction)
        % Compensate for the speed of a fixed reference frame (treadmill).

            % Construct speed array - depends on form of input.
            if length(speed) == 1
                speed = ones(size(obj.Motion.Timesteps))*speed;
            end

            % Loop over the marker data labels. For every trajectory in the 
            % correct direction, compensate for the provided fixed speed.
            for i=1:obj.Motion.NCols
                if strcmpi(obj.Motion.Labels{i}(end), direction)
                    initial_values = obj.Motion.getColumn(i);
                    adjusted_values = accountForReferenceFrameMovement(...
                        initial_values, time, speed);
                    obj.Motion.setColumn(i, adjusted_values);
                end
            end
            
        end
        
    end
    
    
end