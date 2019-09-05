function [forces, moments] = lp4FilterGRFs(...
    left_indices, right_indices, forces, moments, force_freq, ...
    moments_freq, fp_frame_rate)

    if nargin < 7
        fp_frame_rate = 1000;
    end
    dt = 1/fp_frame_rate;
    
    med_filt_frames = 7;

    forces(~left_indices, 1:3) = medfilt1(ZeroLagButtFiltfilt(...
        dt, force_freq, 4, 'lp', forces(~left_indices, 1:3)), med_filt_frames);
    forces(~right_indices, 4:6) = medfilt1(ZeroLagButtFiltfilt(...
        dt, force_freq, 4, 'lp', forces(~right_indices, 4:6)), med_filt_frames);
    moments(~left_indices, 1:3) = medfilt1(ZeroLagButtFiltfilt(...
        dt, moments_freq, 4, 'lp', moments(~left_indices, 1:3)), med_filt_frames);
    moments(~right_indices, 4:6) = medfilt1(ZeroLagButtFiltfilt(...
        dt, moments_freq, 4, 'lp', moments(~right_indices, 4:6)), med_filt_frames);
    
    % Refilter fully to get rid of threshold effect.
    forces = ZeroLagButtFiltfilt(dt, force_freq, 4, 'lp', forces);
    moments = ZeroLagButtFiltfilt(dt, moments_freq, 4, 'lp', moments);

end