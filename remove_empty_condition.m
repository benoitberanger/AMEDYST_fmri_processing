clear
clc

stim_path = [ pwd filesep 'stim'];

%% Fetch stim files

% stimArray = exam(stim_path,'Pilote03');
% 
% stimArray.addVolumes

stim_dirs  = get_subdir_regex(stim_path,'AMEDYST');
stim_files = get_subdir_regex_files(stim_dirs,...
    'run\d{2}.mat$');
files = char(stim_files);

for f = 1 : size(files,1)
    
    filename = deblank(files(f,:));
    fprintf('%s\n',filename)
    
   l = load(filename);
   
   % Remove empty conditions
   empty_conditions     = cellfun(@isempty,l.onsets);
   non_empty_conditions = find(~empty_conditions);
   names     = l.names(non_empty_conditions);
   onsets    = l.onsets(non_empty_conditions);
   durations = l.durations(non_empty_conditions);
   
   % Remove L2-L5 and R2-R5
   
   fingers = regexp(names,'\d');
   fingers = cellfun(@isempty,fingers);
   fingers = find(fingers);
   
   names     = names(fingers);
   onsets    = onsets(fingers);
   durations = durations(fingers);
   
   save([filename(1:end-4) '_SPM' filename(end-3:end)],'names','onsets','durations')
   
end