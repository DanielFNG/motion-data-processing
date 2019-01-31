function [missing_from_start, missing_from_end] = returnMissingFrames(trc_file)

    missing_from_start = 0;
    missing_from_end = 0;

    [~, labels, str_values] = Data.splitTRC(trc_file);
    n_cols = length(labels);
    for i=1:size(str_values, 2)
        if size(str_values{1, i}, 2) ~= n_cols
            missing_from_start = missing_from_start + 1;
        else
            break;
        end
    end
    
    for i=size(str_values, 2):-1:1
        if size(str_values{1, i}, 2) ~= n_cols
            missing_from_end = missing_from_end + 1;
        else
            break;
        end
    end

end