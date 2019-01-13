function output_file = produceMOT(input_file, output_file)

% Get the time array, forces and moments from the .txt GRF file.
[time, forces, moments] = readGRFTextData(input_file);

% Apply an initial LP filter of 6 Hz.
[forces, moments] = lp4FilterGRFs(forces, moments, 6);

% Apply a threshold of 40N.
[forces, moments] = thresholdGRFs(forces, moments, 40);

% Calculate the CoP data.
cop = calcCOP(forces, moments);

% Refilter to remove the threshold effect.
[forces, moments] = lp4FilterGRFs(forces, moments, 25);

% Rethreshold at a lower cutoff.
[forces, moments] = thresholdGRFs(forces, moments, 2);

% Calculate torques from free moments. 
torques = calcTorques(forces, moments, cop);

% Construct overall data array. 
data = constructGRFDataArray(forces, cop, torques);

% Write .mot file suitable for OpenSim usage. 
if nargin < 2
    [path, name, ~] = fileparts(input_file);
    output_file = [path filesep name '.mot'];
end
writeMOTFile(time, data, output_file)

end