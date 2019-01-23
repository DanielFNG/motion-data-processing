function cycles = segmentMarkers(side, markers_file)

    motion_data = Data(markers_file);

    if strcmp(side, 'left')
        str = 'L_MTP1';
    else
        str = 'R_MTP1';
    end
    
    [~, indices] = findpeaks(motion_data.getColumn(str));
    n_cycles = length(indices) - 1;
    cycles = cell(1, n_cycles);
    
    for i=1:n_cycles
        cycles{i} = motion_data.Timesteps(indices(i):indices(i+1) - 1);
    end

end