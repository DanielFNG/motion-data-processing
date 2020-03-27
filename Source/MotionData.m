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
        
        function obj = MotionData(varargin)
            
            if nargin > 0
                if nargin == 3 && isa(varargin{3}, 'OpenSimData')
                    obj = feval(varargin{1});
                    obj.Name = varargin{2};
                    obj.Motion = varargin{3};
                end
            end
            
        end
       
        function synchronise(obj, another_obj, delay)
           
            [obj.Motion, another_obj.Motion] = obj.Motion.synchronise(...
                another_obj.Motion, delay);
            
        end
        
        function chunks = segment(obj, parameter)
            
            % Get times of segments.
            cycle_times = obj.getSegmentationTimes(parameter);
            
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
            if isa(parameter, 'float')
                parameter = num2str(parameter);
            end
            for i = 1:n_cycles
                chunk_name = [obj.Name filesep parameter filesep 'cycle' ...
                    sprintf(['%0' num2str(digits) 'i'], i)];
                start = cycle_times{i}(1);
                finish = cycle_times{i}(end);
                chunks{i} = MotionData(...
                    constructor, chunk_name, obj.Motion.slice(start, finish));
            end
            
        end
        
        function compensateMotion(obj, speed, delay)
            
            if isa(speed, 'char')
                speed_data = Data(speed);
                [~, speed_data] = obj.Motion.synchronise(...
                    speed_data, delay);
                speed_data.spline(obj.Motion.Timesteps);
                speed_data = calculateSpeedArray(speed_data, 1, 0.01);
                obj.compensateSpeed(speed_data, 'x');
            elseif speed ~= 0
                obj.compensateSpeed(speed, 'x');
            end
            
        end
        
    end
    
    
end