function do_train(config_file)
%%%%%%%%%%
% do_train.m
% This function is a simple implementation of iterative collective
% classification using libsvm. We iteratively train on our data, make
% predictions on the data, and append local neighborhood information onto
% the features. 
% 
% saved in MODEL_FILE from config
%%%%%%%%%%

%% Evaluate global configuration file and load parameters

eval(config_file);

load(TRAIN_DATA); % this will load 'data'

numImgs = numel(data); % Number of images
accuracy = zeros(TRAIN.K,3);
models = cell(TRAIN.K,1);

% We need to stack data so that it can be sent to libsvm 
ground_truth = zeros(numImgs * SEG.nC, 1);
stacked_data = zeros(numImgs * SEG.nC, size(data{1}.feat1, 2));

for img_ind = 1:numImgs
    base_index = (img_ind - 1) * SEG.nC;
    
    ground_truth(((base_index+1):(base_index+SEG.nC)), :) = data{img_ind}.labels;
    stacked_data(((base_index+1):(base_index+SEG.nC)), :) = data{img_ind}.feat1;
end

for k = 1:TRAIN.K
    fprintf('Running stack level %d\n', k);
    
    models{k} = svmtrain(ground_truth, stacked_data, TRAIN.libsvm_options);
    [predictions accuracy(k,:) decision_values] = svmpredict(ground_truth, stacked_data, models{k});
    
    fprintf('Prediction accuracy: %g\n', accuracy(k,1));
    
    new_feats = zeros(numImgs * SEG.nC, size(CLASSES,2));
    
    for img_ind = 1:numImgs
        % get the predictions for the regions in this image and
        % element-wise multiply with the adjacency matrix
        % this replaces the binary values of the adjacency matrix
        % with the corresponding predicted label
        % adjacency matrix should only use binary values!
        base_index = (img_ind - 1) * SEG.nC;
        neigh_labels = bsxfun(@times, predictions((base_index+1):(base_index+SEG.nC)), (data{img_ind}.graph > 0));
        
        % Get the frequencies for each class, for each region
        % and append it onto the new features
        new_feats(((base_index+1):(base_index+SEG.nC)), :) = hist(neigh_labels, CLASSES)';
    end
    
    % Stack new neighborhood prediction information onto the features
    stacked_data = [stacked_data new_feats];

end

save(MODEL_FILE, 'models', 'accuracy');