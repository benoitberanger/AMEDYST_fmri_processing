clear
clc

load e_stim.mat


%% Add stim files

e.getSerie('ADAPT_run1$').addStim(fullfile(pwd,'stim'), 'ADAPT_.*_Plus_run01.mat$', 'raw', 1 )
e.getSerie('ADAPT_run2$').addStim(fullfile(pwd,'stim'), 'ADAPT_.*_Minus_run01.mat$', 'raw', 1 )

% e.explore

Files = e.getSerie('ADAPT_run\d$').getStim('raw');


for f = 1 : numel(Files)
    S=Files(f).load;
    S=S{1}.S.TaskData;
    DATA = S.RR.Data;

    to_remove = {'StartTime', 'StopTime', 'Draw'};
    for rem = 1 : length(to_remove)
        res = regexp(DATA(:,1),to_remove{rem});
        res = ~cellfun(@isempty,res);
        DATA(res,:) = [];
    end
    
    fusion_orig = {
        { 'Jitter__Direct_Pre' 'Jitter__Deviation' 'Jitter__Direct_Post' , 'PausePreMotor__Direct_Pre' 'PausePreMotor__Deviation' 'PausePreMotor__Direct_Post' , 'preReward__Direct_Pre' 'preReward__Deviation' 'preReward__Direct_Post' };
        { 'ShowProbability__Direct_Pre' 'ShowProbability__Deviation' 'ShowProbability__Direct_Post' };
        { 'Reward__Direct_Pre' 'Reward__Deviation' 'Reward__Direct_Post' };
        { 'Move@Ring__Direct_Pre' 'Move@Center__Direct_Pre' };
        { 'Move@Ring__Deviation' 'Move@Center__Deviation' };
        { 'Move@Ring__Direct_Post' 'Move@Center__Direct_Post' };
        };
    
    fusion_to = {
        'control'
        'ShowProbability'
        'Reward'
        'Direct_Pre____Motor'
        'Deviation_____Motor'
        'Direct_Post___Motor'
        };
    
    for n = 1 : numel(fusion_orig)
        for nn = 1 : numel(fusion_orig{n})
            DATA(:,1) = regexprep(DATA(:,1),fusion_orig{n}{nn},fusion_to{n});
        end
    end
    
    events = fusion_to;
    
    names     = cell(size(events));
    onsets    = cell(size(events));
    durations = cell(size(events));
    
    for evt = 1 : length(events)
        NAME = events{evt};
        names{evt,1}  = NAME;
        res = regexp(DATA(:,1),['^' NAME '$']);
        res = ~cellfun(@isempty,res);
        onsets   {evt,1} = cell2mat(DATA(res,2));
        durations{evt,1} = cell2mat(DATA(res,3));
    end
    
    names = regexprep(names,'@','');
    
    save([Files(f).path(1:end-4) '_SPMready' '.mat'],'names','onsets','durations')
    
end

e.getSerie('ADAPT_run1$').addStim(fullfile(pwd,'stim'), 'ADAPT_.*_Plus_run01_SPMready.mat$', 'SPMready', 1 )
e.getSerie('ADAPT_run2$').addStim(fullfile(pwd,'stim'), 'ADAPT_.*_Minus_run01_SPMready.mat$', 'SPMready', 1 )

% ER = EventRecorder;
% ER.Data = DATA;
% ER.Plot
% ER.PlotHRF(2.030)

%%

save('e_stim','e') % work on this one
