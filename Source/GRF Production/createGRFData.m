function grf_data = createGRFData(time, data)
% Constructs header & column labels to combine with data & produce MOT file

initial_time = time(1);
header{1} = sprintf('name not saved');
header{2} = sprintf('datacolumns %i', size(data, 2) + 1);
header{3} = sprintf('datarows %i', size(data, 1));
header{4} = sprintf('range %.2f %.2f', 0.0, time(end) - initial_time);
header{5} = sprintf('endheader');

labels = {'time', ...
    'ground_force1_vx', 'ground_force1_vy', 'ground_force1_vz', ...
    'ground_force1_px', 'ground_force1_py', 'ground_force1_pz', ...
    'ground_force2_vx', 'ground_force2_vy', 'ground_force2_vz', ...
    'ground_force2_px', 'ground_force2_py', 'ground_force2_pz', ...
    'ground_torque1_x', 'ground_torque1_y', 'ground_torque1_z', ...
    'ground_torque2_x', 'ground_torque2_y', 'ground_torque2_z'};

values = [time, data];

grf_data = MOTData(values, header, labels);

end