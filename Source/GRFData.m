classdef GRFData < MotionData
    % Concrete class for working with marker data.
    
    methods
       
        function obj = GRFData(input_file, system, inclination, params)
            
            if nargin > 0
                % Read in the time, force and moment arrays.
                [time, forces, moments, ~] = readViconForceData(input_file);

                % Core GRF processing.
                [time, forces, torques, cop] = ...
                    processGRFs(time, forces, moments, system, inclination);

                % Construct overall GRF data array.
                data = constructGRFDataArray(forces, cop, torques);

                % Create MOTData.
                obj.Motion = createGRFData(time, data);

                % Motion-base transformation.
                obj.Motion.rotate(0, inclination, 0);

                % If requested add assistive torques as external forces.
                if nargin == 4
                    obj.Motion = applyParameterisedAssistance(...
                        obj.Motion, params);
                end

                % Store name of motion.
                [~, obj.Name, ~] = fileparts(input_file);
            end
            
        end
        
    end
    
    methods (Access = protected)
        
        function cycle_times = getSegmentationTimes(obj, side)
        % Get segmentation times according to stance phase information.
            
            % Switch GRF label as appropriate.
            switch side
                case 'left'
                    str = 'ground_force2_vy';
                case 'right'
                    str = 'ground_force1_vy';
            end
            
            % Identify indices which are in stance.
            stance = find(obj.Motion.getColumn(str) > 0);
            
            % Identify every complete gait cycle. 
            k = 1;
            start = 1;
            for i = 1:length(stance) - 1
                if indices(i + 1) > indices(i) + 1
                    % Ignore first gait cycle if incomplete.
                    if start ~= 1 || indices(1) ~= 1
                        cycle_times{k} = obj.Motion.Timesteps(...
                            indices(start):indices(i + 1) - 1); %#ok<AGROW>
                        k = k + 1;
                    end
                    start = i + 1;
                end
            end
            
        end
        
        function compensateSpeed(obj, speed, direction)
        % Compensate for the speed of a fixed reference frame (treadmill).
            
            % Construct speed array - depends on form of input.
            if length(speed) == 1 
                speed = ones(size(obj.Motion.Timesteps))*speed;
            end

            % Loop over the grf data labels. For every CoP trajectory in 
            % the correct direction, compensate for the provided speed. 
            for i=1:obj.Motion.NCols
                if strcmpi(...
                        obj.Motion.Labels{i}(end-1:end), ['p' direction])
                    initial_values = obj.Motion.getColumn(i);
                    adjusted_values = accountForReferenceFrameMovement(...
                        initial_values, obj.Motion.Timesteps, speed);
                    obj.Motion.setColumn(i, adjusted_values);

                end      
            end

            % Re-set any CoP's to 0 if the vertical force is 0.
            for i=1:obj.Motion.NCols
                if strcmpi(obj.Motion.Labels{i}(end-1:end), 'vy')
                    force_values = obj.Motion.getColumn(i);
                    for direction = 'xyz'
                        label = ...
                            [obj.Motion.Labels{i}(1:end-2) 'p' direction];
                        cop = obj.Motion.getColumn(label);
                        cop(force_values < 1e-8) = 0;
                        obj.Motion.setColumn(label, cop);
                    end
                end
            end
        end
        
    end
    
    
end