function cop = processRawCOP(...
    cop, left_indices, right_indices, cop_left, cop_right)

    cop(~cop_left, 1:3) = medfilt1(ZeroLagButtFiltfilt(...
        1/1000, 6, 4, 'lp', cop(~cop_left, 1:3)), 7);
    cop(~cop_right, 4:6) = medfilt1(ZeroLagButtFiltfilt(...
        1/1000, 6, 4, 'lp', cop(~cop_right, 4:6)), 7);
    cop(left_indices, 1:3) = 0; 
    cop(right_indices, 4:6) = 0;

end