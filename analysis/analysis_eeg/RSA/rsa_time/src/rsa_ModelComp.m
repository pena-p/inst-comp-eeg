function [corr, betas, tvalues, cfg] = rsa_ModelComp( cfg, fv, RDMs, permute, model)

% Model-based RSA: 
%  (1) Make individual theoretical RDM 
%  (2) Compute time-resolved empirical RDM 
%  (3) Correlate theoretical and empirical RDM in each timepoint
corr=[];
betas = [];
tvalues = [];
fprintf('<strong> > Analyzing data: </strong>\n');

%% Subjects loop:
nsub = length(cfg.study.dataFiles{1});
for sub = 1 : nsub
    fprintf(['   - Subject: ' int2str(sub) '/' int2str(nsub) ' >> ']);
    
    %% Data and true labels:
    % X: (concatenated data for cond A and B, channels, timepoints)
    % Y: conditions label
    X = RDMs(:,:,:,sub);
    Y = fv{sub}.Y.a;
    %% Generate THEORETICAL RDM (OUR MODEL)
    %% very IMPORTANT: Here we will work with RDMs... D = dissimilarity values. 
    % If we correlate a theoretical SIMILARITY matrix with an empirical
    % DISSIMILARITY matrix, negative correlations will appear 
     
    % Add theretical RDM of the 3 task components

    % Task Demand
      Y_matrix_dem = [  ...
         0     0     0     0     2     2     2     2;
         0     0     0     0     2     2     2     2;
         0     0     0     0     2     2     2     2;
         0     0     0     0     2     2     2     2;
         2     2     2     2     0     0     0     0;
         2     2     2     2     0     0     0     0;
         2     2     2     2     0     0     0     0;
         2     2     2     2     0     0     0     0];
    
      % Target Category
      Y_matrix_cat = [  ...
         0     0     2     2     0     0     2     2;
         0     0     2     2     0     0     2     2;
         2     2     0     0     2     2     0     0;
         2     2     0     0     2     2     0     0;
         0     0     2     2     0     0     2     2;
         0     0     2     2     0     0     2     2;
         2     2     0     0     2     2     0     0;
         2     2     0     0     2     2     0     0];
    
      % Target Relevant Feature
       Y_matrix_feat = [ ...
         0     2     0     2     0     2     0     2;
         2     0     2     0     2     0     2     0;
         0     2     0     2     0     2     0     2;
         2     0     2     0     2     0     2     0;
         0     2     0     2     0     2     0     2;
         2     0     2     0     2     0     2     0;
         0     2     0     2     0     2     0     2;
         2     0     2     0     2     0     2     0];
    
    % Remove diagonal, vectorize matrices
    if cfg.classmodel.regress
        Y_matrix_dem(logical(eye(size(Y_matrix_dem)))) = NaN; 
        Y_matrix_dem = reshape(Y_matrix_dem,[],1);
        Y_matrix_cat(logical(eye(size(Y_matrix_cat)))) = NaN; 
        Y_matrix_cat = reshape(Y_matrix_cat,[],1);
        Y_matrix_feat(logical(eye(size(Y_matrix_feat)))) = NaN; 
        Y_matrix_feat = reshape(Y_matrix_feat,[],1);
        Y_matrix = [Y_matrix_dem, Y_matrix_cat, Y_matrix_feat]; %1 = demand, 2 = category, 3=feature
    else
        Y_matrix(logical(eye(size(Y_matrix)))) = 0; 
        Y_matrix = reshape(Y_matrix, [],1);
    end


    %% RSA function 
  
    [~,betas_sbj, tvalues_sbj] = rsa_Example(cfg,X,Y_matrix,permute); 
    
    %% Store everything   
    if cfg.classmodel.corrspe
        if isrow(corr_sbj)
            corr(:,:,sub) = corr_sbj;
        else
            corr(:,:,sub) = corr_sbj';  
        end
    end
    if cfg.classmodel.regress
            betas(:,:,sub) = betas_sbj;
            tvalues(:,:,sub) =tvalues_sbj;
    end
    
end
fprintf(' - Done!\n');
end
