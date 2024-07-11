function [X,Y,cfg] = mvpalab_datalabels_rsa(cfg,fv)
%MVPALAB_DATALABELS Summary of this function goes here
% Divide data set in 3 data chunks

    X.a = [];
    Y.a = [];
    X.b = [];
    Y.b = [];
    X.c = [];
    Y.c = [];


    
    if strcmp(cfg.analysis, 'RSA_the')
        for i = 1:length(fv)
            X.a = [X.a;fv{i}];
            if mod (i,2)==1
                Y.a = [Y.a;logical(zeros(size(fv{i},1),1))];
            else
                Y.a = [Y.a;logical(ones(size(fv{i},1),1))];
            end
        end
    elseif strcmp(cfg.analysis, 'RSA_emp')
        for i = 1:length(fv)/2
            X.a = [X.a;fv{i}];
            X.b = [X.b;fv{i+length(fv)/2}];
            if mod(i,2)==1
                Y.a = [Y.a;logical(zeros(size(fv{i},1),1))];
                Y.b = [Y.b;logical(zeros(size(fv{i+length(fv)/2},1),1))];
            else
                Y.a = [Y.a;logical(ones(size(fv{i},1),1))];
                Y.b = [Y.b;logical(ones(size(fv{i+length(fv)/2},1),1))];
            end
        end
    elseif strcmp(cfg.analysis, 'RSA_pearson_cv')
        for i = 1:length(fv)
            if mod(size(fv{i},1),3) ~= 0
                if mod(size(fv{i},1),3) == 1
                    fv{i} = fv{i}(1:end-1,:,:);
                elseif mod(size(fv{i},1),3) == 2
                    fv{i} = fv{i}(1:end-2,:,:); 
                end
            end
            rand1 = randperm(size(fv{i},1), size(fv{i},1)/3); 
            rand_ = 1:size(fv{i},1);
            rand_(rand1) = [];
            rand2= rand_(randperm(numel(rand_),size(fv{i},1)/3));     
            rand3 = setdiff([1:size(fv{i},1)],[rand1,rand2]);

            X.a = [X.a;fv{i}(rand1,:,:)];
            X.b = [X.b;fv{i}(rand2,:,:)];
            X.c = [X.c;fv{i}(rand3,:,:)];
           

            if strcmp(cfg.features, 'trials') 
                if i<= length(fv)/2
                    if mod (i,2)==1
                        Y.a = [Y.a;logical(zeros(size(fv{i},1),1))];
                    else
                        Y.a = [Y.a;logical(ones(size(fv{i},1),1))];
                    end
                end
            else
                if mod (i,2)==1
                    Y.a = [Y.a;1];
                else
                    Y.a = [Y.a;0];
                end
            end        
        end
        
        

%     if length(fv) > 2
%         X.b = [fv{3};fv{4}];
%         Y.b = logical([zeros(size(fv{3},1),1);ones(size(fv{4},1),1)]);
%     end
end