function [cop, discard_end, from, discard_start, to] = adjustCOP(...
    cop, grf_l, cop_l, grf_r, cop_r)
% This function adjust CoP data collected at low force values due to the
% inherent noise and inaccuracy of the signal in these conditions. 
%
% Input variables:
%                   - cop (6D CoP data)
%                   - grf_l (indices at which left foot is in stance)
%                   - grf_r (indices at which right foot is in stance)
%                   - cop_l (indices at which left foot data is trusted)
%                   - cop_r (indices at which right foot data is trusted)
%
% Output:
%                   - modified cop data, where we set the cop in the
%                     untrusted region to be equal to the last recorded
%                     trusted value

    full = 1:length(cop(:, 1));
    grfs = {grf_l, grf_r};
    cops = {cop_l, cop_r};
    discard_end = false;
    from = length(cop(:, 1));
    discard_start = false;
    to = 1;
    
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
                if cycle == length(jumps) - 1 && isempty(trusted_cycle)
                    discard_end = true;
                    from = min(from, combined_cycle(1));
                elseif cycle == 1 && isempty(trusted_cycle)
                    discard_start = true;
                    to = max(to, combined_cycle(end));
                else
                    cop(combined_cycle(1):trusted_cycle(1), d) = ...
                        cop(trusted_cycle(1), d);
                    cop(trusted_cycle(end):combined_cycle(end), d) = ...
                        cop(trusted_cycle(end), d);
                    cop(combined_cycle(end) + 1:jumps(cycle + 1), d) = 0;
                end
            end
        end
    end

end