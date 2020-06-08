classdef (Abstract) MotionData < handle & matlab.mixin.Copyable
    % Abstract Class for storing & working with motion data.
    %
    % Holds methods which are generic to motion data classes, specific 
    % implementations are redefined in the appropriate subclasses.
    
    properties
        Name
        Motion
    end
    
    methods (Abstract, Access = protected)
        
        cycle_times = getSegmentationTimes(obj, parameter)
        compensateSpeed(obj, speed, direction)
        
    end
    
    methods
        
        function obj = MotionData(motion_data, name)
            
            if nargin > 0
                obj.Name = name;
                obj.Motion = motion_data;
            end
            
        end
       
        function synchronise(obj, another_obj, delay)
           
            [obj.Motion, another_obj.Motion] = obj.Motion.synchronise(...
                another_obj.Motion, delay);
            
        end
        
        function chunks = segment(obj, side, another_obj)
            
            % Allow for segmentation using a second object
            if nargin == 3
                main = another_obj;
            else
                main = obj;
            end
            
            % Get times of segments from the main object.
            side = lower(side);
            cycle_times = main.getSegmentationTimes(side);
            
            % Outlier removal.
            cycle_lengths = cellfun(@length, cycle_times);
            while any(isoutlier(cycle_lengths))
                good_cycles = ~isoutlier(cycle_lengths);
                cycle_times = cycle_times(good_cycles);
                cycle_lengths = cycle_lengths(good_cycles);
            end
            
            % Perform segmentation.
            n_cycles = length(cycle_times);
            digits = numel(num2str(n_cycles));
            chunks = cell(1, n_cycles);
            constructor = class(obj);
            for i = 1:n_cycles
                chunk_name = [obj.Name filesep side filesep 'cycle' ...
                    sprintf(['%0' num2str(digits) 'i'], i)];
                start = cycle_times{i}(1);
                finish = cycle_times{i}(end);
                chunks{i} = feval(constructor, ...
                    obj.Motion.slice(start, finish), chunk_name);
            end
            
        end
        
        function compensateMotion(obj, speed, delay, name, threshold, filter)
            
            if isa(speed, 'char')
                speed_data = Data(speed);
                [~, speed_data] = obj.Motion.synchronise(...
                    speed_data, delay);
                speed_data.spline(obj.Motion.Timesteps);
                speed_data.filter4LP(filter);
                speed_array = speed_data.getColumn(name);
                if threshold 
                    speed_array(speed_array < 0) = 0;
                end
                obj.compensateSpeed(speed_array, 'x');
            elseif speed ~= 0
                obj.compensateSpeed(speed, 'x');
            end
            
        end
        
        function writeToFile(obj, save_dir)
            
            % Create save directory if it doesn't exist
            save_path = [save_dir filesep obj.Name];
            [path, ~, ~] = fileparts(save_path);
            if ~exist(path, 'dir')
                mkdir(path);
            end
            
            % Write motion data
            obj.Motion.writeToFile([save_dir filesep obj.Name]);
            
        end
        
    end
    
    methods (Static)
        
        function new_trajectory = accountForReferenceFrameMovement(...
                trajectory, time, speed)
        % Transform speed data to account for moving reference frame.
        %
        % Input:
        %   trajectory - a trajectory in cartesian space (array size N)
        %   time - the time at each point along the trajectory 
        %   speed - the speed of the reference frame at each point
        %
        % Output:
        %   new_trajectory - the trajectory from the point of view of a
        %   static observer
            
            % Compute distance travelled between timesteps
            dx = speed(1:end - 1) .* (time(2:end) - time(1:end - 1));
            
            % Initialise new trajectory
            new_trajectory = trajectory;
            
            % Iteratively update the trajectory
            for i = 2:length(new_trajectory)
                new_trajectory(i) = new_trajectory(i - 1) - ...
                    trajectory(i - 1) + + trajectory(i) + dx(i - 1);
            end
            
        end
        
    end
    
    
end





