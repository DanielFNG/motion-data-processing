function cop = calcCOP(forces, moments)

% Offset between plate and foot.
%h = 0.005;
h = 0;  % Have this for now - having the 0.005 doesn't seem to change that much, 
        % and want to be sure about the signage of the force in the below 
        % equations before putting it in.

% Create array to store CoP data.
cop = zeros(size(forces, 1), 6);

% Perform CoP calculations.
for i=0:1
    index = i*3; % Add 0 for left foot calcs, 3 for right.
    cop(:, 1 + index) = (h*forces(:, 1 + index) + moments(:, 3 + index))./ ...
        forces(:, 2 + index);
    cop(:, 3 + index) = (h*forces(:, 3 + index) + moments(:, 1 + index))./ ...
        forces(:, 2 + index);
end

% Set NaN's to 0.
cop(isnan(cop)) = 0;

end