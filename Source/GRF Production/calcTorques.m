function torques = calcTorques(forces, moments, cop)

torques = zeros(size(forces,1), 6);

for i=0:1
    index = i*3;
    torques(:, 2 + index) = moments(:, 2 + index) - ...
        (cop(:, 3 + index).*forces(:, 1 + index)) + ...
        (cop(:, 1 + index).*forces(:, 3 + index));
end

end