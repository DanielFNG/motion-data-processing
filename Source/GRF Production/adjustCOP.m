function cop = adjustCOP(cop, grf_l, cop_l, grf_r, cop_r)

    full = 1:length(cop(:, 1));
    grfs = {grf_l, grf_r};
    cops = {cop_l, cop_r};
    
    for side=1:2
        combined = setdiff(full, grfs{side});
        trust = setdiff(full, cops{side});
        
        % Segmentation.
        jumps = [0, find(diff(combined) ~= 1), length(combined)];
        
        switch side
            case 1
                indices = [1, 3];
            case 2 
                indices = [4, 6];
        end
        
        for d = indices
            for cycle = 1:(length(jumps) - 1)
                combined_cycle = combined(jumps(cycle) + 1:jumps(cycle + 1));
                trusted_cycle = intersect(combined_cycle, trust);
                cop(combined_cycle(1):trusted_cycle(1), d) = ...
                    cop(trusted_cycle(1), d);
                cop(trusted_cycle(end):combined_cycle(end), d) = ...
                    cop(trusted_cycle(end), d);
                cop(combined_cycle(end) + 1:jumps(cycle + 1), d) = 0;
            end
        end
    end

end