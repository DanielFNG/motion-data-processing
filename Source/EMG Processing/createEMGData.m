function emg_data = createEMGData(time, data, filename)

    labels{1} = 'time';
    for i = 2:size(data, 2)
        labels{i} = ['EMG ' num2str(i)];
    end
    
    values = [time, data];
    
    [~, name, ~] = fileparts(filename);
    emg_data = TXTData(values, {}, labels, name);

end