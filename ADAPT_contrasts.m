%% Contrast : definition

l = load(deblank(onsetFile{1}(1,:)));
names = l.names;

for n = 1 : length(names)
    tmp = zeros(1,length(names));
    tmp(n) = 1;
    r.(names{n}) = tmp;
end

contrast.names = {
    
'control'
'ShowProbability'
'Reward'
'Direct_Pre____Motor'
'Deviation_____Motor'
'Direct_Post___Motor'


'ShowProbability     - control'
'Reward              - control'
'Direct_Pre____Motor - control'
'Deviation_____Motor - control'
'Direct_Post___Motor - control'

'Deviation_____Motor - Direct_Pre____Motor'
'Direct_Pre____Motor + Deviation_____Motor + Direct_Post___Motor'

'-1*r.Direct_Pre____Motor+2*r.Deviation_____Motor-1*r.Direct_Post___Motor'

}';

contrast.values = {
    
r.control
r.ShowProbability
r.Reward
r.Direct_Pre____Motor
r.Deviation_____Motor
r.Direct_Post___Motor

r.ShowProbability     - r.control
r.Reward              - r.control
r.Direct_Pre____Motor - r.control
r.Deviation_____Motor - r.control
r.Direct_Post___Motor - r.control

r.Deviation_____Motor - r.Direct_Pre____Motor
r.Direct_Pre____Motor + r.Deviation_____Motor + r.Direct_Post___Motor

-1*r.Direct_Pre____Motor+2*r.Deviation_____Motor-1*r.Direct_Post___Motor

}';


contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));
