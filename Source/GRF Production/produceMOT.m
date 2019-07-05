function grf_data = produceMOT(input_file, system, save_dir)

% Get the arrays of time, forces and moments.
[time, forces, moments] = readViconTextData(input_file);

% Convert forces and moments to OpenSim co-ordinates.
[forces, moments] = convertSystem(forces, moments, system);

% Apply an initial LP filter of 6 Hz.
[forces, moments] = lp4FilterGRFs(forces, moments, 6, 6);

% Apply a threshold of 10N.
[forces, moments] = thresholdGRFs(forces, moments, 10);

% Refilter to remove the threshold effect.
[forces, moments] = lp4FilterGRFs(forces, moments, 25, 25);

% Rethreshold at a lower cutoff.
[forces, moments] = thresholdGRFs(forces, moments, 2);

% Calculate the CoP data.
cop = calcCOP(forces, moments);

% Process the CoP data.
%[cop, forces, moments, time] = processCOP(cop, forces, moments, time);

% Calculate torques from free moments. 
torques = calcTorques(forces, moments, cop);

% Construct overall data array. 
data = constructGRFDataArray(forces, cop, torques);

% Write .mot file suitable for OpenSim usage. 
[~, name, ~] = fileparts(input_file);
output_file = [save_dir filesep name '.mot'];
grf_data = createGRFData(time, data, output_file);

end