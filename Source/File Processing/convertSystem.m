function data_out = convertSystem(data_in, system)
% Convert forces & moments to OpenSim co-ordinate system. 
%   Uses knowledge of co-ordinate system in which data was collected as
%   supplied by user.

    % Create output arrays.
    data_out = zeros(size(data_in));

    % Identify system parameters.
    [mx, ix] = convertSystemIdentifier(system.forward);
    [my, iy] = convertSystemIdentifier(system.up);
    [mz, iz] = convertSystemIdentifier(system.right);

    % Convert coordinate systems.
    data_out(:, 1 + add) = mx*data_in(:, ix);
    data_out(:, 2 + add) = my*data_in(:, iy);
    data_out(:, 3 + add) = mz*data_in(:, iz);

end