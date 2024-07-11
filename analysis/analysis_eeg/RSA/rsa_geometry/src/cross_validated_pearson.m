function correl_matrix=cross_validated_pearson(dat,label,fold)

% Script adapted from Peñalver et al. (2023), to perform de disimilarity
% in a cross-validated manner using Pearson correlation (lines 30 to end
% have been adapted from correlmat.m of The Decoding Toolbox (TBT; Hebbart
% et al., 2015).

% Performs Pearson Correlation of the train and test data matrices across all possible
% combinations of folds 
% dat is trial x feature matrix (trials x channels)
% label is the label of each conditions
% fold is a numeric vector indication from which fold each observation came from
% correl_matrix is a nLabels x nLabels x nFolds matrix 

unique_labels=unique(label);
nLabels=numel(unique_labels);
unique_folds=unique(fold);
nFolds=numel(unique_folds);

correl_matrix=nan(nLabels,nLabels,nFolds);

for iFold=1:nFolds
    dat_train=dat(fold~=unique_folds(iFold),:);
    dat_test=dat(fold==unique_folds(iFold),:);
    
    label_train=label(fold~=unique_folds(iFold));
    label_test=label(fold==unique_folds(iFold));
    
    for iLabel = 1:nLabels
        train(:,iLabel)=squeeze(mean(dat_train(label_train==iLabel,:)))'; 
        test(:,iLabel)=squeeze(mean(dat_test(label_test==iLabel,:)))';  
    end

    % Mean-center around 0
    [s_cond(1),s_train] = size(train);
    mean_train = sum(train,2)/s_train; % mean X
    train_centered = train - repmat(mean_train,1,s_train); % center around 0

    s_test = size(test,2);
    mean_test = sum(test,2)/s_test;
    test_centered = test - repmat(mean_test,1, s_test);

    % Obtain Pearson's coefficient
    r=train_centered'*test_centered;
  
    normtrain = sqrt(sum(train_centered.^2,1));
    normtest = sqrt(sum(test_centered.^2,1));
    r = r./repmat(normtrain,s_test,1)';
    r = r./repmat(normtest,s_train,1);

    ind = find(abs(r)>1); 
    r(ind) = r(ind)./abs(r(ind));

    % Distance measure (1 - Pearson's coefficient)
    r = 1 - r;

    correl_matrix(:,:,iFold)=r;                              
                          
    end
end
