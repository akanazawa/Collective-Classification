function do_feat(config_file)
%%%%%%%%%%
% do_feat.m
% Extracts the color and texture features for each region. Also
% computes the true label for a region
%
% Color features are the mean RGB, std dev, and a color
% histogram. [Malisiewicz, T., Efros, A.: Recognition by
% association via learning per-exemplar distances.]
%
% Texture features are the mean filter bank response from the
% region [Image Segmentation with Topic Random Field]
%
% Saves the features in a I x 1 cell, data, where
%       data{i}.feat1 : R x D feature matrix where D is the length
%                       of the feature and R is the total number of regions
%       data{i}.labels: R x 1 true label of each region
%       data{i}.file_path: the original img file path
%
% saved in DATA_FILE
%
% Need to have already ran do_seg.m
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config_file);

if ~exist(DATA_FILE)
    load(SEG_FILE); % load seg
    data = cell(length(seg), 1); % allocate memory
    for i=1:length(seg)
        data{i}.file_path = seg{i}.file_path; 
        im = im2double(imread(data{i}.file_path));
        labels = zeros(SEG.nC, 1);
        features = zeros(SEG.nC, 79); 
        %% apply filter bank on the image
        fim = fbRun(rgb2gray(im));
        for j = 1:SEG.nC
            % segmentation label counts from 0
            segLabel = j-1;
            idx = find(seg{i}.labels==segLabel);
            if sum(idx(:))==0
                fprintf('wtf why %d\n', segLabel);
                keyboard
            end
            %% find the ground truth for each region
            labels(j) = mode(seg{i}.gt(idx));
            if 0
                keyboard
                unknowns = find(seg{i}.gt==3);
                test2 = zeros(size(rgb2gray(im)));
                test2(unknowns) = 1;
                sfigure;imagesc(test2); title('region');
            end
            %% get the color feature
            [colorm, colors, colorh] = feats14_color(idx, im);
            %% the average of the 40 filter bank responses
            texture = mean(fim(:, idx), 2);
            features(j, :) = [colorm; colors; colorh(:); texture];
        end      
        data{i}.labels = single(labels);
        % if numel(find(unique(labels) >= 0)) ~= numel(find(unique(seg{i}.gt) >= 0))
        %     fprintf('bad true region label?');
        %     keyboard
        % end
        data{i}.feat1 = single(features);
        fprintf('done computing features for %dth image %s\n', i, ...
                data{i}.file_path);
    end
    save(DATA_FILE, 'data'); % write to file
end

