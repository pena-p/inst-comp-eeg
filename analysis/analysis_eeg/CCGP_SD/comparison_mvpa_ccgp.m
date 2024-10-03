%% Correlation of Time-Resolved MVPA and CCGP results
% Calculating Pearson's correlation coefficient between the two results

% 1. Calculate correlation of MVPA and CCGP results
% per participant and separately for each variable  (Pearson)
% 2. Calculate average coefficient across participants and average p-value
% (Fisher's method)
% 3. Plot distribution of Pearson's coefficients of each variable across participants
% 4. Check: Compare MVPA and CCGP results across different variables and plot
% 5. Plot all pair-wise correlations. Figure 4 - Figure Supplement 5

%% 1. Calculate Pearson's coefficient of MVPA and CCGP results
clear all;
clc;

% Specify variables, for loading 
var_names = {'int_sel','anim_inan','color_shape'};
ccgp_index = [1,10,21]; % index for ccgp data

% Loop over task components
for k = 1:3 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
    
    % Load first condition, regular MVPA results per variables
    file1 = ['/mnt/NeuroNas/paula/results/' var_names{1,k} '/results/time_resolved/auc/result.mat'];
    load([file1]);
    cond1.res = result;

    % Load second condition, CCGP results per variable
    file2 = ['/mnt/NeuroNas/paula/results/ccgp/' num2str(ccgp_index(1,k)) '/mean_ccgp/mean_dichot.mat'];
    load([file2]);
    cond2.res = res_dichot; 

    for i = 1:39 % Loop over participants

        % Calculate correlation coefficient (r) of time-series per participant
       [cor_part,p_part] = corrcoef(cond1.res(:,:,i), cond2.res(:,:,i));

       % Join Pearson's coefficients and respective p-values
       cor_all(1,i,k) = cor_part(1,2);
       p_all(1,i,k) = p_part(1,2);

    end

        % 2.  Pearson correlation coefficient across participants 
        % Fisher's Z-transformation
        z_values = 0.5 * log((1 + cor_all(1,:,k)) ./ (1 - cor_all(1,:,k)));

        % Average of Fisher Z-transformed values
        mean_z = mean(z_values);

        % Get the average correlation (transform z value back to r)
        cor_avg(k,1) = (exp(2 * mean_z) - 1) / (exp(2 * mean_z) + 1);

        % Combine p-values using Fisher's method
        % Calculate the test statistic X^2 
        X2 = -2 * sum(log(p_all(1,:,k)));

        % Calculate degrees of freedom
        n = length(p_all(1,:,k));  % Number of p-values
        df = 2 * n;  % Degrees of freedom

        % Calculate the Complementary Cumulative Distribution Function (CCDF) from the
        % chi-square to obtain the combined p-values
        p_avg(k,1) = 1 - chi2cdf(X2, df);  % p-value for one-tailed test
 

end


%% 3. Plot Pearson's coefficient per participant

% Define the variables
variables = {'Demand', 'Category', 'Feature'};
color_var = [0.54,0.08,0.18; 0.00,0.45,0.74;0.47,0.67,0.19];

for k = 1:3 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
    a = figure(k); hold on;
    set(gcf,'color','w');
%     title(['Correlation MPVA-CCGP ' variables{k}]);
    bar(cor_all(:,:,k)', 'FaceColor', color_var(k,:),'EdgeColor', color_var(k,:)); hold on;
    ylabel('R²', 'FontWeight','bold', 'FontSize', 14);
    xlabel('Participants', 'FontWeight','bold', 'FontSize', 14);
    xlim([0.5 39.5]);
    ylim([0 1]);
    plot(1:39,repmat(cor_avg(k,1),1,39),'Color',[0.7,0.7,0.7],'LineWidth',2.5 );
    hold off;
end


%% Plot averaged Pearson's coeficient

% Put the variables into an array: [demand, category, feature]
data = [cor_avg(1,1), cor_avg(2,1), cor_avg(3,1)];

% Plot the bar graph
figure(4); hold on;
a = bar(data, 'FaceColor','flat');

% Title and axis labels
title('Correlation Coefficient MVPA and CCGP');
ylabel('Averaged Correlation Coefficient');
xlabel('');
ylim([0 1]);
xticks(1:3);
xticklabels({'Demand','Categ','Feat'});

% Customize the colors for each bar
color_var = [0.54,0.08,0.18; 0.00,0.45,0.74;0.47,0.67,0.19];
a.CData = color_var;


%% 4. Check: correlation across different variables
% Compare the results of MVPA and CCGP crossing different task components

% Specify variables, for loading 
var_names = {'int_sel','anim_inan','color_shape'};
ccgp_index = [1,10,21]; % index for ccgp data

comparison_counter = 0;
% Loop over different pair-wise combinatios of the task components 

for var1 = 1:3 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
 for var2 = 1:3 
     if var1 == var2
         
     else
         comparison_counter = comparison_counter + 1;
         
        % Load first condition, regular MVPA results of variable 1
        file1 = ['/mnt/NeuroNas/paula/results/' var_names{1,var1} '/results/time_resolved/auc/result.mat'];
        load([file1]);
        cond1.res = result;

        % Load second condition, CCGP results of variable 2
        file2 = ['/mnt/NeuroNas/paula/results/ccgp/' num2str(ccgp_index(1,var2)) '/mean_ccgp/mean_dichot.mat'];
        load([file2]);
        cond2.res = res_dichot; 

        for i = 1:39 % Loop over participants

            % Calculate correlation coefficient (r) of time-series per participant
           [cor_part,p_part] = corrcoef(cond1.res(:,:,i), cond2.res(:,:,i));

           % Join Pearson's coefficients and respective p-values
           cor_all_dif(1,i,comparison_counter) = cor_part(1,2);
           p_all_dif(1,i,comparison_counter) = p_part(1,2);

        end

            % Pearson correlation coefficient across participants
            % Fisher's Z-transformation
            z_values = 0.5 * log((1 + cor_all_dif(1,:,comparison_counter)) ./ (1 - cor_all_dif(1,:,comparison_counter)));

            % Average of Fisher Z-transformed values
            mean_z = mean(z_values);

            % Get the average correlation (transform z value back to r)
            cor_avg_dif(comparison_counter,1) = (exp(2 * mean_z) - 1) / (exp(2 * mean_z) + 1);

            % Combine p-values using Fisher's method
            % Calculate the test statistic X^2 
            X2 = -2 * sum(log(p_all_dif(1,:,comparison_counter)));

            % Calculate degrees of freedom
            n = length(p_all_dif(1,:,comparison_counter));  % Number of p-values
            df = 2 * n;  % Degrees of freedom

            % Calculate the Complementary Cumulative Distribution Function (CCDF) from the
            % chi-square to obtain the combined p-values
            p_avg_dif(comparison_counter,1) = 1.0000 - chi2cdf(X2, df);  % p-value for one-tailed test
            
     end
 end
end
disp(['R range from ' num2str(min(min(cor_avg_dif))) ' to ' num2str(max(max(cor_avg_dif))) ]);


%% Plot distribution of R across participants per comparison
figure(5); hold on;
set(gcf,'color','w');
sgtitle('');

for comparison = 1:6 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
    c = subplot(3,2,comparison);
    bar(cor_all_dif(:,:,comparison)', 'FaceColor', [252/255, 171/255, 16/255]); 
    ylabel('R²',  'FontWeight','bold',  'FontSize', 10);
    xlabel('Participants',  'FontWeight','bold',  'FontSize', 10);
    xlim([0.5 39.5]);
    ylim([-0.5 1]);
    
end

% Plot distribution of p-values
figure(2); hold on;
set(gcf,'color','w');
sgtitle('');

for comparison = 1:6 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
    subplot(3,2,comparison);
    bar(p_all_dif(:,:,comparison)', 'FaceColor',[0.827, 0.827, 0.827]); 
    ylabel('p-value', 'FontWeight','bold',  'FontSize', 10);
    xlabel('Participants', 'FontWeight','bold',  'FontSize', 10);
    xlim([0.5 39.5]);
    ylim([-0.5 1]);
    
end


%% 5. Plot of all pair-wise correlations per participant
% Figure 4 - Supplement 5

figure(6); 
set(gcf,'color','w');


% Define the variables
variables = {'Demand', 'Category', 'Feature'};
color_var = [0.54,0.08,0.18; 0.00,0.45,0.74;0.47,0.67,0.19];
id_plot_var = [1,5,9]; % id of subplot of variables
id_plot_dif = [2,3,4,6,7,8]; % id of subplot of crossing of different variables

for var1 = 1:3
    for var2 = 1:3
        if var1 == var2
   
            for k = 1:3 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
                subplot(3,3,id_plot_var(1,k)); hold on;
            %     title(['Correlation MPVA-CCGP ' variables{k}]);
                bar(cor_all(:,:,k)', 'FaceColor', color_var(k,:),'EdgeColor','w', 'BarWidth', 0.9); hold on;
                ylabel('R²', 'FontWeight','bold', 'FontSize', 10);
                xlabel('Participants', 'FontWeight','bold', 'FontSize', 10);
                xlim([0.5 39.5]);
                ylim([-0.5 1]);
                plot(1:39,repmat(cor_avg(k,1),1,39),'Color',[0.8,0.8,0.8],'LineWidth',2.5 );
                hold off;
            end
        else
            for comparison = 1:6 % 1: Task Demand, 2: Target Category, 3: Relevant Feature
                subplot(3,3,id_plot_dif(1,comparison)); hold on;
                bar(cor_all_dif(:,:,comparison)', 'FaceColor', [0.5, 0.5, 0.5], 'EdgeColor','w', 'BarWidth',0.8); 
                ylabel('R²',  'FontWeight','bold',  'FontSize', 10);
                xlabel('Participants',  'FontWeight','bold',  'FontSize', 10);
                xlim([0.5 39.5]);
                ylim([-0.5 1]);
                plot(1:39,repmat(cor_avg_dif(comparison,1),1,39),'Color',[0.8,0.8,0.8],'LineWidth',2.5 );
                hold off;

            end
        end
    end
end

