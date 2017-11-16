clear
clc

imgdir   = [ pwd filesep 'img'];
stimdirs = [ pwd filesep 'stim'];
load('exarr_stim.mat')

regex_dfonc    = 'run\d$'        ;
regex_dfonc_op = 'run\d_refBLIP$';


%% Fetch stim files

examArray.getSerie(regex_dfonc).print
examArray.getSerie('SEQ_run1$').addStim(stimdirs,'Motor_MRI_1_SPM','SEQ_run1',1)
examArray.getSerie('SEQ_run2$').addStim(stimdirs,'Motor_MRI_2_SPM','SEQ_run2',1)

save('exarr_stim','examArray') % work on this one

% examArray.explore

%% prepare first level : groupe 8

statdir=r_mkdir(examArray.toJob,'stat');

SEQ_dir = r_mkdir(statdir,'SEQ');
do_delete(SEQ_dir,0)
SEQ_dir = r_mkdir(statdir,'SEQ');


par.file_reg = '^swutrf.*nii';
par.TR=2.030;
par.delete_previous=1;
par.rp = 1; % realignment paramters : movement regressors
par.run = 1;
par.display = 0;


%% Specify model : prepare list of (run,stimfile)

dfunc_SEQ = examArray.getSerie('SEQ_run\d$').toJob;
stim_SEQ = examArray.getSerie('SEQ_run\d$').getStim.toJob;


%% Specify model : job spm

j_specify_1 = job_first_level_specify(dfunc_SEQ,SEQ_dir,stim_SEQ,par);


%% Estimate model

session_all_dir = get_subdir_regex(statdir,'SEQ');
fspm = get_subdir_regex_files(session_all_dir,'SPM',1);
j_estimate = job_first_level_estimate(fspm,par);

