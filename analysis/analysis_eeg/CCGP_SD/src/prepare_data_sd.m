function [] = prepare_data_sd(sub,cond_a,cond_b,dir,combination)

%% Function to prepare data according to the dichotomy for Shattering Dimensionality
% Merge the data for classification of condition a and condition b 
           
           % Counter to know from which specific dichotomy of the analyses
           % is the data 
           counter.combination = combination;
 
           values = 1:4;
            
           if sub < 10
               sub_zeros = '00';
           else
               sub_zeros = '0';
           end

           %%  Merge data from condition a
            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values(1,1))) '.mat']);
            data_a_one = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values(1,2))) '.mat']);
            data_a_two = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values(1,3))) '.mat']);
            data_a_three = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values(1,4))) '.mat']);
            data_a_four = data_;

            % Join the data from the three subsamples
            data_a = data_a_one;
            data_a.filename = 'data_a.set';
            data_a.setname = 'data_a';
            data_a.filepath = dir.cond;
            data_a.trials = data_a.trials + data_a_two.trials...
                + data_a_three.trials + data_a_four.trials;
            data_a.data = cat(3,data_a.data,data_a_two.data,data_a_three.data,data_a_four.data);
            data_a.counter = counter;
            data_a_final = data_a;
            
            
            % Randomly shuffle the order of the trials on EEG data
            [~, ~, m] = size(data_a.data);
            idx = randperm(m);     
            for q = 1:m
                data_a_final.data(:,:,q) = data_a.data(:,:,idx(q));
            end

            %% Merge data from condition b
            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
               char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values(1,1))) '.mat']);
            data_b_one = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
               char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values(1,2))) '.mat']);
            data_b_two = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values(1,3))) '.mat']);
            data_b_three = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values(1,4))) '.mat']);
            data_b_four= data_;

            % Join the data from the three subsamples
            data_b = data_b_one;
            data_b.filename = 'data_b.set';
            data_b.setname = 'data_b';
            data_b.filepath = dir.cond;
            data_b.trials = data_b.trials + data_b_two.trials...
                + data_b_three.trials + data_b_four.trials;
            data_b.data = cat(3,data_b.data,data_b_two.data,data_b_three.data,data_b_four.data);
            data_b.counter = counter;
            data_b_final = data_b;

            % Randomly shuffle the order of the trials on EEG data
            [~, ~, m] = size(data_b.data);
            idx = randperm(m);     
            for q = 1:m
                data_b_final.data(:,:,q) = data_b.data(:,:,idx(q));
            end

            %% Save data sets from condition A and condition B
            save([dir.cond 'data_a.mat'], 'data_a_final');
            save([dir.cond 'data_b.mat'], 'data_b_final');
end