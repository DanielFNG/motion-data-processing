function grf_data = produceMOT(input_file, save_dir)

% Get the time array, forces and moments from the .txt GRF file.
[time, forces, moments] = readGRFTextData(input_file);

% Apply an initial LP filter of 6 Hz.
[forces, moments] = lp4FilterGRFs(forces, moments, 6);

% Apply a threshold of 10N.
[forces, moments] = thresholdGRFs(forces, moments, 10);

% Refilter to remove the threshold effect.
[forces, moments] = lp4FilterGRFs(forces, moments, 25);

% Rethreshold at a lower cutoff.
[forces, moments] = thresholdGRFs(forces, moments, 2);

% Calculate the CoP data.
cop = calcCOP(forces, moments);

% Process the CoP data.
cop = processCOP(cop, forces, moments);

% Calculate torques from free moments. 
torques = calcTorques(forces, moments, cop);

% Construct overall data array. 
data = constructGRFDataArray(forces, cop, torques);

% Write .mot file suitable for OpenSim usage. 
[~, name, ~] = fileparts(input_file);
output_file = [save_dir filesep name '.mot'];
grf_data = createGRFData(time, data, output_file);

end