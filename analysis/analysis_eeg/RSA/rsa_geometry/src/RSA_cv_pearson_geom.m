%% Script to obtain the neural RDM matrices via a  measure of cross-validated Pearson

mode = 'conditions';
t = cfg.tm.tpoints;
ncond = length(cfg.study.conditionIdentifier);
u = numel(fieldnames(fv{1, 1}.X))*ncond;
for i = 1:length(fv)
    A = fv{i}.X.a;
    B = fv{i}.X.b;
    C = fv{i}.X.c;
    Z = [A;B;C];


    if strcmp(mode, 'trials')
        labels= [1:size(X,1),1:size(X,1)];
    elseif strcmp(mode, 'conditions')
        labels = nan(size(Z,1),1);
        for q = 1:numel(fieldnames(fv{1, i}.X))
            for j = 1:ncond
                if q == 1
                    if j == 1
                    labels(1:size(Z,1)/u)=j;
                    else
                    labels((size(Z,1)/u*(j-1))+1:size(Z,1)/u*j)=j;
                    end

                elseif q==2
                    labels((size(Z,1)/u*((j+ncond)-1))+1 ...
                        :size(Z,1)/u*(j+ncond))=j;
                
                elseif q==3
                    if j == ncond
                    labels((size(Z,1)/u*((j+ncond*2)-1))+1 ...
                        :size(Z,1))=j;
                    else
                    labels((size(Z,1)/u*((j+ncond*2)-1))+1 ...
                        :size(Z,1)/u*(j+ncond*2))=j;
                    end
                end
            end
        end
    end
  
    folds = [ones(size(A,1),1);ones(size(B,1),1)*2;ones(size(C,1),1)*3];
    
    for tp = 1:cfg.tm.ntp
        text = ['Computing subject ' int2str(i) ' on time point ' int2str(tp) '/' int2str(cfg.tm.ntp)];
        fprintf(text);
        correl_matrix = cross_validated_pearson(Z(:,:,t(tp)), labels, folds);
        RDM = squeeze(mean(correl_matrix,3, 'omitnan')); % mean across folds
        RDM(logical(eye(size(RDM)))) = NaN; % remove diagonal
        RDMs(:,:,tp,i) = RDM;
    end
end
    