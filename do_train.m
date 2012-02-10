function do_train(config)
%%%%%%%%%%
% do_train.m
% blah
%
% the data is in format:
% 
% saved in MODEL_FILE from config
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config);
function [Model acc] = do_CollectiveTrain(config_file)
% G - The data with the graph structure since we know the true label
% G.data - feature values and label.
% G.graph - Incidence graoh based on the label.
% G.trueLabel - True Label of the data.
% G.labelStack - The stack of estimated labels.
% K - The level of stacks
% MulticlassTrain - A function handle that takes in input and gives a classfiers
% In this work we hv used libsvm as the classifier
 
% Model - The model obtained after training for different numbers of stack.
 
% Since we have the estimated label stack already intialized in G we need not do it again.
% We will keep updating G as the feature stack so Dmc in the algorithm is
% our G

dummyData = double(G.data);
[Num dim] = size(dummyData);
G.data = cell(K,1);
G.data{1,1} = dummyData;
clear dummyData;
Llab = length(unique(G.trueLabel));

% TODO: Lots of matrix concatenation this may not be very efficient since
% matlab will supposedly reallocate memory a lot.

load(SEG_FILE); % this will load 'data'

predictions
accuracy = zeros(K,3);
models = cell(K,1);

% We need to stack data!
ground_truth = zeros(I * SEG.nC, 1);
stacked_data = zeros(I * SEG.nC, D);

for img_ind = 1:I
    base_index = (img_ind - 1) * SEG.nC;
    
    stacked_data(((base_index+1):(base_index+SEG.nC)), : = data{img_ind}.feat
end

for k = 1:K
    models{k} = svmtrain(ground_truth, stacked_data, libsvm_options);
    [predictions accuracy(k,:) decision_values] = svmpredict(ground_truth, stacked_data, models{k});
    
    new_feats = [];
    
    for img_ind = 1:I
        % get the predictions for the regions in this image and
        % element-wise multiply with the adjacency matrix
        % this replaces the binary values of the adjacency matrix
        % with the corresponding predicted label
        % adjacency matrix should only use binary values!
        base_index = (img_ind - 1) * SEG.nC;
        neigh_labels = bsxfun(@times, predictions((base_index+1):(base_index+SEG.nC)), (data{img_ind}.graph > 0));
        
        % Get the frequencies for each class, for each region
        % and append it onto the new features
        new_feats = [new_feats; hist(neigh_labels, CLASSES)'];
    end
    
    % Stack new neighborhood prediction information onto the features
    stacked_data = [stacked_data new_feats);

end


