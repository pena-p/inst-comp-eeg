function [res_dichot,perm_dichot] = mean_res_dichot(conditions,combination,dir)

%% Function to load all the results and permutations from crossing the data subsets (16)
% on each combination

res_dichot = [];
perm_dichot = [];
counter = 0;

% Join all the results in one matrix
for step_a = 1:length(conditions)/2
    for step_b = 1:length(conditions)/2
        counter = counter + 1;
        load([dir.res num2str(combination) '/ccgp/' num2str(step_a) '-' ...
            num2str(step_b) '/result.mat']);
        load([dir.res num2str(combination) '/ccgp/' num2str(step_a) '-' ...
            num2str(step_b) '/permaps.mat']);
        res_dichot(counter,:,:) = result(1,:,:);
        perm_dichot(counter,:,:,:) = permaps(1,:,:,:);
    end
end

% Mean results and permutaitons per time point and subject
res_dichot = nanmean(res_dichot,1);
perm_dichot = nanmean(perm_dichot,1);

% Save the mean result
save([dir.res num2str(combination) '/mean_ccgp/mean_dichot.mat'],'res_dichot', 'perm_dichot');