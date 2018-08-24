clear
clc

load e_orig.mat

physio_path = fullfile(pwd,'physio');

dirFunc = e.getSerie('ADAPT_run\d$').toJob


%%

for subj = 1 : length(dirFunc)
    
    [~, subj_name] = get_parent_path(dirFunc{subj}{1},2);
    
    subj_physio = fullfile(physio_path,subj_name);
    
    if ~exist(subj_physio,'dir')
        error('dir does not exists : %s', subj_physio)
    end
    
    
    
    dirPhysio{subj}{1,1} = char(gdir(subj_physio,'ADAPT_run1_PhysioLog'));
    dirPhysio{subj}{2,1} = char(gdir(subj_physio,'ADAPT_run2_PhysioLog'));
    

end

dirPhysio


%%

par.run = 0;
par.display = 1;
par.print_figures = 0;

par.redo=1;

par
job_physio_tapas( dirFunc, dirPhysio, par);
