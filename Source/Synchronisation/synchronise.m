function [new_source, new_sink] = synchronise(source, sink, delay)

sink_timesteps = sink.getColumn('time') + delay;
source_timesteps = source.getColumn('time');

sink_timesteps = sink_timesteps - sink_timesteps(1);
source_timesteps = source_timesteps - source_timesteps(1);

earliest_start = max(sink_timesteps(1), source_timesteps(1));
latest_finish = min(sink_timesteps(end), source_timesteps(end));

source_frames = source.getFrames();
sink_frames = sink.getFrames();

source_frames = source_frames(...
    source_timesteps >= earliest_start & source_timesteps <= latest_finish);
sink_frames = sink_frames(...
    sink_timesteps >= earliest_start & sink_timesteps <= latest_finish);


source.setColumn('time', source_timesteps);
sink.setColumn('time', sink_timesteps);
new_source = source.slice(source_frames);
new_sink = sink.slice(sink_frames);

end

