classdef GRFData < MotionData
    % Concrete class for working with marker data.
    
    methods
       
        function obj = GRFData(varargin)
        % GRFData constructor.
        %
        %   obj = GRFData(varargin)
        %
        %   If constructing from file, varargin is of length 3.
        %   varargin{1} = input_file [path to input file, char]
        %   varargin[2} = system [system struct]
        %   varargin{3} = inclination [force plate inclination]
        %
        %   If constructing from an existing object, varargin is of length
        %   2.
        %   varargin{1} = grf_data [existing GRFData object]
        %   varargin{2} = name [the name associated with this object]
            
            super_args = {};
            if nargin > 0
                if isa(varargin{1}, 'char')
                    % Read in the time, force and moment arrays.
                    [time, forces, moments, ~] = readViconForceData(varargin{1});

                    % Core GRF processing.
                    [time, forces, torques, cop] = processGRFs(...
                        time, forces, moments, varargin{2}, varargin{3});

                    % Construct overall GRF data array.
                    data = constructGRFDataArray(forces, cop, torques);

                    % Create MOTData.
                    motion_data = createGRFData(time, data);

                    % Motion-base transformation.
                    motion_data.rotate([0, 0, varargin{3}]);

                    % Store name of motion.
                    [~, name, ~] = fileparts(varargin{1});

                    % Create superclass arguments
                    super_args = {motion_data, name};
                else
                    % Superclass arguments already passed in
                    super_args = varargin;
                end
            end
            
            % Create object.
            obj@MotionData(super_args{:});
            
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
            timesteps = obj.Motion.getTimesteps();
            for i = 1:length(stance) - 1
                if stance(i + 1) > stance(i) + 1
                    % Ignore first gait cycle if incomplete.
                    if start ~= 1 || stance(1) ~= 1
                        cycle_times{k} = timesteps(...
                            stance(start):stance(i + 1) - 1); %#ok<AGROW>
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
                    adjusted_values = obj.accountForReferenceFrameMovement(...
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