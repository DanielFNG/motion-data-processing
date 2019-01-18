function mid = getMidpoint(osim_data, marker1, marker2)

coords = {'x', 'y', 'z'};
mid = zeros(osim_data.NFrames, 3);
for i = 1:3
    direction = coords{i};
    m1 = osim_data.getColumn([marker1 '_' direction]);
    m2 = osim_data.getColumn([marker2 '_' direction]);
    mid(:, i) = (m1 + m2)/2;
end