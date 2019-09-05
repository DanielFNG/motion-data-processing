function [left_indices, right_indices, forces, moments] = ...
    thresholdGRFs(forces, moments, threshold)

left_indices = forces(:, 2) < threshold;
right_indices = forces(:, 5) < threshold;

forces(left_indices, 1:3) = 0; 
moments(left_indices, 1:3) = 0;
forces(right_indices, 4:6) = 0;
moments(right_indices, 4:6) = 0;

end