function [forces, moments] = thresholdGRFs(forces, moments, left, right)

    forces(left, 2) = 0;
    forces(right, 5) = 0;
    %forces(left, 1:3) = 0;
    %forces(right, 4:6) = 0;
    %moments(left, 1:3) = 0;
    %moments(right, 4:6) = 0;

end