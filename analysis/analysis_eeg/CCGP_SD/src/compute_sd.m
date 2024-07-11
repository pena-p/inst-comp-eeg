function [res_sd,perm_sd] = compute_sd(conditions,dichot,dir)

%% Function to load all the results and permutations from crossing the data subsets (16)
% on each combination

res_sd = [];
perm_sd = [];
counter = 0;

% Join all the results in one matrix
for comb = 1:size(dichot,1)
        counter = counter + 1;

        load([dir.res num2str(comb) '/all_cond/result.mat']);
        load([dir.res num2str(comb) '/all_cond/permaps.mat']);
        res_sd(counter,:,:) = result(1,:,:);
        perm_sd(counter,:,:,:) = permaps(1,:,:,:);
end


% Mean results and permutaitons per time point and subject
res_sd = nanmean(res_sd,1);
perm_sd = nanmean(perm_sd,1);

% Save the mean result
save([dir.res '/sd/sd_results.mat'],'res_sd', 'perm_sd');
end