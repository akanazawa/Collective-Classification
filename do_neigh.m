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
% saved in NEIGHBOR_FILE specified in config.m
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config_file);

if ~exist([NEIGHBOR_FILE])
   load(SEG_FILE); % loads data
   neighbors = cell(size(data));
   for i = 1:length(data)
       neighbors{i} = getNeighbors(data{i}.labels, SEG.nC);
       imshow(neighbors{i});
       fprintf('getting neighbors for %s\n', data{i}.file_path);
   end
   save([NEIGHBOR_FILE], 'neighbors');
end
