clear
clc

%% Prepare paths and regexp

mainPath = [ pwd filesep 'img'];

%for the preprocessing : Volume selection
par.anat_file_reg  = '^s.*nii'; %le nom generique du volume pour l'anat
par.file_reg  = '^f.*nii'; %le nom generique du volume pour les fonctionel

par.display=0;
par.run=1;
par.verbose = 2;


%% Get files paths

% dfonc = get_subdir_regex_multi(suj,par.dfonc_reg) % ; char(dfonc{:})
% dfonc_op = get_subdir_regex_multi(suj,par.dfonc_reg_oposit_phase)% ; char(dfonc_op{:})
% dfoncall = get_subdir_regex_multi(suj,{par.dfonc_reg,par.dfonc_reg_oposit_phase })% ; char(dfoncall{:})
% anat = get_subdir_regex_one(suj,par.danat_reg)% ; char(anat) %should be no warning

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

e = exam(mainPath,'AMEDYST_Pilote3_02');

% T1
e.addSerie('t1_mpr','anat',1)
e.addVolume('anat','^s.*nii','s',1)

% % SEQ
% e.addSerie('SEQ_run1$'        , 'SEQ_run1'        ,1)
% e.addSerie('SEQ_run1_refBLIP$', 'SEQ_run1_refBLIP',1) % refAP
% e.addSerie('SEQ_run2$'        , 'SEQ_run2'        ,1)
% e.addSerie('SEQ_run2_refBLIP$', 'SEQ_run2_refBLIP',1) % refAP
% e.addSerie('SEQ_run3$'        , 'SEQ_run3'        ,1)
% e.addSerie('SEQ_run3_refBLIP$', 'SEQ_run3_refBLIP',1) % refAP
% e.addSerie('SEQ_run4$'        , 'SEQ_run4'        ,1)
% e.addSerie('SEQ_run4_refBLIP$', 'SEQ_run4_refBLIP',1) % refAP

% ADAPT
e.addSerie('ADAPT_run1$'        , 'ADAPT_run1'        ,1)
e.addSerie('ADAPT_run1_refBLIP$', 'ADAPT_run1_refBLIP',1) % refAP
e.addSerie('ADAPT_run2$'        , 'ADAPT_run2'        ,1)
e.addSerie('ADAPT_run2_refBLIP$', 'ADAPT_run2_refBLIP',1) % refAP

% All func volumes
e.getSerie('run').addVolume('^f.*nii','f',1)

% Unzip if necessary
e.unzipVolume

e.reorderSeries('name'); % mostly useful for topup, that requires pairs of (AP,PA)/(PA,AP) scans

e.explore

subjectDirs = e.toJob
regex_dfonc    = 'run\d$'        ;
regex_dfonc_op = 'run\d_refBLIP$';
dfonc    = e.getSerie(regex_dfonc   ).toJob
dfonc_op = e.getSerie(regex_dfonc_op).toJob
dfoncall = e.getSerie('run'         ).toJob
anat     = e.getSerie('anat'        ).toJob(0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t0 = tic;


%% Segment anat

% %anat segment
% % anat = get_subdir_regex(suj,par.danat_reg)
% fanat = get_subdir_regex_files(anat,par.anat_file_reg,1)
% 
% par.GM   = [0 0 1 0]; % Unmodulated / modulated / native_space dartel / import
% par.WM   = [0 0 1 0];
% j_segment = job_do_segment(fanat,par)
% 
% %apply normalize on anat
% fy = get_subdir_regex_files(anat,'^y',1)
% fanat = get_subdir_regex_files(anat,'^ms',1)
% j_apply_normalise=job_apply_normalize(fy,fanat,par)

%anat segment
fanat = e.getSerie('anat').getVolume('^s').toJob

par.GM   = [1 0 1 0]; % Unmodulated / modulated / native_space dartel / import
par.WM   = [1 0 1 0];
par.CSF  = [1 0 1 0];
j_segment = job_do_segment(fanat,par)
fy    = e.getSerie('anat').addVolume('^y' ,'y' )
fanat = e.getSerie('anat').addVolume('^ms','ms')

%apply normalize on anat
j_apply_normalise=job_apply_normalize(fy,fanat,par)
e.getSerie('anat').addVolume('^wms','wms',1)


%% Brain extract

% ff=get_subdir_regex_files(anat,'^c[123]',3);
% fo=addsuffixtofilenames(anat,'/mask_brain');
% do_fsl_add(ff,fo)
% fm=get_subdir_regex_files(anat,'^mask_b',1); fanat=get_subdir_regex_files(anat,'^s.*nii',1);
% fo = addprefixtofilenames(fanat,'brain_');
% do_fsl_mult(concat_cell(fm,fanat),fo);

ff=e.getSerie('anat').addVolume('^c[123]','c',3)
e.getSerie('anat').addVolume('^wc[123]','wc',3)
fo=addsuffixtofilenames(anat{1}(1,:),'/mask_brain');
do_fsl_add(ff,fo)

fm=e.getSerie('anat').addVolume('^mask_b','mask_brain',1)
fanat=e.getSerie('anat').getVolume('^s').toJob
fo = addprefixtofilenames(fanat,'brain_');
do_fsl_mult(concat_cell(fm,fanat),fo);
e.getSerie('anat').addVolume('^brain_','brain_',1)


%% Preprocess fMRI runs

% slice timing
% par.slice_order = 'sequential_ascending';
% par.reference_slice='middle'; 
par.use_JSON = 1;
par.file_reg = '^f.*nii';
par.TR = 2.030;
j_stc = job_slice_timing(dfoncall,par);
e.getSerie('run').addVolume('^af.*nii','af',1)

%realign and reslice
par.file_reg = '^af.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice = job_realign(dfonc,par);
e.getSerie(regex_dfonc).addVolume('^raf.*nii','raf',1)
%realign and reslice opposite phase
par.file_reg = '^af.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice_op = job_realign(dfonc_op,par);
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
fanat = e.getSerie('anat').getVolume('^brain_').toJob

par.type = 'estimate';
% for nbs=1:length(subjectDirs)
%     fmean(nbs) = e.getSerie('ADAPT_run1$').getVolume('^utmeanf').toJob
% end
fmean = e.getSerie('ADAPT_run1$').getVolume('^utmeanaf').toJob
fo = e.getSerie(regex_dfonc).getVolume('^utraf').toJob
j_coregister=job_coregister(fmean,fanat,fo,par);

%apply normalize
fy = e.getSerie('anat').getVolume('^y').toJob
j_apply_normalize=job_apply_normalize(fy,fo,par);

%smooth the data
ffonc = e.getSerie(regex_dfonc).addVolume('^wutraf','wutraf',1)
par.smooth = [8 8 8];
par.prefix = sprintf('s%d',par.smooth(1));
j_smooth=job_smooth(ffonc,par);
e.getSerie(regex_dfonc).addVolume(sprintf('^s%dwutraf',par.smooth(1)),sprintf('s%dwutraf',par.smooth(1)),1)

toc(t0)

save('e_orig','e') % always keep the original
save('e_stim','e') % work on this one
