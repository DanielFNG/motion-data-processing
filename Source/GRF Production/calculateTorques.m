function torques = calculateTorques(forces, moments, cop)
% Compute torque data given input forces, moments & CoP data. 

torques = zeros(size(forces,1), 6);

for i=0:1
    index = i*3;
    torques(:, 2 + index) = moments(:, 2 + index) - ...
        (cop(:, 3 + index).*forces(:, 1 + index)) + ...
        (cop(:, 1 + index).*forces(:, 3 + index));
end


end