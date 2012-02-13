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

L = numel(CLASSES); % total number of classes in this dataset

numImgs = numel(data); % Number of images
accuracy = zeros(TRAIN.K,3);
models = cell(TRAIN.K,1); % ava or vl_feat
%models = cell(TRAIN.K,L); %ova with libSVM


D = size(data{1}.feat1, 2); % dimention of the feature 
% We need to stack data so that it can be sent to libsvm 
numTrain = numImgs * SEG.nC; % for each image we have SEG.nc many feats
ground_truth = zeros(numTrain, 1);
stacked_data = zeros(numTrain, D);

for img_ind = 1:numImgs
    base_index = (img_ind - 1) * SEG.nC;    
    ground_truth(((base_index+1):(base_index+SEG.nC)), :) = data{img_ind}.labels;
    stacked_data(((base_index+1):(base_index+SEG.nC)), :) = data{img_ind}.feat1;
end

for k = 1:TRAIN.K
    fprintf('\n-----Running stack level %d-----\n', k);
    %%%%%%%% one vs all with vl_feat
    C = 1; 
    lambda = 1/(C * size(stacked_data, 2));
    w = zeros(size(stacked_data, 2) + 1, L); 
    for l = 1:L
        w(:, l) = vl_pegasos(single(stacked_data'), ...
                             int8(ground_truth==CLASSES(l)), ...
                             lambda, ...
                             'NumIterations', numTrain * 100, ...
                             'BiasMultiplier', 1);
        score = w(1:end-1, l)' * stacked_data' + w(end,l) * ...
                ones(1,numTrain);
        correct = sum((score >= 1) == (ground_truth == CLASSES(l))');
        fprintf('accuracy at %d vs all: %g \n', CLASSES(l), (correct/numTrain));
        
    end
    models{k}.w = w(1:end-1, :);
    models{k}.b = w(end, :);
    
    % Predict
    scores = models{k}.w' * stacked_data' + models{k}.b' * ones(1, ...
                                                      numTrain);
    [~, pred] = max(scores, [], 1);
    predictions = CLASSES(pred)';
    %% compute OVA accuracy for this level
    accuracy(k, 1) = sum(predictions == ground_truth) ./ numTrain;    %# accuracy
    
    %%%%%%%% one vs all with libsvm
    % for l = 1:L
    %     models{k, l}.w = svmtrain(double(ground_truth==l), stacked_data, ...
    %                             [TRAIN.libsvm_options, ' -b 1']);
    %     fprintf('trained class %d vs all\n', l);
    % end
    % % get probability estimates of each x using each model
    % prob = zeros(numTrain, L);
    % for l=1:L
    %     fprintf('testing class %d vs all\n', l);
    %     [~,~,p] = svmpredict(double(ground_truth==l), stacked_data, ...
    %                          models{k, l}, '-b 1');
    %     prob(:,l) = p(:,models{k, l}.Label==1);    %# probability of class==k
    % end
    % % predict the class with the highest probability
    % [~,pred] = max(prob,[],2);
    %% compute OVA accuracy for this level
    % accuracy(k, 1) = sum(pred == ground_truth) ./ numTrain;    %# accuracy

    %%%%%%%% one vs one
    % models{k} = svmtrain(ground_truth, stacked_data, TRAIN.libsvm_options);
    % [predictions accuracy(k,:) decision_values] = svmpredict(ground_truth, ...
    %                                                   stacked_data, models{k});
    
    %    fprintf('Prediction accuracy: %g\n', accuracy(k,1)); AVA
    fprintf('Prediction accuracy: %g\n', accuracy(k,1)); 
    
    new_feats = zeros(numImgs * SEG.nC, 1 + size(CLASSES,2));
    
    for img_ind = 1:numImgs
        % get the predictions for the regions in this image and
        % element-wise multiply with the adjacency matrix
        % this replaces the binary values of the adjacency matrix
        % with the corresponding predicted label
        % adjacency matrix should only use binary values!
        
        base_index = (img_ind - 1) * SEG.nC;
        neigh_labels = bsxfun(@times, pred((base_index+1):(base_index+SEG.nC)), (data{img_ind}.graph > 0));
        
        % Get the frequencies for each class, for each region
        % and append it onto the new features
        new_feats(((base_index+1):(base_index+SEG.nC)), :) = hist(neigh_labels, [0:L])';
    end
    
    % Stack new neighborhood prediction information onto the
    % features
    new_feats = new_feats(:,2:end);
    new_feats = bsxfun(@rdivide, new_feats, sum(new_feats,2));
    stacked_data = [stacked_data new_feats];

end

save(MODEL_FILE, 'models', 'accuracy');
