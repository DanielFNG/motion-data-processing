function cop = adjustCOP(time, cop, grf_l, cop_l, grf_r, cop_r)

    full = 1:length(cop(:, 1));
    grfs = {grf_l, grf_r};
    cops = {cop_l, cop_r};
    
    for side=1:2
        combined = setdiff(full, grfs{side});
        trust = setdiff(full, cops{side});
        
        % Segmentation.
        jumps = find(diff(combined) ~= 1);
        if combined(1) == 1
            jumps = [0 jumps]; %#ok<*AGROW>
        end
        jumps = [jumps combined(end)];
        
        for d = [1, 3, 4, 6]
            for cycle = 1:(length(jumps) - 1)
                combined_cycle = jumps(cycle) + 1:jumps(cycle + 1);
                trusted_cycle = intersect(combined_cycle, trust);
                cop(combined_cycle, d) = interp1(...
                    time(trusted_cycle), ...
                    cop(trusted_cycle, d), ...
                    time(combined_cycle), 'linear', 'extrap');
            end
        end
    end

end