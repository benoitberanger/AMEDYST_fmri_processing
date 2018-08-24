%% Clean matlab workspace

clear
clc


%% Fetch dirs 

% dir_func = '/home/asya.ekmen/Data_local/DataProcessed/2018_06_04_DEV_273_AMEDYST_Pilote2/S04_RS';
% dir_anat = '/home/asya.ekmen/Data_local/DataProcessed/2018_06_04_DEV_273_AMEDYST_Pilote2/S02_t1_mpr_sag_0_8iso_p2';

data_main_dir = fullfile( pwd , 'img' );

subject_dir = get_subdir_regex(data_main_dir,'AMEDYST_Pilote2')

dir_func = get_subdir_regex_multi(subject_dir,'RS$')
dir_anat = get_subdir_regex(subject_dir,'t1mpr_SAG_NSel_S176_1iso_p2$')

%%

par.verbose = 2;
par.fake = 0;

[ job ] = job_meica_afni( dir_func, dir_anat, par )
