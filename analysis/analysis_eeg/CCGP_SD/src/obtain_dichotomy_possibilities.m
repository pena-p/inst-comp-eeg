function [dichot, var_index] = obtain_dichotomy_possibilities(conditions)

% Obtain all the possible dichotomies of 4 and 4 conditions

values = 1:length(conditions);
values_first = 1:length(values)/2;
values_second= length(values)/2 + 1:values(end);

dichot_temp =nchoosek(values,4);
class_a = dichot_temp(1:length(dichot_temp)/2,:);
class_b = dichot_temp(length(dichot_temp)/2+1:end,:);
class_b = flip(class_b,1);
dichot = class_a;

for i = 1:size(class_a,1)
    dichot(i,values_second) = class_b(i,values_first);
end

% Find dichotomies corresponding to our 3 main variables (Task Demand,
% Target Category and Target Relevant Feature)

% Identify one level of each of the main variables:
cond_dem = find(contains(conditions,'INT_'));
cond_categ = find(contains(conditions,'ANIM_'));
cond_feat = find(contains(conditions,'_C'));

% Find dichotomies of the main variables
var_index.demand = find(all(class_a == cond_dem(1:4),2));
var_index.categ = find(all(class_a == cond_categ(1:4),2));
var_index.feat = find(all(class_a == cond_feat(1:4),2));

end