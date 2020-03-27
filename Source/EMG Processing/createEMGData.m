function emg_data = createEMGData(time, data)

    labels{1} = 'time';
    for i = 2:size(data, 2)
        labels{i} = ['EMG ' num2str(i)];
    end
    
    values = [time, data];
    
    emg_data = TXTData(values, {}, labels);

end