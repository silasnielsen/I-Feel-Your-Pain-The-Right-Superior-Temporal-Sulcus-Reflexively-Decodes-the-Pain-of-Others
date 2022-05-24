%% STS label

% reslice STS label
system(['mri_convert -rl ../brain.nii rctx_rh_S_temporal_sup.nii rctx_rh_S_temporal_sup_resliced_trilin.nii']); % reslice trilinear

% vol > 0
clear all;
tmp = MRIread('rctx_rh_S_temporal_sup_resliced_trilin.nii');
vol = tmp.vol;
vol = single(vol>0);
tmp.vol = vol;
MRIwrite(tmp,'new_rctx_rh_S_temporal_sup_resliced_trilin_mask.nii','float');

% vol2surf (vol>0)
system(['mri_vol2surf --mov new_rctx_rh_S_temporal_sup_resliced_trilin_mask.nii --reg ../brainregister.lta --projfrac 0.5 --interp nearest --hemi rh --o fsavg_rctx_rh_S_temporal_sup_resliced_trilin_mask.nii']);
