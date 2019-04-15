function processStaticData(save_dir, static_file, rotations, left_handed)
    
    static = produceStatic(static_file);
    
    % Rotate.
    static.rotate(rotations{:}, left_handed);
    
    % Write output static file.
    [~, name, ~] = fileparts(static_file);
    static.writeToFile([save_dir filesep name]);
    
end