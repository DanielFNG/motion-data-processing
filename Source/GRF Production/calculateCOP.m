function cop = calculateCOP(forces, moments, left_indices, right_indices)

    z = 0; % height offset
    cop = zeros(size(forces));
    
    for i=0:1
        cop(:, i + 1) = (1./forces(:, i + 2)).* ...
            (moments(:, i + 3) - z*forces(:, i + 1));
        cop(:, i + 3) = -(1./forces(:, i + 2)).* ...
            (moments(:, i + 1) + z*forces(:, i + 3));
    end
    
    cop(left_indices, 1:3) = 0;
    cop(right_indices, 4:6) = 0;

end