function cop = calculateCOP(forces, moments, left_indices, right_indices)

    % Initialise CoP array. 
    cop = zeros(size(forces));

    % Treadmill true origin information.
    x_left = -0.25;
    x_right = 0.25;
    y = 0.000001;
    z = 0;
    
    % Compute moments at true treadmill origin.
    true_x1 = -moments(:, 1) + y*forces(:, 3) + x_left*forces(:, 2); 
    true_x2 = -moments(:, 4) + y*forces(:, 6) + x_right*forces(:, 5);
    true_z1 = moments(:, 3) + z*forces(:, 2) - y*forces(:, 1);
    true_z2 = moments(:, 6) + z*forces(:, 5) - y*forces(:, 4);
        
    % Compute CoP for both force plates.
    cop(:, 1) = (1./forces(:, 2)).*(true_z1 + y*forces(:, 1));
    cop(:, 3) = (1./forces(:, 2)).*(true_x1 + y*forces(:, 3));
    cop(:, 4) = (1./forces(:, 5)).*(true_z2 + y*forces(:, 4));
    cop(:, 6) = (1./forces(:, 5)).*(true_x2 + y*forces(:, 6));
    
    % Assign 0 values to swing phase data. 
    cop(left_indices, 1:3) = 0;
    cop(right_indices, 4:6) = 0;

end