function data = constructGRFDataArray(forces, cop, torques)
% Concatenate left & right foot data in the usual manner for printing to
% OpenSim compatible files. 

data = [forces(:, 4:6) cop(:, 4:6) ...
    forces(:, 1:3) cop(:, 1:3) ...
    torques(:, 4:6) ...
    torques(:, 1:3)];

end