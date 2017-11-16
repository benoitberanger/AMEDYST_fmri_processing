% function [ reg ] = extractRegressors( filename )

clear
clc

filename = '/mnt/data/benoit/Protocol/AMEDYST_2017/fmri/stim/2017_10_23_DEV_99_AMEDYST_pilote01/20171023T145200_JD_Motor_MRI.mat';
% filename = '/mnt/data/benoit/Protocol/AMEDYST_2017/fmri/stim/2017_10_23_DEV_99_AMEDYST_pilote01/20171023T150250_JD_Motor_MRI.mat';

load(filename) % load stim file
KL = S.TaskData.KL; % shortchut
mritTrigger_idx = 1;

if isempty(KL.KbEvents{mritTrigger_idx,2}{end,end})
    KL.KbEvents{mritTrigger_idx,2}{end,end} = 0;
end
data = cell2mat(KL.KbEvents{mritTrigger_idx,2});
KeyIsDown_idx = data(:,2) == 1;

volumes = struct;
volumes.onset = data(KeyIsDown_idx,1);
volumes.spacing = diff(volumes.onset);
volumes.N = length(volumes.onset);

ER = S.TaskData.ER;

Simple  = [];
Complex = [];
V = [];
for evt = 1 : ER.EventCount
    
    if ~isempty(ER.Data{evt,4})
        
        %         value = ER.Data{evt,4}.iti_mean / ER.Data{evt,4}.iti_std;
        %         value = ER.Data{evt,4}.N;
        %         value = ER.Data{evt,4}.speed;
        %         value = ER.Data{evt,4}.completSeq;
        %         value = ER.Data{evt,4}.iti_mean;
        %         value = ER.Data{evt,4}.error;
        ITI = ER.Data{evt,4}.iti(ER.Data{evt,4}.iti<10000);
        MEAN = round(mean(ITI));
        STD = round(std(ITI));
        value = MEAN/STD;
        switch ER.Data{evt,1}
            case 'Simple'
                Simple  = [Simple value]; %#ok<AGROW>
            case 'Complex'
                Complex = [Complex value]; %#ok<AGROW>
        end

    end
    
end

figure
hold on
plot(Simple,'-x')
plot(Complex,'-x')
legend('Simple','Complex')

% end % function
