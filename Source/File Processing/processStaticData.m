function processStaticData(save_dir, static_file, system)
    
    % Produce static TRC object. 
    static = produceStatic(static_file);
    
    % Convert to OpenSim co-ordinates.
    static.convert(system);
    
    % Write output static file.
    [~, name, ~] = fileparts(static_file);
    static.writeToFile([save_dir filesep name]);
    
end