clear
clc

load e_orig.mat

physio_path = '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/physio';

dirFunc = e.getSerie('run\d$').toJob;


%% Fetch physio dirs

% skip = [];
% 
% for subj = 1 : length(dirFunc)
%     
%     for run = 1 : length(dirFunc{subj})
%             
%         res1 = strsplit(dirFunc{subj}{run},filesep);
%         subjname = res1{13};
%         runname  = res1{14};
%         
%         beg_idx = regexp(runname,'^S','once');
%         end_idx = regexp(runname,'_','once');
%         
%         num = runname( beg_idx+1 : end_idx-1);
%         new_num = str2double(num) + 1;
%         new_runname = sprintf('S%0.2d%s', new_num, runname(4:end) );
%         
%         physio_dir= fullfile(physio_path, subjname, [ new_runname '_PhysioLog' ]);
%         
%         if ~exist(physio_dir,'dir')
%             warning('dir does not exists : %s', physio_dir)
%             skip = [skip subj];
%         end
% %         
% %         dirPhysio{subj}{1} = char(gdir(subj_physio,'ADAPT_run1_PhysioLog'));
% %         %     dirPhysio{subj}{2} = char(gdir(subj_physio,'ADAPT_run2_PhysioLog'));
%         
%     end
%     
% end
% 
% return

% dirPhysio


%% Fetch noise ROI dirs

% dirNoiseROI = e.getSerie('anat').toJob(0)


%% dirNoiseROI



dirNoiseROI = e.getSerie('anat').toJob(0);


%%

par.file_reg = '^f.*nii'; % to fetch volume info (nrVolumes, nrSlices, TR, ...)

% Physio regressors types
par.usePhysio = 0;
par.RETROICOR = 0;
par.RVT       = 0;
par.HRV       = 0;

% Noise ROI regressors
par.noiseROI = 1;
par.noiseROI_files_regex  = '^wutraf.*nii';       % usually use normalied files, NOT the smoothed data
par.noiseROI_mask_regex   = '^rwp[23].*nii'; % 2 = WM, 3 = CSF
par.noiseROI_thresholds   = [0.95 0.95];     % keep voxels with tissu probabilty >= 95%
par.noiseROI_n_voxel_crop = [2 1];           % crop n voxels in each direction, to avoid partial volume
par.noiseROI_n_components = 10;              % keep n PCA componenets

% Movement regressors
par.rp           = 1;
par.rp_regex     = '^rp.*txt';
par.rp_order     = 24; % can be 6, 12, 24
% 6 = just add rp, 12 = also adds first order derivatives, 24 = also adds first + second order derivatives
par.rp_method    = 'FD'; % 'MAXVAL' / 'FD' / 'DVARS'
par.rp_threshold = 1.5;  % Threshold above which a stick regressor is created for corresponding volume of exceeding value

par.print_figures = 0;

par.run     = 0;
par.display = 0;
par.sge     = 1;

% par.verbose = 2;

job_physio_tapas( dirFunc, [], dirNoiseROI, par);
