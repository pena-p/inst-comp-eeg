function [corr_sbj,betas_sbj, tvalues_sbj, cfg] = rsa_Example(cfg,X,Y_matrix,permute)
% Function to perform multiple linear regresssion to compare the
% thoeretical models with the neural RDMs of every channel

electrodes = size(cfg.chanloc,2);
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

for chan = 1 : electrodes
    
    % Select the FV (time-points) 
    % of the current CHANNEL
         X_matrix = X(:,:,chan); 
  
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

    % Now, correlate the CHANNEL's NEURAL MATRIX with our THEORETICAL
    % MODEL (Y)
    if cfg.classmodel.regress
            % regression
            mdl= fitlm(Y_matrix,X_matrix);       
            betas_sbj(:,chan) = mdl.Coefficients.Estimate(2:end);
            tvalues_sbj(:,chan) = mdl.Coefficients.tStat(2:end);
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
        corr_sbj(chan,:) = atanh(r);
    end
%    regr_sbj(chan,:) = b;
    % [The code for Fisher transf was directly taken from fMRI RSA scripts]
end
    
end
