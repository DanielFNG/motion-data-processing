function processStaticData(static_folder, rotations, save_dir)
% Produce static files.
% --
% static_folder - folder of static .trc files from Nexus 
% rotations - {x,y,z} rotations which get data in OpenSim coord system
% save_dir - directory to save resultant static files 

% Get the static files.
static_files = dir([static_folder filesep '*.trc']);
n_static = length(static_files);

for i=1:n_static
    % Produce static data.
    static_input = [static_folder filesep static_files(i).name];
    static = produceStatic(static_input);
    
    % Rotate.
    static.rotate(rotations{:});
    
    % Write output static file.
    static_output = [save_dir filesep static_files(i).name];
    static.writeToFile(static_output);
end

end