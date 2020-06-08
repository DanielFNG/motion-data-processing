function [time, emg] = readViconEMGData(input_file)
%   Read & store EMG data from Vicon produced text files.
%   Resulting fgormat is the same as in readTreadmillTextData.

    % Open the input file.
    id = fopen(input_file);
    
    % Disregard the header, comprising the first 3 frames.
    for i=1:3
        fgetl(id);
    end
    
    % Get the number of columns by reading labels in.
    n_cols = length(strsplit(fgetl(id), '\t'));
    
    % Disregard the next line.
    fgetl(id);
    
    % Parse values.
    values = cell2mat(textscan(id, repmat('%f', 1, n_cols)));
    
    % Close the file.
    fclose(id);
    
    % Create the various arrays. 
    n_frames = size(values, 1);
    time = 0.001*(0:n_frames - 1)';
    emg = values(:, 3:end);
    
end