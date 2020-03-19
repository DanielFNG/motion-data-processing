function markers = applyOffsets(markers, offset)

    % Get the X, Y & Z labels.
    func = @(y) (@(x) strcmpi(x(end), y));
    labels{1} = markers.Labels(cellfun(func('x'), markers.Labels));
    labels{2} = markers.Labels(cellfun(func('y'), markers.Labels));
    labels{3} = markers.Labels(cellfun(func('z'), markers.Labels));
    
    % Group the offsets.
    offsets = [offset.x, offset.y, offset.z];

    % Step through the labels applying the offsets.
    for i=1:length(labels{1})
        for j=1:3
            coordinates = markers.getColumn(labels{j}{i});
            coordinates = coordinates + offsets(j);
            markers.setColumn(labels{j}{i}, coordinates);
        end
    end
    
end