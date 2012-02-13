function do_prepareData(config_file)
%%%%%%%%%%
% do_prepareData.m
% 
% Up to this point we have the features (RxD), grount trouth labels
% (Rx1), and the adjacency matrix (R x R)of I images saved in DATA_FILE
% Here we'll split them into training, validation, test sets
% saved in TRAIN_DATA, TEST_DATA
%
% Need to have already ran do_seg.m
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config_file);

%if ~exist(TRAIN_DATA)
    all = load(DATA_FILE); % load data
    I = numel(all.data); % # of total images
    testIdx = [1:floor(I*TEST_SPLIT)];
    trainIdx = [floor(I*TEST_SPLIT)+1:I];

    data = all.data(testIdx); % test data    
    save(TEST_DATA, 'data'); 

    data = all.data(trainIdx); % train data

    save(TRAIN_DATA, 'data'); 
    %end

