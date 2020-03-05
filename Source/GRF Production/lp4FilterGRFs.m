function [forces, moments] = lp4FilterGRFs(forces, moments, force_freq, ...
    moments_freq, left_indices, right_indices)
% Filter force & moment data using a low pass 4th order Butterworth filter. 

    fp_frame_rate = 1000;
    dt = 1/fp_frame_rate;
    
    if nargin < 6
        left_indices = zeros(1, size(forces, 1));
        right_indices = left_indices;
    else
        
    end

    forces(~left_indices, 1:3) = ZeroLagButtFiltfilt(...
        dt, force_freq, 4, 'lp', forces(~left_indices, 1:3));
    forces(~right_indices, 4:6) = ZeroLagButtFiltfilt(...
        dt, force_freq, 4, 'lp', forces(~right_indices, 4:6));
    moments(~left_indices, 1:3) = ZeroLagButtFiltfilt(...
        dt, moments_freq, 4, 'lp', moments(~left_indices, 1:3));
    moments(~right_indices, 4:6) = ZeroLagButtFiltfilt(...
        dt, moments_freq, 4, 'lp', moments(~right_indices, 4:6));

end