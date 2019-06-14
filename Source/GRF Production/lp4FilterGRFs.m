function [forces, moments] = ...
    lp4FilterGRFs(forces, moments, force_freq, moments_freq, fp_frame_rate)

    if nargin < 5
        fp_frame_rate = 1000;
    end
    dt = 1/fp_frame_rate;

    forces(:, 1:6) = ...
        ZeroLagButtFiltfilt(dt, force_freq, 4, 'lp', forces(:, 1:6));
    moments(:, 1:6) = ...
        ZeroLagButtFiltfilt(dt, moments_freq, 4, 'lp', moments(:, 1:6));

end