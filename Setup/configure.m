function configure()
% Adds the appropriate source directories to the Matlab path. 

% Change to the home directory.
cd('..');

% Checks if startup.m file exists, if not one is created in matlabroot if we 
% have access to it, or to the 'Setup/startup' folder of this directory 
% otherwise, if yes the existing one is appended to.
if isempty(which('startup.m'))
    [fileID,~] = fopen([matlabroot filesep 'startup.m'], 'w');
    if fileID == -1
        disp(['Attempted to create startup.m file in matlabroot, but' ...
            ' access was denied. Created it in setup\startup folder instead.' ...
            ' Consider changing this as having the startup.m file tied' ...
            ' to a repository can be undesirable.']);
        mkdir(['Setup' filesep 'startup']);
        [fileID,~] = fopen(['Setup' filesep 'startup' filesep 'startup.m'], 'w');
        flag = 1;
    else
        flag = 0;
    end
    fprintf(fileID, '%s', ['setenv(''MDP_HOME'', ''' pwd ''');']);
else
    fileID = fopen(which('startup.m'), 'a');
    if fileID == -1
        disp(['Attempted to open existing startup.m file in ' ...
            'matlabroot, but access was denied. Please rerun this ' ...
            'script after running Matlab as an administrator.']);
        cd('Setup');
        return
    end
    fprintf(fileID, '\n%s', ['setenv(''MDP_HOME'', ''' pwd ''');']);
	flag = -1;
end

% Modify the Matlab path to include the source folder.
addpath(genpath('Source'));
addpath(genpath('GUI'));

% Originally setup was also added to the path, but this is a terrible idea
% since this script uses the assumption of being in the setup folder!!
% Instead I added a startup folder to the setup folder and added this to
% the path only.
if flag == 1
    addpath(genpath([getenv('MDP_HOME') filesep 'Setup' filesep 'startup']));
elseif flag == 0
    addpath(matlabroot);
end
    
% Save resulting path.
savepath;

% Go back in to setup.
cd('Setup');

end
