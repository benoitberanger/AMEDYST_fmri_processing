clear
clc

%% Prepare paths and regexp

mainPath = '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/physio';

if 0
    d = '/network/lustre/iss01/cenir/raw/irm/dicom_raw/PRISMA_AMEDYST';
    s = gdir(d,'.*');
    par.serreg = 'PhysioLog';
    r_copy_suj(s,mainPath,par)
end

subj = gdir(mainPath,'AMEDYST')
rundir = gdir(subj,'Physio')
physio_dcm_files = gfile(rundir,'UNKNOWN.dic$')

addpath /network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/Visite1 % for extractCMRRPhysio.m

for f = 1 : length(physio_dcm_files)
    
    extractCMRRPhysio(physio_dcm_files{f})

end
