function cop = processRawCOP(cop, left_indices, right_indices)

    full = 1:length(cop(:, 1));
    left = setdiff(full, left_indices);
    right = setdiff(full, right_indices);
    cop(left, 1:3) = ZeroLagButtFiltfilt(...
        1/1000, 6, 4, 'lp', cop(left, 1:3));
    cop(right, 4:6) = ZeroLagButtFiltfilt(...
        1/1000, 6, 4, 'lp', cop(right, 4:6));
    cop(left_indices, 1:3) = 0; 
    cop(right_indices, 4:6) = 0;

end