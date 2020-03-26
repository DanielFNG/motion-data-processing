function writeStaticData(static, save_dir)
    
    % Write output static file.
    [~, name, ~] = fileparts(static_file);
    static.Static.writeToFile([save_dir filesep name]);
    
end