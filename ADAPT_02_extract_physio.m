clear
clc

%% Prepare paths and regexp

mainPath = [ pwd filesep 'physio'];

subj = gdir(mainPath,'AMEDYST_Pilote3_02')
rundir = gdir(subj,'Physio')
physio_dcm_files = gfile(rundir,'UNKNOWN.dic$',1)

for f = 1 : length(physio_dcm_files)
    
    extractCMRRPhysio(physio_dcm_files{f})

end
