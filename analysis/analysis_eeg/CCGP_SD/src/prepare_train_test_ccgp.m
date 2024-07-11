function [] = prepare_train_test_ccgp(sub,step_a,step_b,cond_a,cond_b,dir,combination)

%% Function to prepare train and test data according to the combination selected. 
% Test data for conditions a and b are a set of 2 (1 per condition) the 8 subsamples  from
% crossing all the variables. Train data for a and b are the remaining 6
% subsamples (3 for each conditon). 
    
           % Counter to know from which specific step of the analyses
           % is the data 
           counter.combination = combination;
           counter.step_a = step_a;
           counter.step_b = step_b;

           values = 1:4;
            
           if sub < 10
               sub_zeros = '00';
           else
               sub_zeros = '0';
           end

           %% Test data sets
           % Testing data from condition a
           load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,step_a)) '.mat']);
           test_a = data_;
           test_a.filename = 'test_a.set';
           test_a.setname = 'test_a';
           test_a.filepath = dir.cond;
           test_a.counter = counter;

           % Testing data from condition b
           load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,step_b)) '.mat']);
           test_b = data_;
           test_b.filename = 'test_b.set';
           test_b.setname = 'test_b';
           test_b.filepath = dir.cond;
           test_b.counter = counter;

           % Save test data sets
            save([dir.cond 'test_a.mat'], 'test_a');
            save([dir.cond 'test_b.mat'], 'test_b');
            clear test_a test_b 

            %% Train data sets

            % Obtain training labels for condition a
            values_train_a = setdiff(values,step_a);

            % Merge training data from condition A
            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values_train_a(1,1))) '.mat']);
            train_a_one = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values_train_a(1,2))) '.mat']);
            train_a_two = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_a(1,values_train_a(1,3))) '.mat']);
            train_a_three = data_;

            % Join the data from the three subsamples
            train_a = train_a_one;
            train_a.filename = 'train_a.set';
            train_a.setname = 'train_a';
            train_a.filepath = dir.cond;
            train_a.trials = train_a.trials + train_a_two.trials...
                + train_a_three.trials;
            train_a.data = cat(3,train_a.data,train_a_two.data,train_a_three.data);
            train_a.counter = counter;
            train_a_final = train_a;
            
            
            % Randomly shuffle the order of the trials on EEG data
            [~, ~, m] = size(train_a.data);
            idx = randperm(m);     
            for q = 1:m
                train_a_final.data(:,:,q) = train_a.data(:,:,idx(q));
            end

            % Obtain training labels for condition b
            values_train_b = setdiff(values,step_b);

             % Merge training data from condition b
            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
               char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values_train_b(1,1))) '.mat']);
            train_b_one = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
               char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values_train_b(1,2))) '.mat']);
            train_b_two = data_;

            load([ dir.der 'sub-' char(sub_zeros) num2str(sub) '/eeg/conditions/sub-'...
                char(sub_zeros) num2str(sub) '_task-inst-comp_eeg_' char(cond_b(1,values_train_b(1,3))) '.mat']);
            train_b_three = data_;

            % Join the data from the three subsamples
            train_b = train_b_one;
            train_b.filename = 'train_b.set';
            train_b.setname = 'train_b';
            train_b.filepath = dir.cond;
            train_b.trials = train_b.trials + train_b_two.trials...
                + train_b_three.trials;
            train_b.data = cat(3,train_b.data,train_b_two.data,train_b_three.data);
            train_b.counter = counter;
            train_b_final = train_b;

            % Randomly shuffle the order of the trials on EEG data
            [~, ~, m] = size(train_b.data);
            idx = randperm(m);     
            for q = 1:m
                train_b_final.data(:,:,q) = train_b.data(:,:,idx(q));
            end

            % Save training data sets
            save([dir.cond 'train_a.mat'], 'train_a_final');
            save([dir.cond 'train_b.mat'], 'train_b_final');
            toc;
end