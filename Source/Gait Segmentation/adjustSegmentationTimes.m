function [marker_frames, grf_frames] = ...
    adjustSegmentationTimes(segmentation_times, grfs, kinematics)

    grf_time = grfs.getColumn('time');
    kin_time = kinematics.getColumn('time');
    n_segments = length(segmentation_times);
    marker_frames = cell(n_segments, 1);
    grf_frames = cell(n_segments, 1);

    for i=1:n_segments
        start = segmentation_times{i}(1);
        finish = segmentation_times{i}(end);
        suitable_grf = grf_time(grf_time >= start & grf_time <= finish);
        suitable_kin = kin_time(kin_time >= start & kin_time <= finish);
        min_time = max(suitable_grf(1), suitable_kin(1));
        max_time = min(suitable_grf(end), suitable_kin(end));
        marker_frames{i} = kin_time >= min_time & kin_time <= max_time;
        grf_frames{i} = grf_time >= min_time & grf_time <= max_time;
    end

end

