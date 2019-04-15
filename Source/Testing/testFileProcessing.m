% Test the functions which process static, marker, grf and motion data.

% Function arguments.
marker_rotations = {0, 90, 0};
grf_rotations = {0, 270, 0};
marker_left_handed = true;
grf_left_handed = false;
time_delay = 16*(1/600);
speed = 0.8;
direction = 'X';
side = 'left';
feet = {side};
kin_mode = 'toe-peak';
grf_mode = 'stance';
cutoff = 2;
marker_dir = 'Markers';
marker_ext = '.trc';
grf_dir = 'GRF';
grf_ext = '.mot';

% Paths to data directories and data files.
home = getenv('MDP_HOME');
testing = [home filesep 'Source' filesep 'Testing' filesep 'Data'];
raw_dir = [testing filesep 'Raw'];
true_dir = [testing filesep 'True'];
test_dir = [testing filesep 'Test'];
static = 'static.trc';
markers = 'markers.trc';
grfs = 'forces.txt';
mot = 'forces.mot';
raw_static = [raw_dir filesep static];
raw_markers = [raw_dir filesep markers];
raw_grfs = [raw_dir filesep grfs];

% Create test directory.
mkdir(test_dir);

%% Test 1: Static processing
processStaticData(test_dir, raw_static, marker_rotations, marker_left_handed);
assert(Data([test_dir filesep static]) == Data([true_dir filesep static]));

%% Test 2: Markers only
processMarkerData(...
    test_dir, raw_markers, marker_rotations, marker_left_handed, []);
assert(Data([test_dir filesep markers]) == ...
    Data([true_dir filesep marker_dir filesep markers]));

%% Test 3: Markers with motion compensation
processMarkerData(test_dir, raw_markers, ...
    marker_rotations, marker_left_handed, speed, direction);
assert(Data([test_dir filesep markers]) == ...
    Data([true_dir filesep 'MarkersComp' filesep markers]));

%% Test 4: Markers with segmentation
processMarkerData(test_dir, raw_markers, marker_rotations, ...
    marker_left_handed, [], [], feet, kin_mode, [], marker_dir);
compareFolder([test_dir filesep side filesep marker_dir], ...
    [true_dir filesep 'MarkersSeg'], marker_ext);

%% Test 5: Markers with segmentation & motion compensation
processMarkerData(test_dir, raw_markers, marker_rotations, ...
    marker_left_handed, speed, direction, feet, kin_mode, [], marker_dir);
compareFolder([test_dir filesep side filesep marker_dir], ...
    [true_dir filesep 'MarkersSegComp'], marker_ext);

%% Test 6: GRF only
processGRFData(test_dir, raw_grfs, grf_rotations, grf_left_handed, []);
assert(Data([test_dir filesep mot]) == ...
    Data([true_dir filesep grf_dir filesep mot]));

%% Test 7: GRF with motion compensation
processGRFData(test_dir, raw_grfs, grf_rotations, grf_left_handed, ...
    speed, direction);
assert(Data([test_dir filesep mot]) == ...
    Data([true_dir filesep 'GRFComp' filesep mot]));

%% Test 8: GRF with segmentation
processGRFData(test_dir, raw_grfs, grf_rotations, grf_left_handed, [], [], ...
    feet, grf_mode, cutoff, grf_dir);
compareFolder([test_dir filesep side filesep grf_dir], ...
    [true_dir filesep 'GRFSeg'], grf_ext);

%% Test 9: GRF with segmentation & motion compensation
processGRFData(test_dir, raw_grfs, grf_rotations, grf_left_handed, ...
    speed, direction, feet, grf_mode, cutoff, grf_dir);
compareFolder([test_dir filesep side filesep grf_dir], ...
    [true_dir filesep 'GRFSegComp'], grf_ext);

%% Test 10: Motion only
processMotionData(test_dir, test_dir, raw_markers, raw_grfs, ...
    marker_rotations, marker_left_handed, grf_rotations, grf_left_handed, ...
    time_delay, []);
assert(Data([test_dir filesep markers]) == ...
    Data([true_dir filesep 'Motion' filesep markers]));
assert(Data([test_dir filesep mot]) == ...
    Data([true_dir filesep 'Motion' filesep mot]));

%% Test 11: Motion with motion compensation
processMotionData(test_dir, test_dir, raw_markers, raw_grfs, ...
    marker_rotations, marker_left_handed, grf_rotations, grf_left_handed, ...
    time_delay, speed, direction);
assert(Data([test_dir filesep markers]) == ...
    Data([true_dir filesep 'MotionComp' filesep markers]));
assert(Data([test_dir filesep mot]) == ...
    Data([true_dir filesep 'MotionComp' filesep mot]));

%% Test 12: Motion with segmentation using hip
processMotionData(test_dir, test_dir, raw_markers, raw_grfs, ...
    marker_rotations, marker_left_handed, grf_rotations, grf_left_handed, ...
    time_delay, [], [], feet, kin_mode, [], marker_dir, grf_dir);
compareFolder([test_dir filesep side filesep grf_dir], ...
    [true_dir filesep 'MotionSegHip' filesep grf_dir], grf_ext);
compareFolder([test_dir filesep side filesep marker_dir], ...
    [true_dir filesep 'MotionSegHip' filesep marker_dir], marker_ext);

%% Test 13: Motion with segmentation using grf
processMotionData(test_dir, test_dir, raw_markers, raw_grfs, ...
    marker_rotations, marker_left_handed, grf_rotations, grf_left_handed, ...
    time_delay, [], [], feet, grf_mode, cutoff, marker_dir, grf_dir);
compareFolder([test_dir filesep side filesep grf_dir], ...
    [true_dir filesep 'MotionSegGRF' filesep grf_dir], grf_ext);
compareFolder([test_dir filesep side filesep marker_dir], ...
    [true_dir filesep 'MotionSegGRF' filesep marker_dir], marker_ext);

%% Test 14: Motion with motion compensation & hip segmentation
processMotionData(test_dir, test_dir, raw_markers, raw_grfs, ...
    marker_rotations, marker_left_handed, grf_rotations, grf_left_handed, ...
    time_delay, speed, direction, feet, kin_mode, [], marker_dir, grf_dir);
compareFolder([test_dir filesep side filesep grf_dir], ...
    [true_dir filesep 'MotionCompSegHip' filesep grf_dir], grf_ext);
compareFolder([test_dir filesep side filesep marker_dir], ...
    [true_dir filesep 'MotionCompSegHip' filesep marker_dir], marker_ext);

%% Test 15: Motion with motion compensation & grf segmentation
processMotionData(test_dir, test_dir, raw_markers, raw_grfs, ...
    marker_rotations, marker_left_handed, grf_rotations, grf_left_handed, ...
    time_delay, speed, direction, feet, grf_mode, cutoff, marker_dir, grf_dir);
compareFolder([test_dir filesep side filesep grf_dir], ...
    [true_dir filesep 'MotionCompSegGRF' filesep grf_dir], grf_ext);
compareFolder([test_dir filesep side filesep marker_dir], ...
    [true_dir filesep 'MotionCompSegGRF' filesep marker_dir], marker_ext);

% Clear test directory.
rmdir(test_dir, 's');

% Define helper function.
function compareFolder(known, test, ext)

    [n, known_files] = getFilePaths(known, ext);
    [~, test_files] = getFilePaths(test, ext);
    
    for i=1:n
        assert(Data(known_files{i}) == Data(test_files{i}));
    end

end