function times = processEMGData(save_dir, emg_file, feet, save_folder)

    % Load EMG data.
    emg = produceEMG(emg_file);
    
    % Segmentation if necessary.
    if nargin == 4
        for i=1:length(feet)
            times = segmentEMG(feet{i}, emg, save_dir, save_folder);
        end
    else
        % Write .txt file.
        [~, name, ~] = fileparts(emg_file);
        emg.writeToFile([save_dir filesep name]);
        times = [];
    end

end