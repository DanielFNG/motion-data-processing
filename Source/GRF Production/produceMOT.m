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

% Initial threshold on the vertical force components. 
forces(forces(:, 2) < 20, 1:3) = 0;
forces(forces(:, 5) < 20, 4:6) = 0;

% Apply initial low pass filters.
[forces, moments] = lp4FilterGRFs(forces, moments, 10, 10);

% Take absolute magnitude of vertical force components to remove negs.
forces(forces(:, 2) < 0, 2) = -forces(forces(:, 2) < 0, 2);
forces(forces(:, 5) < 0, 5) = -forces(forces(:, 5) < 0, 5);

% Apply more low pass filtering.
[forces, moments] = lp4FilterGRFs(forces, moments, 10, 10);

% Threshold the force data.
[left_indices, right_indices] = findThresholdIndices(forces, 40, 20);
[forces, moments] = thresholdGRFs(...
    forces, moments, left_indices, right_indices);

% Process the raw cop data.
cop = processRawCOP(cop, left_indices, right_indices);
[cop_left, cop_right] = findThresholdIndices(forces, 450, 400);
cop = adjustCOP(time, cop, left_indices, cop_left, right_indices, cop_right);
cop(:, 1:6) = -cop(:, 1:6);  % Temporary hard coding weird thing...

% Smoothing step. 
% Smoothing for boundaries at low force values ( < 5-10N)
%[forces, moments] = smoothGRFs(forces, moments);

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