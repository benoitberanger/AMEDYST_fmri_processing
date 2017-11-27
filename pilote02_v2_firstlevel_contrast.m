clear
clc

imgdir   = [ pwd filesep 'img'];
stimdirs = [ pwd filesep 'stim'];
load('exarr_stim_pilote02_v2.mat')

statdir = get_subdir_regex(examArray.toJob,'stat');
session_all_dir = get_subdir_regex(statdir,'SEQ');
fspm = get_subdir_regex_files(session_all_dir,'SPM',1);

par.delete_previous=1;
par.run = 1;
par.display = 0;
par.sessrep = 'none';

%% Contrasts basics

rp = [0 0 0 0 0 0];

% 2 conditions for each run
null    = [0 0 0 rp];
rest    = [1 0 0 rp];
simple  = [0 1 0 rp];
complex = [0 0 1 rp];


%% Define contrasts

par.sessrep = 'none';

% T-contrast

contrast(1).names_T = {
    
'No-Feedback 1   : simple-rest'
'No-Feedback 2   : simple-rest'
'   Feedback 1   : simple-rest'
'   Feedback 2   : simple-rest'

'No-Feedback 1   : complex-rest'
'No-Feedback 2   : complex-rest'
'   Feedback 1   : complex-rest'
'   Feedback 2   : complex-rest'


'No-Feedback 1   : simple-complex'
'No-Feedback 2   : simple-complex'
'   Feedback 1   : simple-complex'
'   Feedback 2   : simple-complex'

'No-Feedback 1   : complex-simple'
'No-Feedback 2   : complex-simple'
'   Feedback 1   : complex-simple'
'   Feedback 2   : complex-simple'


'No-Feedback 1+2 : simple-rest'
'   Feedback 1+2 : simple-rest'

'No-Feedback 1+2 : complex-rest'
'   Feedback 1+2 : complex-rest'


'No-Feedback 1+2 : simple-complex'
'   Feedback 1+2 : simple-complex'

'No-Feedback 1+2 : complex-simple'
'   Feedback 1+2 : complex-simple'

'Simple  increase of activity'
'Simple  decrease of activity'
'Complex increase of activity'
'Complex decrease of activity'

}';

contrast(1).values_T = {
    
[simple-rest null null null]
[null simple-rest null null]
[null null simple-rest null]
[null null null simple-rest]

[complex-rest null null null]
[null complex-rest null null]
[null null complex-rest null]
[null null null complex-rest]


[simple-complex null null null]
[null simple-complex null null]
[null null simple-complex null]
[null null null simple-complex]

[complex-simple null null null]
[null complex-simple null null]
[null null complex-simple null]
[null null null complex-simple]


[simple-rest simple-rest null null]
[null null simple-rest simple-rest]

[complex-rest complex-rest null null]
[null null complex-rest complex-rest]


[simple-complex simple-complex null null]
[null null simple-complex simple-complex]

[complex-simple complex-simple null null]
[null null complex-simple complex-simple]

[-2*simple -1*simple  1*simple  2*simple]
[ 2*simple  1*simple -1*simple -2*simple]
[-2*complex -1*complex  1*complex  2*complex]
[ 2*complex  1*complex -1*complex -2*complex]

}';

contrast(1).types_T = cat(1,repmat({'T'},[1 length(contrast(1).names_T)]));

% F-contrast
contrast(1).names_F = {}';
contrast(1).values_F = {}';
contrast(1).types_F = cat(1,repmat({'F'},[1 length(contrast(1).names_F)]));

% Combine F and T
contrast(1).names = [contrast(1).names_T contrast(1).names_F];
contrast(1).values = [contrast(1).values_T contrast(1).values_F];
contrast(1).types = [contrast(1).types_T contrast(1).types_F];



%% Estimate contrast

j_contrast_both = job_first_level_contrast(fspm,contrast(1),par);
par.delete_previous = 0;


% %% Define contrasts
% 
% par.sessrep = 'none';
% 
% % T-contrast
% 
% contrast(2).names_T = {
%     
% 'Complex 2 - 1'
% 'Complex 1 - 2'
% 
% 'Simple 2 - 1'
% 'Simple 1 - 2'
% 
% }';
% 
% contrast(2).values_T = {
%     
% [-complex +complex]
% [+complex -complex]
% 
% [-simple +simple]
% [+simple -simple]
% 
% }';
% 
% contrast(2).types_T = cat(1,repmat({'T'},[1 length(contrast(2).names_T)]));
% 
% % F-contrast
% contrast(2).names_F = {}';
% contrast(2).values_F = {}';
% contrast(2).types_F = cat(1,repmat({'F'},[1 length(contrast(2).names_F)]));
% 
% % Combine F and T
% contrast(2).names = [contrast(2).names_T contrast(2).names_F];
% contrast(2).values = [contrast(2).values_T contrast(2).values_F];
% contrast(2).types = [contrast(2).types_T contrast(2).types_F];
% 
% 
% 
% %% Estimate contrast
% 
% j_contrast = job_first_level_contrast(fspm,contrast(2),par);


%% Show results

matlabbatch{1}.spm.stats.results.spmmat = fspm(1);
matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
matlabbatch{1}.spm.stats.results.conspec.contrasts = 1;
matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'FWE';
matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
matlabbatch{1}.spm.stats.results.conspec.extent = 10;
matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
matlabbatch{1}.spm.stats.results.units = 1;
matlabbatch{1}.spm.stats.results.print = false;
matlabbatch{1}.spm.stats.results.write.none = 1;

spm_jobman('run',matlabbatch)
