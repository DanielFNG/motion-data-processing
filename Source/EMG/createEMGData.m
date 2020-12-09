function emg_data = createEMGData(time, data)

    labels{1} = 'time';
    for i = 1:size(data, 2)
        labels{i + 1} = ['EMG ' num2str(i)];
    end
    
    values = [time, data];
    
    emg_data = TXTData(values, {}, labels);

end