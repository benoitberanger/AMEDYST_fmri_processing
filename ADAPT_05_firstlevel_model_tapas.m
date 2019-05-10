clear
clc

load e_stim.mat

model_name = 'model_tapas_GoBack_together_pmod_AllEventsNoControlRegroup';


%% Prepare paths and regexp

niftipath = '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti';

par.verbose = 2;

par.display = 0;
par.run     = 0;
par.sge     = 1;


%% dirs & files


dirFonc = e.getSerie('ADAPT_run\d$').toJob;
dirStats = e.mkdir(model_name);
onsetFile = e.getSerie('ADAPT_run\d$').getStim('SPMready').toJob;


%% Specify

par.rp = 1;
par.rp_regex = 'multiple_regressors.txt';
par.file_reg  = '^s8w.*nii'; %le nom generique du volume pour les fonctionel

job_first_level_specify(dirFonc,dirStats,onsetFile,par);


%% Estimate

fspm = e.addModel(model_name,model_name);
save('e_stim','e') % work on this one

job_first_level_estimate(fspm,par);


%% Contrast : definition

ADAPT_contrasts_pmod_allEvents


%% Contrast : write

par.delete_previous = 1;
par.sessrep         = 'none';
par.report          = 0;
job_first_level_contrast(fspm,contrast,par);


%% Display

e.getModel(model_name).show
