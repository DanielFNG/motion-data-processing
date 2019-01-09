function cycles = segmentGRF(side, cutoff, grf_file)

    minimum_increase = 5;

    motion_data = Data(grf_file);

    if strcmp(side, 'left')
        str = 'ground_force2_vy';
    else
        str = 'ground_force1_vy';
    end
    
    indices = find(motion_data.getColumn(str) > cutoff);
    cycles = {};
    k = 1;
    start = 1;
    for j=1:length(indices) - 1
        if indices(j + 1) > indices(j) + minimum_increase
            cycles{k} = indices(start):indices(j + 1) - 1; %#ok<AGROW>
            k = k + 1;
            start = j + 1;
        end
    end

end