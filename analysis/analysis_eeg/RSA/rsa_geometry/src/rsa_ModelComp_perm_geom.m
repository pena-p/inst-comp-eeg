 function [permuted_corr, permuted_betas, permuted_tvalues, cfg] = rsa_ModelComp_perm_geom( cfg, fv, RDMs, permute, model)
% Model-based RSA: 
%  (1) Make individual theoretical RDM 
%  (2) Compute time-resolved empirical RDM 
%  (3) Correlate theoretical and empirical RDM in each timepoint
permuted_corr=[];
permuted_betas = [];
permuted_tvalues = [];
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
    % DISSIMILARITY matrix, negative correlations will appear [tears]

    if cfg.classmodel.regress

    % Add theoretical RDM of the geometry models

        % Offset Model
     Y_matrix_parallel = [...
        0	  0.4   0.4   0.8   0.8   1.6   1.6	  2;
        0.4	  0	    0.8	  0.4   1.6   0.8   2	  1.6;
        0.4	  0.8	0	  0.4	1.6   2	    0.8	  1.6;
        0.8	  0.4   0.4	  0	    2	  1.6   1.6	  0.8;
        0.8	  1.6   1.6   2	    0	  0.4   0.4	  0.8;
        1.6	  0.8   2	  1.6	0.4   0     0.8	  0.4;
        1.6	  2     0.8	  1.6	0.4   0.8   0	  0.4;
        2	  1.6   1.6   0.8	0.8   0.4   0.4	  0];
    
     % Orthogonal Model
     Y_matrix_ortho = [...
        0     0.8   0.8   2     0.4   1     0.4   1;
        0.8   0     2     0.8   1     0.4   1     0.4;
        0.8   2     0     0.8   0.4   1     0.4   1;
        2     0.8   0.8   0     1     0.4   1     0.4;
        0.4   1     0.4   1     0     0.8   0.8   2;
        1     0.4   1     0.4   0.8   0     2     0.8;
        0.4   1     0.4   1     0.8   2     0     0.8;
        1     0.4   1     0.4   2     0.8   0.8   0];

       
 
    end
   % Remove diagonal and vectorize matrices
    if cfg.classmodel.regress
        Y_matrix_parallel(logical(eye(size(Y_matrix_parallel)))) = NaN; 
        Y_matrix_parallel = reshape(Y_matrix_parallel,[],1);
        Y_matrix_ortho(logical(eye(size(Y_matrix_ortho)))) = NaN; 
        Y_matrix_ortho = reshape(Y_matrix_ortho,[],1);
        Y_matrix = [Y_matrix_parallel, Y_matrix_ortho]; %1 = parallel, 2 = orthogonal
   else
        Y_matrix(logical(eye(size(Y_matrix)))) = 0; %Para la condición concreta
        Y_matrix = reshape(Y_matrix, [],1);
    end

    
    %% Perform multiple regression and store everything   
     
     
    if cfg.classmodel.corrspe
        for p = 1 : cfg.stats.nper
            if isrow(corr_sbj)
                permuted_corr(:,:,p,sub) = corr_sbj;
            else
                permuted_corr(:,:,p,sub) = corr_sbj';  
            end
        end
    end
     
     if cfg.classmodel.regress
         for p = 1 : cfg.stats.nper
           [~,betas_sbj, tvalues_sbj] = rsa_Example_geom(cfg,X,Y_matrix,permute); 
           permuted_betas(:,:,p,sub) = betas_sbj;
           permuted_tvalues(:,:,p,sub) = tvalues_sbj;
         end
     end
end

fprintf(' - Done!\n');
 end

