function [new_source, new_sink] = synchronise(source_file, sink_file, delay)

sink.Timesteps = sink.Timesteps + delay;

earliest_start = max(sink.Timesteps(1), source.Timesteps(1));
latest_finish = min(sink.Timesteps(end), source.Timesteps(end));

source_frames = source.Frames(...
    source.Timesteps >= earliest_start & source.Timesteps <= latest_finish);
sink_frames = sink.Frames(...
    sink.Timesteps >= earliest_start & sink.Timesteps <= latest_finish);

new_source = source.slice(source_frames);
new_sink = sink.slice(sink_frames);

end

