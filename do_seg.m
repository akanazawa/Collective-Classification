function do_seg(config)
%%%%%%%%%%
% do_seg.m
% Supersegments all N images in IMG_DIR and saves them in SEG_FILE where 
% the data is in a N x 1 cell where each cell has the structure:
%     file_name: the original img file name in absolute path
%     segmented: H x W matrix where each pixel is assigned a label
%                belonging to a region
%     truth_file: path to the ground truth data (in txt)
%
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config);

%% Load images
