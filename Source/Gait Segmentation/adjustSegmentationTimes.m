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
        marker_frames{i} = kin_time >= start & kin_time <= finish;
        grf_frames{i} = grf_time >= start & grf_time <= finish;
    end

end

