classdef CalorimetryData < MotionData
    % Concrete class for working with calorimetry data.
    
    methods
        
        function obj = CalorimetryData(varargin)
        % CalorimetryData constructor.
        %
        %   obj = CalorimetryData(varargin)
        %
        %   If constructing from file, varargin is of length 3. 
        %   varargin{1} = input_file [path to input file, char]
        %   varargin{2} = vo2_label [label for V'O2 data, char]
        %   varargin{3} = rer_label [label for RER data, char]
        %
        %   If constructing from an existing object, varargin is of length
        %   2.
        %   varargin{1} = motion_data [existing concrete subclass of
        %   motion]
        %   varargin{2} = name [the name associated with this object, char]
        
        super_args = {};
        if nargin > 0
            if isa(varargin{1}, 'char')
                % Parse the Calorimetry data.
                raw_data = parseMetabolicData(varargin{1});
                
                % Compute experimentally measured metabolic rate
                rer = raw_data.getColumn(varargin{3});
                vo2 = raw_data.getColumn(varargin{2});
                ve = (4.184/60)*(3.972 + 1.078*rer)*vo2;
                
                % Append the metabolic rate data to the raw data
                raw_data.extend('Experimental Metabolic Rate', ve);
                
                % Store name of motion
                [~, name, ~] = fileparts(varargin{1});
                
                % Create superclass arguments
                super_args = {raw_data, name};
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
        
        function cycle_times = getSegmentationTimes(obj, ~)
        % Calorimetry data not segmentable - return full data object.
            
            cycle_times{1} = obj.Motion.getTimesteps();
            
        end
        
        function compensateSpeed(~, ~)
            
        end
        
    end
end