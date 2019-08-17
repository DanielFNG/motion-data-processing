function grf_data = produceMOT(input_file, system, inclination, save_dir)

% Get the arrays of time, forces and moments.
[time, forces, moments] = readViconTextData(input_file);

% Convert forces and moments to OpenSim co-ordinates.
forces(:, 1:3) = convertSystem(forces(:, 1:3), system);
forces(:, 4:6) = convertSystem(forces(:, 4:6), system);
moments(:, 1:3) = convertSystem(moments(:, 1:3), system);
moments(:, 4:6) = convertSystem(moments(:, 4:6), system);

% Gravity compensation.
[forces, moments] = compensateGravity(forces, moments, inclination);

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

% Motion-base transformation.
grf_data.rotate(0, inclination, 0);

end