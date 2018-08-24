clear
clc

load e_stim.mat

model_name = 'model_tapas';


%% Prepare paths and regexp

mainPath = [ pwd filesep 'img'];

par.display=0;
par.run=1;
par.verbose = 2;


%% dirs & files


dirFonc = e.getSerie('ADAPT_run\d$').toJob;
dirStats = e.mkdir(model_name);
onsetFile = e.getSerie('ADAPT_run\d$').getStim('SPMready').toJob;


%% Specify

par.rp = 1;
par.rp_regex = 'multiple_regressors.txt';
par.file_reg  = '^s.*nii'; %le nom generique du volume pour les fonctionel
% job_first_level_specify(dirFonc,dirStats,onsetFile,par);


%% Estimate

fspm = e.addModel(model_name,model_name);
save('e_stim','e') % work on this one

% job_first_level_estimate(fspm,par);


%% Contrast : definition

ADAPT_contrasts


%% Contrast : write

par.run = 1;
par.display = 0;

par.sessrep = 'repl';

par.delete_previous = 1;

job_first_level_contrast(fspm,contrast,par);


%% Display

e.getModel(model_name).show
