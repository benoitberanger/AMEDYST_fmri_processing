%% Contrast : definition

l = load(deblank(onsetFile{1}(1,:)));
names = l.names;

for n = 1 : length(names)
    tmp = zeros(1,length(names));
    tmp(n) = 1;
    r.(names{n}) = tmp;
end

% -------------------------------------------------------------------------
contrast_T = struct;

contrast_T.names = {
    
'control'
'ShowProbability'
'Reward'
'Direct_Pre____GoBack'
'Deviation_____GoBack'
'Direct_Post___GoBack'


'ShowProbability      - control'
'Reward               - control'
'Direct_Pre____GoBack - control'
'Deviation_____GoBack - control'
'Direct_Post___GoBack - control'

'Dev_GoBack - Direct_GoBack'
'GoBack All'

}';

contrast_T.values = {
    
r.control
r.ShowProbability
r.Reward
r.Direct_Pre____GoBack
r.Deviation_____GoBack
r.Direct_Post___GoBack


r.ShowProbability      - r.control
r.Reward               - r.control
r.Direct_Pre____GoBack - r.control
r.Deviation_____GoBack - r.control
r.Direct_Post___GoBack - r.control

r.Deviation_____GoBack - r.Direct_Pre____GoBack
r.Direct_Pre____GoBack + r.Deviation_____GoBack + r.Direct_Post___GoBack

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
    r.control
    r.ShowProbability
    r.Reward
    r.Direct_Pre____GoBack
    r.Deviation_____GoBack
    r.Direct_Post___GoBack
    ]

    [
    r.Direct_Pre____GoBack
    r.Deviation_____GoBack
    r.Direct_Post___GoBack
    ]
    
}';

contrast_F.types = cat(1,repmat({'F'},[1 length(contrast_F.names)]));

contrast = struct;
contrast.names  = [contrast_F.names  contrast_T.names ];
contrast.values = [contrast_F.values contrast_T.values];
contrast.types  = [contrast_F.types  contrast_T.types ];
contrast