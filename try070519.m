clear
clc

%% Prepare paths and regexp

mainPath = '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti';

%for the preprocessing : Volume selection
par.anat_file_reg  = '^s.*nii'; %le nom generique du volume pour l'anat
% par.file_reg  = '^f.*nii'; %le nom generique du volume pour les fonctionel

par.display=0;
par.run=0;
par.verbose = 2;
par.fsl_output_format  = 'NIFTI';
par.pct=0;


%% Get files paths

e = exam(mainPath,'2019_05_02_AMEDYST_C16_128_01_GC_043');

% T1
e.addSerie('S03_t1_mpr_sag_0_8iso_p2$','anat',1) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% t1_mpr_sag_0_8iso_p2$

e = e.removeIncomplete;
fprintf('removed non 3DT1 HR subj \n\n\n')

e.addVolume('anat','^s.*nii','s',1)

% SEQ
% e.addSerie('SEQ_run1$'        , 'SEQ_run1'        ,1)
% e.addSerie('SEQ_run1_refBLIP$', 'SEQ_run1_refBLIP',1) % refAP
% 
% % ADAPT
% e.addSerie('ADAPT_run1$'        , 'ADAPT_run1'        ,1)
% e.addSerie('ADAPT_run1_refBLIP$', 'ADAPT_run1_refBLIP',1) % refAP
% 
% % All func volumes
% e.getSerie('run').addVolume('^f.*nii','f',1)

% Unzip if necessary
e.unzipVolume(par)
% 
% e.reorderSeries('name'); % mostly useful for topup, that requires pairs of (AP,PA)/(PA,AP) scans
% 
% e.explore

subjectDirs = e.toJob;
% regex_dfonc    = 'run\d$'        ;
% regex_dfonc_op = 'run\d_refBLIP$';
% dfonc    = e.getSerie(regex_dfonc   ).toJob;
% dfonc_op = e.getSerie(regex_dfonc_op).toJob;
% dfoncall = e.getSerie('run'         ).toJob;
anat     = e.getSerie('anat'        ).toJob(0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0 = tic;


%% Segment anat

%anat segment
fanat = e.getSerie('anat').getVolume('^s').toJob;

par.GM        = [1 1 1 1]; % warped_space_Unmodulated(wp*) / warped_space_modulated(mwp*) / native_space(p*) / native_space_dartel_import(rp*)
par.WM        = [1 1 1 1];
par.CSF       = [1 1 1 1];
par.bias      = [1 1 0] ;  % native normalize dartel     [0 1]; % bias field / bias corrected image
par.warp      = [1 1]; % warp field native->template / warp field native<-template

par.jacobian  = 0;         % write jacobian determinant in normalize space
par.doROI     = 0;
par.doSurface = 0;
j_segment = job_do_segmentCAT12(fanat,par);
fy    = e.getSerie('anat').addVolume('^y'  ,'y'  ,1);
fanat = e.getSerie('anat').addVolume('^ms' ,'ms' ,1);
fanat = e.getSerie('anat').addVolume('^wms','wms',1);
e.getSerie('anat').addVolume('^wp1','wp1',1)
e.getSerie('anat').addVolume('^wp2','wp2',1)
e.getSerie('anat').addVolume('^wp3','wp3',1)

%% Preprocess fMRI runs

% slice timing
% par.slice_order = 'sequential_ascending';
% par.reference_slice='middle'; 
par.use_JSON = 1;
par.file_reg = '^f.*nii';
% par.TR = 2.030;
j_stc = job_slice_timing(dfoncall,par);
f = e.getSerie('run').addVolume('^af.*nii','af',1)

%realign and reslice & opposite phase
par.file_reg = '^af.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice = job_realign(dfoncall,par);
e.getSerie(regex_dfonc).addVolume('^raf.*nii','raf',1)
e.getSerie(regex_dfonc_op).addVolume('^raf.*nii','raf',1)

%topup and unwarp
par.file_reg = {'^raf.*nii'}; par.sge=0;
do_topup_unwarp_4D(dfoncall,par)
e.getSerie('run').addVolume('^utmeanaf','utmeanaf',1)
e.getSerie('run').addVolume('^utraf.*nii','utraf',1)

%coregister mean fonc on brain_anat
% fanat = get_subdir_regex_files(anat,'^s.*nii$',1) % raw anat
% fanat = get_subdir_regex_files(anat,'^ms.*nii$',1) % raw anat + signal bias correction
% fanat = get_subdir_regex_files(anat,'^brain_s.*nii$',1) % brain mask applied (not perfect, there are holes in the mask)
fanat = e.getSerie('anat').getVolume('^ms').toJob;

par.type = 'estimate';
% for nbs=1:length(subjectDirs)
%     fmean(nbs) = e.getSerie('ADAPT_run1$').getVolume('^utmeanf').toJob
% end
fmean = e.getSerie('ADAPT_run1$').getVolume('^utmeanaf').toJob
fo = e.getSerie(regex_dfonc).getVolume('^utraf').toJob
j_coregister=job_coregister(fmean,fanat,fo,par);

%apply normalize
fy = e.getSerie('anat').getVolume('^y').toJob
par.prefix = 'w';
j_apply_normalize=job_apply_normalize(fy,fo,par);
j_apply_normalize=job_apply_normalize(fy,fmean,par);
e.getSerie(regex_dfonc).addVolume('^wutraf','wutraf',1)
e.getSerie('ADAPT_run1$').addVolume('^wutmeanaf','wutmeanaf',1)

%smooth the data
ffonc = e.getSerie(regex_dfonc).getVolume('^wutraf').toJob;
par.smooth = [8 8 8];
par.prefix = sprintf('s%d',par.smooth(1));
j_smooth=job_smooth(ffonc,par);
e.getSerie(regex_dfonc).addVolume(sprintf('^s%dwutraf',par.smooth(1)),sprintf('s%dwutraf',par.smooth(1)),1)

% Coregister the wp[23] on fucntionnal volume, for TAPAS Noise ROI
src = e.getSerie('anat').getVolume('wp2').toJob;
oth = e.getSerie('anat').getVolume('wp3').toJob;
ref = e.getSerie('ADAPT_run1$').getVolume('^wutmeanaf').toJob;
par.type = 'estimate_and_write';
par.prefix = 'r';
job_coregister(src,ref,oth,par);
e.getSerie('anat').addVolume('^rwp2','rwp2',1)
e.getSerie('anat').addVolume('^rwp3','rwp3',1)

toc(t0)

save('e_orig','e') % always keep the original
save('e_stim','e') % work on this one
