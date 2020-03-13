function grf_data = produceMOT(input_file, system, inclination)
% Read & process raw force data from Vicon to produce an OpenSim MOT file. 

% Fixed parameters. 
force_freq = 6;  % Force filtering frequency
moment_freq = 6;  % Moment filtering frequency
lower = 0;  % Lower force threshold 
upper = 40;  % Upper force threshold (see findThresholdIndices)
trust = 100;  % CoP trust region 

% Get the arrays of time, forces and moments.
[time, forces, moments, ~] = readViconForceData(input_file);

% Convert quantities to OpenSim co-ordinates.
forces(:, 1:3) = convertSystem(forces(:, 1:3), system);  % Left
forces(:, 4:6) = convertSystem(forces(:, 4:6), system);  % Right
moments(:, 1:3) = convertSystem(moments(:, 1:3), system);
moments(:, 4:6) = convertSystem(moments(:, 4:6), system);

% Gravity compensation.
[forces, moments] = compensateGravity(forces, moments, inclination);

% Apply initial low pass filters.
[forces, moments] = lp4FilterGRFs(forces, moments, force_freq, moment_freq);

% Threshold the force data.
[left_indices, right_indices] = findThresholdIndices(forces, upper, lower);
forces(left_indices, 1:3) = 0;
forces(right_indices, 4:6) = 0;
moments(left_indices, 1:3) = 0;
moments(right_indices, 4:6) = 0;

% Process the raw cop data.
cop = calculateCOP(forces, moments, left_indices, right_indices);
cop_left = find(forces(:, 2) < trust);
cop_right = find(forces(:, 5) < trust);
[cop, discard, from] = adjustCOP(...
    cop, left_indices, cop_left, right_indices, cop_right);

% Discard unusable data if necessary.
if discard
    time(from:end) = [];
    forces(from:end, :) = [];
    moments(from:end, :) = [];
    cop(from:end, :) = [];
end

% Calculate torques from free moments. 
torques = calculateTorques(forces, moments, cop);

% Construct overall data array. 
data = constructGRFDataArray(forces, cop, torques);

% Write .mot file suitable for OpenSim usage.
grf_data = createGRFData(time, data);

% Motion-base transformation.
grf_data.rotate(0, inclination, 0);

end