function corrected_positions = accountForMovingReferenceFrame(...
    positions, time, speed)
% Transform data to account for a moving reference frame (e.g. walking on
% treadmill).
%
% Input: 
%   positions - array of positions
%   time - array of times (e.g. positions at times given by time)
%   speed - array of speed (e.g. speed at times given by time)
%
% Output:
%   speed-adjusted positions array
    
    % Compute the distance travelled due to the moving reference frame
    % between each pair of timesteps.
    dx = speed(1:end-1).*(time(2:end) - time(1:end-1));
    
    % Create and initialise corrected positions array.
    corrected_positions = zeros(size(positions));
    corrected_positions(1) = positions(1);
    
    % Iteratively compute the corrected positions.
    for i=2:length(corrected_positions)
        corrected_positions(i) = corrected_positions(i-1) - ...
            positions(i-1) + positions(i) + dx(i-1);
    end

end
