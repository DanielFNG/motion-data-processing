function [forces, moments] = convertSystem(forces_in, moments_in, system)
% Convert forces & moments to OpenSim co-ordinate system. 
%   Uses knowledge of co-ordinate system in which data was collected as
%   supplied by user.

    % Create output arrays.
    forces = zeros(size(forces_in));
    moments = zeros(size(moments_in));

    % Identify system parameters.
    [mx, ix] = convertSystemIdentifier(system.forward);
    [my, iy] = convertSystemIdentifier(system.up);
    [mz, iz] = convertSystemIdentifier(system.right);

    % Convert coordinate systems. 
    for add = [0, 3]
        forces(:, 1 + add) = mx*forces_in(:, ix + add);
        forces(:, 2 + add) = my*forces_in(:, iy + add);
        forces(:, 3 + add) = mz*forces_in(:, iz + add);
        moments(:, 1 + add) = mx*moments_in(:, ix + add);
        moments(:, 2 + add) = my*moments_in(:, iy + add);
        moments(:, 3 + add) = mz*moments_in(:, iz + add);
    end

end