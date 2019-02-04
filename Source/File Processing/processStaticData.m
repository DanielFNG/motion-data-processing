function processStaticData(static_file, rotations, save_dir)
    
    static = produceStatic(static_file);
    
    % Rotate.
    static.rotate(rotations{:});
    
    % Write output static file.
    [~, name, ~] = fileparts(static_file);
    static.writeToFile([save_dir filesep name]);
    
end