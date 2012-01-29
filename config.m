%%%%%%%%%%%%%%%%%%%%
% The global configuration file 
% Holds all settings used in all parts of LDA+MRF, enabling the exact
% reproduction of the experiment at some future date.

%%%%%
% DIRECTORIES
%%%%%

% Directory holding the experiment 
RUN_DIR = [ 'Collective_Segmentation' ];

% Directory holding all the source images
IMG_DIR = [ 'images/' ];
% Dir with ground truth
GT_DIR = [ 'images/labels/'];
gt_ext = ['.regions.txt']; % ground truth extension
% Data directory - holds all intermediate .mat files
DATA_DIR = [ 'data/' ];   

%%%%%
%% EXPERIMENT SETTINGS
%%%%%
% how to divide the data
TEST = .15;
TRAIN = .70;
VALID = .15;

%%%%%
%% OVERSEGMENATAION SETTINGS/FILENAMES
%%%%%

SEG.nC = 300; % taget number of super pixels
SEG.lambda_prime = 0.5;
SEG.sigma = 5.0; 
SEG.conn8 = 1; % flag for using 8 connected grid graph (default setting).

% file name to save the segmentation file
SEG_FILE = [DATA_DIR, 'segmented.mat'];
IMG_NAMES = [DATA_DIR, 'imagepath.mat'];


%% DATA_FILE Keeps all data in format:
%
% data: I x 1 cell
%     data{i}.feat1 : R x D feature matrix for each region
%     data{i}.label: R x 1 true labels of each region
%     data{i}.graph1: R x R adjacency matrix
%     data{i}.featureCount : number of different features we have
%     data{i}.graphCount: number of different count
%
% if adding new features or graphs, keep the format, increment the number

DATA_FILE = [ DATA_DIR, 'features.mat'];

%%%%%
%% TRAINING SETTINGS
%%%%%

MODEL_FILE = [ DATA_DIR, 'models.mat'];

