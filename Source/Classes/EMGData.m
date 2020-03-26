classdef EMGData < MotionData
    % Concrete class for working with marker data.
    
    methods
       
        function obj = EMGData(input_file)
            
            % Read in the EMG data.
            [time, emg] = readViconEMGData(input_file);
            
            % Process EMG signals.
            for i = 1:size(emg, 2)
                emg(:, i) = processEMGSignal(emg(:, i));
            end
            
            % Create Data object.
            obj.Motion = createEMGData(time, emg, input_file);
            
        end
        
    end
    
    methods (Access = protected)
        
        function cycle_times = getSegmentationTimes(obj, channel)
            
            cycle_times = segmentEMG(channel, obj.Motion);
            
        end
        
        function compensateSpeed(obj, direction)
            
        end
        
    end
    
    
end