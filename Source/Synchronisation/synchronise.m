function [new_source, new_sink] = synchronise(source_file, sink_file, delay)

source = Data(source_file);
sink = Data(sink_file);

sink.Timesteps = sink.Timesteps + delay;
initial_sink = sink.Timesteps(1);
final_sink = sink.Timesteps(end);
initial_source = source.Timesteps(1);
final_source = source.Timesteps(end);

acceptable_source_frames = source.Frames(...
    source.Timesteps > initial_sink & source.Timesteps < final_sink);
acceptable_sink_frames = sink.Frames(...
    sink.Timesteps > initial_source & sink.Timesteps < final_source);
common_frames = intersect(acceptable_source_frames, acceptable_sink_frames);

new_source = source.slice(common_frames);
new_sink = sink.slice(common_frames);

end

