function [forces, moments] = ...
    lp4FilterGRFs(forces, moments, frequency, fp_frame_rate)

    if nargin < 4
        fp_frame_rate = 600;
    end
    dt = 1/fp_frame_rate;

    forces(:, 1:6) = ...
        ZeroLagButtFiltfilt(dt, frequency, 4, 'lp', forces(:, 1:6));
    moments(:, 1:6) = ...
        ZeroLagButtFiltfilt(dt, frequency, 4, 'lp', moments(:, 1:6));

end