function produceGravityCompensationMatrix(dir, init, inc, fin, system, savename)

    [n, files] = dirNoDots(dir);
    
    key_set = init:inc:fin;
    value_set = 1:n;

    if n ~= length(key_set)
        error('Number of files does not correspond to number of increments.');
    end
    
    g_comp = zeros(4, 3);
    M = cell(1, n);

    for i=1:n
        % Get the arrays of time, forces and moments.
        [~, forces, moments] = readViconForceData(files{i});

        % Convert forces and moments to OpenSim co-ordinates.
        forces(:, 1:3) = convertSystem(forces(:, 1:3), system);
        forces(:, 4:6) = convertSystem(forces(:, 4:6), system);
        moments(:, 1:3) = convertSystem(moments(:, 1:3), system);
        moments(:, 4:6) = convertSystem(moments(:, 4:6), system);
        
        % Assign values to the gravity compensation matrix.
        g_comp(1, 1:3) = mean(forces(:, 1:3));
        g_comp(2, 1:3) = mean(moments(:, 1:3));
        g_comp(3, 1:3) = mean(forces(:, 4:6));
        g_comp(4, 1:3) = mean(moments(:, 4:6));
        
        % Store this as part of a value set.
        M{i} = g_comp; 
        
    end
    
    % Create the map.
    conv = containers.Map(key_set, value_set); 
    
    % Save the map and gravity compensation cell array. 
    save(savename, 'M', 'conv');
    
end