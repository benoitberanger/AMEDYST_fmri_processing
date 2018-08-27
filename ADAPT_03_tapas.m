clear
clc

load e_orig.mat

physio_path = fullfile(pwd,'physio');

dirFunc = e.getSerie('ADAPT_run\d$').toJob


%% Fetch physio dirs

skip = [];

for subj = 1 : length(dirFunc)
    
    [~, subj_name] = get_parent_path(dirFunc{subj}{1},2);
    
    subj_physio = fullfile(physio_path,subj_name);
    
    if ~exist(subj_physio,'dir')
        warning('dir does not exists : %s', subj_physio)
        skip = [skip subj];
    end
    
    dirPhysio{subj}{1} = char(gdir(subj_physio,'ADAPT_run1_PhysioLog'));
    dirPhysio{subj}{2} = char(gdir(subj_physio,'ADAPT_run2_PhysioLog'));
   
end

dirPhysio


%% Fetch noise ROI dirs

dirNoiseROI = e.getSerie('anat').toJob(0)


%%

par.file_reg = '^f.*nii'; % to fetch volume info (nrVolumes, nrSlices, TR, ...)


par.run = 1;
par.display = 0;
par.print_figures = 1;

par.redo=0;
par.noiseROI=1;

par

job_physio_tapas( dirFunc, dirPhysio, dirNoiseROI, par);
