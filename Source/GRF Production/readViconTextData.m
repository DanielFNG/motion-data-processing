function [time, forces, moments] = readViconTextData(input_file)
%   Read & store forces/moments from Vicon produced .txt file.
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
    forces(:, 1:3) = values(:, 3:5);
    forces(:, 4:6) = values(:, 12:14);
    moments(:, 1:3) = values(:, 6:8);  % Conversion from Nmm to Nm.
    moments(:, 4:6) = values(:, 15:17);
    
    % Convert moments from Nmm to Nm. 
    moments = 0.001*moments;
    
end