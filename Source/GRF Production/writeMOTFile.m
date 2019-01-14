function writeMOTFile(time, data, output_file)

initial_time = time(1);
fid = fopen(output_file, 'w');
fprintf(fid, 'name %s\n', output_file);
fprintf(fid, 'datacolumns %i\n', size(data, 2) + 1);
fprintf(fid, 'datarows %i\n', size(data, 1));
fprintf(fid, 'range %.2f %.2f\n', 0.0, time(end) - initial_time);
fprintf(fid, 'endheader\n');
labels = {'time', ...
    'ground_force1_vx', 'ground_force1_vy', 'ground_force1_vz', ...
    'ground_force1_px', 'ground_force1_py', 'ground_force1_pz', ...
    'ground_force2_vx', 'ground_force2_vy', 'ground_force2_vz', ...
    'ground_force2_px', 'ground_force2_py', 'ground_force2_pz', ...
    'ground_torque1_x', 'ground_torque1_y', 'ground_torque1_z', ...
    'ground_torque2_x', 'ground_torque2_y', 'ground_torque2_z'};
for i=1:size(data, 2) + 1
    fprintf(fid, '%s\t', labels{i});
end
fprintf(fid, '\n');
for i=1:size(data, 1)
    fprintf(fid, '%.6f\t', time(i) - initial_time);
    for j=1:size(data, 2)
        fprintf(fid, '%.6f\t', data(i,j));
    end
    fprintf(fid, '\n');
end
fclose(fid);

end