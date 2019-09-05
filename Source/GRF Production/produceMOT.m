function grf_data = produceMOT(input_file, system, inclination, save_dir)

% Get the arrays of time, forces and moments.
[time, forces, moments, cop] = readViconTextData(input_file);

% Convert quantities to OpenSim co-ordinates.
forces(:, 1:3) = convertSystem(forces(:, 1:3), system);  % Left
forces(:, 4:6) = convertSystem(forces(:, 4:6), system);  % Right
moments(:, 1:3) = convertSystem(moments(:, 1:3), system);
moments(:, 4:6) = convertSystem(moments(:, 4:6), system);
cop(:, 1:3) = convertSystem(cop(:, 1:3), system);
cop(:, 4:6) = convertSystem(cop(:, 4:6), system);

% Gravity compensation.
[forces, moments] = compensateGravity(forces, moments, inclination);

% Apply initial low pass filters.
[forces, moments] = lp4FilterGRFs(forces, moments, 10, 10);

% Threshold the force data.
[left_indices, right_indices] = findThresholdIndices(forces, 40, 2);
[forces, moments] = thresholdGRFs(forces, moments, left_indices, right_indices);

% Process the raw cop data.
cop = processRawCOP(cop, left_indices, right_indices);

% Temporary hard coding weird thing...
cop(:, 1:6) = -cop(:, 1:6);

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