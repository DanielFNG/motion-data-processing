function processStaticData(static_file, rotations, save_dir)
    
    static = produceStatic(static_file);
    
    % Rotate.
    static.rotate(rotations{:});
    
    % Write output static file.
    [~, name, ext] = fileparts(static_file);
    static.writeToFile([save_dir filesep name ext]);
    
end