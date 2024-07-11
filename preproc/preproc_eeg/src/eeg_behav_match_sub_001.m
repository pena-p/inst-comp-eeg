%% Match EEG and BEHAVIORAL datasets
% This function (1) loads the subject behavioral dataset and (2) compares
% it against the EEG triggers record to (3) include additional task
% information to the EEGLAB data structure. 

% By Ana F. Palenciano (palencianoap@ugr.es) [23.01.2023]

function events = eeg_behav_match_sub_001(cfg,subject,events)
id = subject.id;
path_behav = cfg.behav_dir;

% Identify participant and experimental details
id = ['sub_' num2str(str2double(id(5:end))) '_'];
sub_conf = load([path_behav id 'cfg.mat']); 
block_seq = sub_conf.p.block_seq;
clear sub_conf;
% EEG trigger labels:
events_EEG   = {events.type};
% Load participant dataset
events_behav = {'boundary'};
blockID      = {'boundary'};
trialID      = {'boundary'};
accuracy     = {'boundary'};
RT           = {'boundary'};
catch_T      = {'boundary'};
cong         = {'boundary'};
stim1        = {'boundary'};
stim2        = {'boundary'};
shape_A      = {'boundary'};
shape_B      = {'boundary'};
color_A      = {'boundary'};
color_B      = {'boundary'};
str4         = {'boundary'};
Correct_Response = {'boundary'};
font_att     = {'boundary'};
font_target  = {'boundary'};
font_feat    = {'boundary'};
font_resp    = {'boundary'};
cued_stim = {'boundary'};
im_local     = {'boundary'};
trial_type_loc = {'boundary'};
run_cnt = 0;
loc_cnt = 0;

for b = 1:cfg.exp.nblocks
    if block_seq(b) < 3
        run_cnt = run_cnt + 1;
        load([path_behav id 'run_' num2str(run_cnt) '.mat']);
        for t = 1:height(block)
            for e = {'Inst_1_', 'ISI_Inst_1_',...
                          'Inst_2_', 'ISI_Inst_2_',...
                          'Inst_3_', 'ISI_Inst_3_',...
                          'Inst_4_', 'ISI_Inst_4_',...
                          'PREP_', 'PROBE_', 'PROBE_FIX_', 'ITI_'}
                events_behav{end+1} = [e{1} block.attention{t} '_' ... 
                    block.category{t} '_' block.task{t}];
                blockID{end+1} = ['TASK_' num2str(run_cnt)];
                trialID{end+1} = num2str(t);
                accuracy{end+1} = block.acc(t);
                RT{end+1} = block.RT{t};
                catch_T{end+1} = block.Catch(t);
                cong{end+1} = block.cong(t);
                stim1{end+1} = block.stim1(t);
                stim2{end+1} = block.stim2(t);
                shape_A{end+1} = block.shape_A(t);
                shape_B{end+1} = block.shape_B(t);
                color_A{end+1} = block.color_A(t);
                color_B{end+1} = block.color_B(t);
                str4{end+1} = block.str4(t);
                Correct_Response{end+1} = block.CorrectR(t);
                font_att{end+1} = block.font_att(t);
                font_target{end+1} = block.font_target(t);
                font_feat{end+1} = block.font_feat(t);
                font_resp{end+1} = block.font_resp(t);
                cued_stim{end+1} = block.cued_stim(t);
                im_local{end+1} = nan;
                trial_type_loc{end+1} = nan; 
            end
        end
    elseif block_seq(b) == 3
        loc_cnt = loc_cnt + 1;
        load([path_behav id 'loc_run_' num2str(loc_cnt) '.mat']);
        for t = 1:height(block)
            for e = {'PROBE_', 'PROBE_FIX_', 'ITI_'}
                if strcmp(e{1},'ITI_')
                    events_behav{end+1} = 'LOC_ITI';
                else              
                    events_behav{end+1} = ['LOC_' e{1} block.cat{t} '_' ... 
                        num2str(block.trial_type(t)) '_' num2str(block.stim(t))];
                end
                blockID{end+1} = ['LOC_' num2str(loc_cnt)];
                trialID{end+1} = num2str(t);
                accuracy{end+1} = block.acc(t);
                RT{end+1} = block.RT(t);
                catch_T{end+1} = nan;
                cong{end+1} = nan;
                stim1{end+1} = nan;
                stim2{end+1} = nan;
                shape_A{end+1} = nan;
                shape_B{end+1} = nan;
                color_A{end+1} = nan;
                color_B{end+1} = nan;
                str4{end+1} = nan;
                Correct_Response{end+1} = block.correct_resp(t);
                font_att{end+1} = nan;
                font_target{end+1} = nan;
                font_feat{end+1} = nan;
                font_resp{end+1} = nan;
                cued_stim{end+1} = nan;
                im_local{end+1} = block.IM(t);
                trial_type_loc{end+1} = block.trial_type(t);
            end
        end
    end
end
% Check that both datasets match
for t = 1:length(events)
    if ~strcmp(events_behav{t},events_EEG{t})
        disp('ERROR - DATASETS DO NOT MATCH')
    end
end
% Append relevant info
% Append relevant info
for t = 1:length(events)
    events(t).catch_T = catch_T{t};
    if catch_T{t} == 1
        events(t).type = ['catch_' events(t).type];
        
    end
    events(t).accuracy = accuracy{t};
    
    if accuracy{t} == 0
        events(t).type = ['error_' events(t).type];
    end
    
%     events(t).trial_type_loc = trial_type_loc{t};
%     if trial_type_loc{t} == 1
%         events(t).type = ['switch_' events(t).type];
%     end
    
    events(t).RT = RT{t};
    events(t).blockID = blockID{t};
    events(t).trialID = trialID{t};
    events(t).cong = cong{t};    
    events(t).stim1 = stim1{t};
    events(t).stim2 = stim2{t};
    events(t).shape_A = shape_A{t};
    events(t).shape_B = shape_B{t};
    events(t).color_A = color_A{t};
    events(t).color_B = color_B{t};
    events(t).str4 = str4{t};
    events(t).Correct_Response = Correct_Response{t};
    events(t).font_att = font_att{t};
    events(t).font_target = font_target{t};
    events(t).font_feat = font_feat{t};
    events(t).font_resp = font_resp{t};
    events(t).cued_stim = cued_stim{t};
    events(t).im_local = im_local{t};
    events(t).trial_type_loc = trial_type_loc{t};

end

