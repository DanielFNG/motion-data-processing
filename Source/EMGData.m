classdef EMGData < MotionData
    % Concrete class for working with marker data.
    
    methods
       
        function obj = EMGData(varargin)
        % EMGData constructor.
        %
        %   obj = EMGData(varargin)
        %
        %   If constructing from file, varargin is of length 1.
        %   varargin{1} = input_file [path to input file, char]
        %
        %   If constructing from an existing object, varargin is of length
        %   2.
        %   varargin{1} = motion_data [existing concrete subclass of
        %   motion]
        %   varargin[2} = name [the name associated with this object, char]
            
            super_args = {};
            if nargin > 0
                if isa(varargin{1}, 'char')
                    % Read in the EMG data.
                    [time, emg] = readViconEMGData(varargin{1});

                    % Process EMG signals.
                    for i = 1:size(emg, 2)
                        emg(:, i) = processEMGSignal(emg(:, i));
                    end

                    % Create Data object.
                    motion_data = createEMGData(time, emg);

                    % Store name of motion.
                    [~, name, ~] = fileparts(varargin{1});

                    % Create superclass arguments.
                    super_args = {motion_data, name};
                else
                    % Superclass arguments already passed in
                    super_args = varargin;
                end
            end
            
            % Create object
            obj@MotionData(super_args{:});
            
        end
        
    end
    
    methods (Access = protected)
        
        function cycle_times = getSegmentationTimes(obj, channel)
            
            cycle_times = segmentEMG(channel, obj.Motion);
            
        end
        
        function compensateSpeed(~, ~)
            
        end
        
    end
    
    
end