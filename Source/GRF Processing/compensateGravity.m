function [forces, moments] = compensateGravity(forces, moments, inclination)
% Compensate for gravitational forces acting on the treadmill at a provided
% inclination. Requires the gravity compensation matrix. 

    path = [getenv('MDP_HOME') filesep 'Source' filesep ...
        'Motion Compensation' filesep 'UoE_GaitLab_GravityCompensation.mat'];
    gcomp = getGravityCompensationMatrix(path, inclination);
    
    for i=1:3
        forces(:, i) = forces(:, i) - gcomp(1, i);
        forces(:, i + 3) = forces(:, i + 3) - gcomp(3, i);
        moments(:, i) = moments(:, i) - gcomp(2, i);
        moments(:, i + 3) = moments(:, i + 3) - gcomp(4, i);
    end

end
