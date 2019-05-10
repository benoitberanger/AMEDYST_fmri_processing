clear
clc

addpath /network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/StimTemplate

load e_orig.mat

mainpath  = '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/';

% niftipath = fullfile(mainpath,'nifti');
stimpath  = fullfile(mainpath,'stim' );


if 0
    D = gdir(stimpath,'.*');
    for d = 1 : length(D)
        if strfind(D{d},'-')
            movefile(D{d},strrep(D{d},'-','_'))
        end
    end
end


%% Add stim files

e.getSerie('ADAPT_run1$').addStim(stimpath, 'ADAPT_\w+_\w+_run\d{2}.mat$', 'raw', 1 );

Files = e.getSerie('ADAPT_run\d$').getStim('raw');


for f = 1 : numel(Files)
    
    % Load data -----------------------------------------------------------
    
    fprintf('%d/%d : %s \n', f, numel(Files), Files(f).path)
    
    S=Files(f).load;
    S=S{1}.S;
    DATA = S.TaskData.RR.Data;
    
    % S.RR.Plot
    
    % Siplify data --------------------------------------------------------
    
    to_remove = {'StartTime', 'StopTime', 'Draw'};
    for rem = 1 : length(to_remove)
        res = regexp(DATA(:,1),to_remove{rem});
        res = ~cellfun(@isempty,res);
        DATA(res,:) = [];
    end
    
    old_version = ~any(strcmp(DATA(:,1),'Motor__RT__Direct_Post'));
    
    if old_version
        fusion_orig = {
            { 'Jitter'                 };
            { 'ShowProbability'        };
            { 'PausePreMotor'          };
            { 'preReward'              };
            { 'Reward'                 };
            { 'Move@Ring__Direct_Pre'  };
            { 'Move@Ring__Deviation'   };
            { 'Move@Ring__Direct_Post' };
            };
    else
        fusion_orig = {
            { 'Jitter'                  };
            { 'ShowProbability'         };
            { 'PausePreMotor'           };
            { 'PausePreReward'          };
            { 'ShowReward'              };
            { 'Motor__StartDirect_Pre'  };
            { 'Motor__StartDeviation'   };
            { 'Motor__StartDirect_Post' };
            };
    end
    
    
    fusion_to = {
        'Jitter'
        'ShowProbability'
        'PausePreMotor'
        'PausePreReward'
        'ShowReward'
        'Direct_Pre____GoBack'
        'Deviation_____GoBack'
        'Direct_Post___GoBack'
        };
    
    for evt = 1 : size(DATA,1)
        for n = 1 : numel(fusion_orig)
            for nn = 1 : numel(fusion_orig{n})
                if regexp(DATA{evt,1},['^' fusion_orig{n}{nn}])
                    DATA{evt,1} = fusion_to{n};
                end
            end
        end
    end
    
    events = fusion_to;
    
    % Build regressors ----------------------------------------------------
    
    names     = cell(size(events));
    onsets    = cell(size(events));
    durations = cell(size(events));
    
    for evt = 1 : length(events)
        NAME = events{evt};
        names{evt,1}  = NAME;
        res = regexp(DATA(:,1),['^' NAME '$']);
        res = ~cellfun(@isempty,res);
        
        onsets{evt,1} = cell2mat(DATA(res,2));
        if contains(NAME,'GoBack')
            GoBack  = strcmp(DATA(:,1),NAME);
            control = contains(DATA(:,1),'PausePreReward');
            durations{evt,1} = [];
            for c = 1 : length(GoBack)
                if GoBack(c) == 1
                    rest = find(control(c:end) == 1,1,'first') + c -2;
                    durations{evt,1} = [durations{evt,1} sum(cell2mat(DATA(c:rest,3)))];
                end
            end
        else
            durations{evt,1} = cell2mat(DATA(res,3));
        end
        
    end
    
    names = regexprep(names,'@','');
    
    % Parametric modulators -----------------------------------------------
    
    pmod(6).name {1} = 'AUC';
    pmod(6).param{1} =  S.Stats.global_AUC_inBlock.Direct__Pre.auc;
    pmod(6).poly {1} = 1;
    
    pmod(6).name {2} = 'RT';
    pmod(6).param{2} = [S.Stats.global_AUC_inBlock.Direct__Pre.Trials.RT];
    pmod(6).poly {2} = 1;
    
    pmod(6).name {3} = 'TT';
    pmod(6).param{3} = [S.Stats.global_AUC_inBlock.Direct__Pre.Trials.TT];
    pmod(6).poly {3} = 1;
    
    
    pmod(7).name {1} = 'AUC';
    pmod(7).param{1} =  S.Stats.global_AUC_inBlock.Deviation.auc;
    pmod(7).poly {1} = 1;
    
    pmod(7).name {2} = 'RT';
    pmod(7).param{2} = [S.Stats.global_AUC_inBlock.Deviation.Trials.RT];
    pmod(7).poly {2} = 1;
    
    pmod(7).name {3} = 'TT';
    pmod(7).param{3} = [S.Stats.global_AUC_inBlock.Deviation.Trials.TT];
    pmod(7).poly {3} = 1;
    
    
    pmod(8).name {1} = 'AUC';
    pmod(8).param{1} =  S.Stats.global_AUC_inBlock.Direct__Post.auc;
    pmod(8).poly {1} = 1;
    
    pmod(8).name {2} = 'RT';
    pmod(8).param{2} = [S.Stats.global_AUC_inBlock.Direct__Post.Trials.RT];
    pmod(8).poly {2} = 1;
    
    pmod(8).name {3} = 'TT';
    pmod(8).param{3} = [S.Stats.global_AUC_inBlock.Direct__Post.Trials.TT];
    pmod(8).poly {3} = 1;
    
    orth = num2cell(zeros(size(names)));
   
    % Check
    for c = 1 : length(pmod)
        for p = 1 : length(pmod(c).name)
            bad_modulator = any(isnan(pmod(c).param{p}));
            if bad_modulator
                warning('bad modulator')
                fprintf('%s %s\n', pmod(c).name{p}, Files(f).path)
                pmod(c).param{p}(isnan(pmod(c).param{p})) = nanmean(pmod(c).param{p});
            end
        end
    end
    
    % plotSPMnod(names,onsets,durations)
    
    save([Files(f).path(1:end-4) '_SPMready' '.mat'],'names','onsets','durations', 'pmod', 'orth')
    
end

e.getSerie('ADAPT_run1$').addStim(fullfile(pwd,'stim'), 'ADAPT_\w+_\w+_run\d+_SPMready.mat$', 'SPMready', 1 )


%%

save('e_stim','e') % work on this one
