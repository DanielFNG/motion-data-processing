function emg_data = produceEMG(input_file)

    % Get data from raw file.
    [time, emg] = readViconEMGData(input_file);
    
    % Process each EMG signal.
    for i = 1:size(emg, 2)
        emg(:, i) = processEMGSignal(emg(:, i));
    end
    
    % Write .mot file suitable for OpenSim usage.
    emg_data = createEMGData(time, emg);

end