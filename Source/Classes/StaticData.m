classdef StaticData
    
    properties
        Static
    end
    
    methods
        
        function obj = StaticData(input_file, system)
            
            % Load static data.
            obj.Static = Data(input_file);
            
            % Compute & add midpoint markers.
            obj.Static = computeJointCentres(obj.Static);
            
            % Convert to OpenSim co-ordinates. 
            obj.Static.convert(system);
            
        end
        
    end
    
end
