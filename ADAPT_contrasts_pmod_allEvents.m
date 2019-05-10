%% Contrast : definition

names = {
    
'Jitter'
'ShowProbability'
'PausePreMotor'
'PausePreReward'
'ShowReward'
'Direct_Pre____GoBack'
'Direct_Pre____GoBackxAUC'
'Direct_Pre____GoBackxRT'
'Direct_Pre____GoBackxTT'
'Deviation_____GoBack'
'Deviation_____GoBackxAUC'
'Deviation_____GoBackxRT'
'Deviation_____GoBackxTT'
'Direct_Post___GoBack'
'Direct_Post___GoBackxAUC'
'Direct_Post___GoBackxRT'
'Direct_Post___GoBackxTT'

};

r = struct;
for n = 1 : length(names)
    tmp = zeros(1,length(names));
    tmp(n) = 1;
    %     r.(names{n}) = tmp;
    eval([ names{n} ' = tmp;' ])
end

% -------------------------------------------------------------------------
contrast_T = struct;

contrast_T.names = {
    
'Jitter'
'ShowProbability'
'PausePreMotor'
'PausePreReward'
'ShowReward'
'Direct_Pre____GoBack'
'Direct_Pre____GoBackxAUC'
'Direct_Pre____GoBackxRT'
'Direct_Pre____GoBackxTT'
'Deviation_____GoBack'
'Deviation_____GoBackxAUC'
'Deviation_____GoBackxRT'
'Deviation_____GoBackxTT'
'Direct_Post___GoBack'
'Direct_Post___GoBackxAUC'
'Direct_Post___GoBackxRT'
'Direct_Post___GoBackxTT'

}';

contrast_T.values = {
    
Jitter
ShowProbability
PausePreMotor
PausePreReward
ShowReward
Direct_Pre____GoBack
Direct_Pre____GoBackxAUC
Direct_Pre____GoBackxRT
Direct_Pre____GoBackxTT
Deviation_____GoBack
Deviation_____GoBackxAUC
Deviation_____GoBackxRT
Deviation_____GoBackxTT
Direct_Post___GoBack
Direct_Post___GoBackxAUC
Direct_Post___GoBackxRT
Direct_Post___GoBackxTT

}';

contrast_T.types = cat(1,repmat({'T'},[1 length(contrast_T.names)]));

% -------------------------------------------------------------------------

contrast_F = struct;

contrast_F.names = {
    'F-all'
    'F : motor'
    }';

contrast_F.values = {
    [
    Jitter
    ShowProbability
    PausePreMotor
    PausePreReward
    ShowReward
    Direct_Pre____GoBack
    Direct_Pre____GoBackxAUC
    Direct_Pre____GoBackxRT
    Direct_Pre____GoBackxTT
    Deviation_____GoBack
    Deviation_____GoBackxAUC
    Deviation_____GoBackxRT
    Deviation_____GoBackxTT
    Direct_Post___GoBack
    Direct_Post___GoBackxAUC
    Direct_Post___GoBackxRT
    Direct_Post___GoBackxTT
    ]
    
    [
    Direct_Pre____GoBack
    Direct_Pre____GoBackxAUC
    Direct_Pre____GoBackxRT
    Direct_Pre____GoBackxTT
    Deviation_____GoBack
    Deviation_____GoBackxAUC
    Deviation_____GoBackxRT
    Deviation_____GoBackxTT
    Direct_Post___GoBack
    Direct_Post___GoBackxAUC
    Direct_Post___GoBackxRT
    Direct_Post___GoBackxTT
    ]
    
    }';

contrast_F.types = cat(1,repmat({'F'},[1 length(contrast_F.names)]));

contrast = struct;
contrast.names  = [contrast_F.names  contrast_T.names ];
contrast.values = [contrast_F.values contrast_T.values];
contrast.types  = [contrast_F.types  contrast_T.types ];
contrast