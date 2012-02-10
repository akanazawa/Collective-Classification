function do_neigh(config_file)
%%%%%%%%%%
% do_neigh.m
% need to run do_seg.m before running this file.
% Reads in SEG_FILE in DATA_DIR that was processed in do_seg.m
%
% For each image, creates an R x R adjacency matrix where R is the
% number of regions in the i-th image
% the data is in format:
%    neighbors: a N x 1 cell where each cell contains R x R
%    adjacentcy matrix
% 
% saved to the data variable in DATA_FILE as graph1
%
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config_file);

load(DATA_FILE); % load data

%if ~exist(data{1}.graph)
   load(SEG_FILE); % load seg
   neighbors = cell(size(seg));
   for i = 1:length(seg)
       neighbors = getNeighbors(seg{i}.labels, SEG.nC);
       fprintf('getting neighbors for %s\n', seg{i}.file_path);
       data{i}.graph = neighbors; % add graph to data
   end   
   save(DATA_FILE, 'data'); % write over
%end
