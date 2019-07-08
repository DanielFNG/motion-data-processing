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
    if size(data_out, 1) < size(data_out, 2)
        data_out(1, :) = mx*data_in(ix, :);
        data_out(2, :) = my*data_in(iy, :);
        data_out(3, :) = mz*data_in(iz, :);
    else
        data_out(:, 1) = mx*data_in(:, ix);
        data_out(:, 2) = my*data_in(:, iy);
        data_out(:, 3) = mz*data_in(:, iz);
    end

end