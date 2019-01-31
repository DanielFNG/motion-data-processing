function [markers, grfs] = renoveMissingFrames(marker_file, grfs)
% Detect & remove missing timesteps in kinematics and (optionally) grfs.

try 
    markers = Data(marker_file);
catch err
    if strcmp(err.identifier, 'Data:Gaps')
        [start_markers, end_markers, markers] = ...
            returnMissingFrames(marker_file);
        
        
        frequency_multiplier = grfs.Frequency/
        start_grfs = start_markers*
    else
        rethrow(err);
    end
end
    

end