function [X, Y, Z] = getCoordinateSystemOffsets(...
    folder, marker_system, grf_system)

    % Parameters 
    marker_height = 0.38;  % Calibration marker height
    marker_name = 'Handle1';  % Calibration marker name
    fp_label = 'ground_force2_p';  % Force plate label

    % Get the marker and grf data files - ensure that there's only one of
    % each, as well. 
    [n_grfs, grfs] = getFilePaths(folder, '.txt.');
    [n_markers, markers] = getFilePaths(folder, '.trc');
    
    if (n_grfs ~= n_markers) || (n_grfs ~= 1)
        error(['Should have 1 set of marker/grf data files for system ' ...
            'offset calibration.']);
    end
       
    % Produce marker and GRF data objects. 
    marker_data = Data(markers{1});
    marker_data.convert(marker_system);
    marker_data.convertUnits('m');
    grf_data = produceGRF(grfs{1}, grf_system, 0);
    
    % Get the average X/Y/Z location of the calibration weight marker.
    marker_X = mean(marker_data.getColumn([marker_name '_X']));
    marker_Y = mean(marker_data.getColumn([marker_name '_Y'])) - marker_height;
    marker_Z = mean(marker_data.getColumn([marker_name '_Z']));
    
    % Get the average X/Y/Z location of the calibration weight CoP. 
    grf_X = mean(grf_data.getColumn([fp_label 'x']));
    grf_Y = mean(grf_data.getColumn([fp_label 'y']));
    grf_Z = mean(grf_data.getColumn([fp_label 'z']));
    
    % Compute the offsets - these are what should be added to the marker
    % data in order to get it to match the GRF data. 
    X = grf_X - marker_X;
    Y = grf_Y - marker_Y;
    Z = grf_Z - marker_Z;
end

