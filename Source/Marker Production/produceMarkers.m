function markers = produceMarkers(input_file, system, offset)

    % Load marker data.
    markers = Data(input_file);
    
    % Convert units to 'm' if they're not in that form already.
    markers.convertUnits('m');
    
    % Convert co-ordinates to OpenSim default.
    markers.convert(system);
    
    % Account for co-ordinate system offsets.
    markers = applyOffsets(markers, offset);

end