function [forces, moments] = thresholdGRFs(forces, moments, threshold)

right_indices = forces(:, 2) < threshold;
left_indices = forces(:, 5) < threshold;

forces(right_indices, 1:3) = 0; 
moments(right_indices, 1:3) = 0;
forces(left_indices, 4:6) = 0;
moments(left_indices, 4:6) = 0;
end