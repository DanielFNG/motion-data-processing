function processStaticData(static_folder, rotations, save_dir)
% Produce static files.
% --
% static_folder - folder of static .trc files from Nexus 
% rotations - {x,y,z} rotations which get data in OpenSim coord system
% save_dir - directory to save resultant static files 

n_static = dir([static_folder filesep '*.trc']);
for i=1:n_static
    static_input = [static_folder filesep static_files(i).name];
    static_output = [save_dir filesep static_files(i).name];
    static = produceStatic(static_input);
    static.rotate(rotations{:});
    static.writeToFile(static_output);
end

end