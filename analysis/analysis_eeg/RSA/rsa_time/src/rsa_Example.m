function [corr_sbj,betas_sbj, tvalues_sbj, cfg] = rsa_Example(cfg,X,Y_matrix,permute)
%SVM_CLASSIFIER This function returns the accuracy of the classifier in a
%time-resolved way.
c = cfg.tm;
corr_sbj = [];
betas_sbj = [];
tvalues_sbj = [];
if permute
    if cfg.classmodel.regress
        for i = 1:size(Y_matrix, 2)
            Y_matrix(:,i) = Y_matrix(randperm(length(Y_matrix)),i);
        end
    elseif cfg.classmodel.corrspe
        Y_matrix = Y_matrix(randperm(length(Y_matrix)));
    end
end
% In RSA is irrelevant the training/test partition. We keep the "training"
% term, but we're not training anything. 
for tp = 1 : c.ntp
    
    % Select the FV (62 channels signal values per trial/supertrial) 
    % of the current TIMEPOINT
    if strcmp(cfg.analysis, 'RSA_pearson_cv')
         X_matrix = X(:,:,tp); 
    else
         train_X = X(:,:,c.tpoints(tp));
    end
        
   
    
    % Correlate all trials' FV among each other. If you have 100
    % trials/supertrials (each with its own FV of 62 values), you'll end up
    % with a 100*100 neural matrix. 
    if cfg.classmodel.corrspe
        if ~strcmp(cfg.analysis, 'RSA_pearson_cv')      
            X_matrix = corrcoef(train_X');  % This is a PEARSON correlation
            X_matrix = 1 - X_matrix; % DISSIMILARITY VALUES
        end
    end
 
    % if you want to take a look at the neural matrix of this timepoint
    % uncomment:  
%      imagesc(X_matrix);
%    pause (.1);
    
    % Vectorize the entire matrix
    X_matrix = reshape(X_matrix,[],1);

    % Now, correlate the TIMEPOINT's NEURAL MATRIX with our THEORETICAL
    % MODEL (Y)
    %% Si y_matrix incluye los 4 modelos, betas: 4 por sujeto?
    if cfg.classmodel.regress
            % regression
            mdl= fitlm(Y_matrix,X_matrix);       
            betas_sbj(:,tp) = mdl.Coefficients.Estimate(2:end);
            tvalues_sbj(:,tp) = mdl.Coefficients.tStat(2:end);
    end
        
    if cfg.classmodel.corrspe  
        r = corr(X_matrix(:),Y_matrix(:),'Type','Spearman'); % Always Spearman!
        % We apply the fisher trasformation to have normal correlation data. 
        % 1. Force finite values for later z-transformation
        r1 = (abs(r)+eps)>=1; % eps corrects for rounding errors in r
        if any(r1(:))
            warning('CORRELATION_CLASSIFIER:ZCORRINF','Correlations of +1 or -1 found. Correcting to +/-0.99999 to avoid infinity for z-transformed correlations!')
            r(r1) = 0.99999*r(r1); % forces finite values
        end
        % 2. Translate to Fisher's z transformed values
        corr_sbj(tp,:) = atanh(r);
    end
%    regr_sbj(tp,:) = b;
    % [The code for Fisher transf was directly taken from fMRI RSA scripts]
    end
    
end
