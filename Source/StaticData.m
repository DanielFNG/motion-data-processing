classdef StaticData
    
    properties
        Name
        Static
    end
    
    methods
        
        function obj = StaticData(input_file, system)
            
            if nargin > 0
                
                % Load static data.
                obj.Static = Data(input_file);

                % Compute & add midpoint markers.
                obj.Static = computeJointCentres(obj.Static);

                % Convert to OpenSim co-ordinates. 
                obj.Static.convert(system);

                % Store name of static.
                [~, obj.Name, ~] = fileparts(input_file);
                
            end
            
        end
        
        function write(obj, save_dir)
            
            obj.Static.writeToFile([save_dir filesep obj.Name]);
            
        end
        
    end
    
end
