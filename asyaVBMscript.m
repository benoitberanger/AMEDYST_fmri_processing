cd /network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/
root = '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/';
suj = get_subdir_regex(root,{'^2'});
p2 = get_subdir_regex(suj,{'_p2$'});
rc1 = get_subdir_regex_files(p2,{'^rp1s'});
    
matlabbatch{1}.spm.tools.dartel.mni_norm.template = {'/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_01_AMEDYST_C16_128_01_HA_014/S03_t1_mpr_sag_0_8iso_p2/Template_6.nii'};
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.flowfields = {
                                                                  '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_01_AMEDYST_C16_128_01_HA_014/S03_t1_mpr_sag_0_8iso_p2/u_rp1s_S03_t1_mpr_sag_0_8iso_p2_affine_Template.nii'
                                                                  '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_01_AMEDYST_C16_128_01_ST_015/S03_t1_mpr_sag_0_8iso_p2/u_rp1s_S03_t1_mpr_sag_0_8iso_p2_affine_Template.nii'
                                                                  '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_24_AMEDYST_C16_128_01_DG_017/S03_t1_mpr_sag_0_8iso_p2/u_rp1s_S03_t1_mpr_sag_0_8iso_p2_affine_Template.nii'
                                                                  '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_25_AMEDYST_C16_128_01_PI_018/S03_t1_mpr_sag_0_8iso_p2/u_rp1s_S03_t1_mpr_sag_0_8iso_p2_affine_Template.nii'
                                                                  '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_11_05_AMEDYST_C16_128_01_TA_022/S03_t1_mpr_sag_0_8iso_p2/u_rp1s_S03_t1_mpr_sag_0_8iso_p2_affine_Template.nii'
                                                                  };
matlabbatch{1}.spm.tools.dartel.mni_norm.data.subjs.images = {
                                                              {
                                                              '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_01_AMEDYST_C16_128_01_HA_014/S03_t1_mpr_sag_0_8iso_p2/p1s_S03_t1_mpr_sag_0_8iso_p2.nii'
                                                              '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_01_AMEDYST_C16_128_01_ST_015/S03_t1_mpr_sag_0_8iso_p2/p1s_S03_t1_mpr_sag_0_8iso_p2.nii'
                                                              '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_24_AMEDYST_C16_128_01_DG_017/S03_t1_mpr_sag_0_8iso_p2/p1s_S03_t1_mpr_sag_0_8iso_p2.nii'
                                                              '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_10_25_AMEDYST_C16_128_01_PI_018/S03_t1_mpr_sag_0_8iso_p2/p1s_S03_t1_mpr_sag_0_8iso_p2.nii'
                                                              '/network/lustre/iss01/cenir/analyse/irm/users/asya.ekmen/AMEDYST/benoit/nifti/2018_11_05_AMEDYST_C16_128_01_TA_022/S03_t1_mpr_sag_0_8iso_p2/p1s_S03_t1_mpr_sag_0_8iso_p2.nii'
                                                              }
                                                              }';
matlabbatch{1}.spm.tools.dartel.mni_norm.vox = [NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.bb = [NaN NaN NaN
                                               NaN NaN NaN];
matlabbatch{1}.spm.tools.dartel.mni_norm.preserve = 1;
matlabbatch{1}.spm.tools.dartel.mni_norm.fwhm = [8 8 8];

