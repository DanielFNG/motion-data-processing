function [multiplier, index] = convertSystemIdentifier(id)

if strcmp(id(1), '+')
    multiplier = 1;
elseif strcmp(id(1), '-')
    multiplier = -1;
else
    error('Invalid system identification.');
end

switch lower(id(2))
    case 'x'
        index = 1;
    case 'y'
        index = 2;
    case 'z'
        index = 3;
end

end