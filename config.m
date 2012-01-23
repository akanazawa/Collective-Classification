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

% file name to save the segmentation file
SEG_FILE = [ DATA_DIR, 'segmented.mat'];

%%%%%
%% FEATURE EXTRACTION SETTINGS/FILENAMES
%%%%%
FEAT_FILE = [ DATA_DIR, 'features.mat'];

%%%%%
%% TRAINING SETTINGS
%%%%%

MODEL_FILE = [ DATA_DIR, 'models.mat'];

