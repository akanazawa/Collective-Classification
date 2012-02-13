function do_all(config)
%%%%%%%%%%%%%%%%%%%%
% do_all.m
% The top-level script for the implementation of Collctive Segmentation
%%%%%%%%%%%%%%%%%%%%

% start a matlab pool to use all CPU cores for full tree training
% if isunix && matlabpool('size') == 0
%     numCores = feature('numCores')
%     if numCores==16
%         numCores=8
%     end
%     matlabpool('open',numCores);
% end


do_seg(config);

do_feat(config);

do_neigh(config);

do_prepareData(config); % split data

do_train(config);

keyboard
do_test(config);
