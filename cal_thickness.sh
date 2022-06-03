#!/bin/bash

# the FreeSurfer subject directory containing FreeSurfer output
SUBJECTS_DIR=/home/zj/fs_subjects/
# describing the directory that includes the lh.colortable.txt, rh.colortable.txt, lh.economo.gcs, rh.economo.gcs datafiles 
layerdMRI_DIR=/home/zj/LayerdMRI/code/
# describing the directory that includes the T1w.nii.gz and dMRI data.nii
DATA_DIR=/home/zj/LayerdMRI/data/
#Freesurfer subject name
SUBJECTNAME=fsLayerdMRI

cd ${SUBJECTS_DIR}/${SUBJECTNAME}/surf
mri_vol2surf --mov ${DATA_DIR}/economo.nii --regheader ${SUBJECTNAME} --projdist-max 0 1 0.1 --interp nearest --hemi lh --out lh.hcp.mgh
mri_segstats --seg lh.hcp.mgh --in lh.thickness --sum L_thickness.txt
mrcalc ${DATA_DIR}/economo.nii 1000 -gt - | mrcalc - 3 0 -if gm_economo.nii

mri_surf2vol --subject ${SUBJECTNAME} --mkmask --reg register.dat --template ${DATA_DIR}/T1w.nii.gz --hemi lh --fill-projfrac -0.5 0.2 0.05 --o lh_gmwm.nii
mri_surf2vol --subject ${SUBJECTNAME} --mkmask --reg register.dat --template ${DATA_DIR}/T1w.nii.gz --hemi lh --fill-projfrac 0.4 2 0.01 --o lh_gmcsf.nii
mrcalc lh_gmwm.nii 2 0 -if - | mrcalc gm_economo.nii gm_economo.nii - -if -  | mrcalc - - lh_gmcsf.nii -if lh_rim.nii

LN2_LAYERS -rim lh_rim.nii -thickness -output 1LN


mrcalc ${DATA_DIR}/all_result_kmeans/k2means.nii 2 -eq - | mrcalc - 2 lh_rim.nii -if  rim_eco_outer.nii

mrcalc ${DATA_DIR}/all_result_kmeans/k2means.nii 1 -eq - | mrcalc - 1 lh_rim.nii -if rim_eco_inner.nii

LN2_LAYERS -rim rim_eco_outer.nii -thickness -output 2LN_outer

LN2_LAYERS -rim rim_eco_inner.nii -thickness -output 2LN_inner

mrcalc ${DATA_DIR}/all_result_kmeans/k2means_fa.nii 2 -eq - | mrcalc - 2 lh_rim.nii -if rim_eco_fa_outer.nii

mrcalc ${DATA_DIR}/all_result_kmeans/k2means_fa.nii 1 -eq - | mrcalc - 1 lh_rim.nii -if rim_eco_fa_inner.nii

LN2_LAYERS -rim rim_eco_fa_outer.nii -thickness -output 3LN_fa_outer

LN2_LAYERS -rim rim_eco_fa_inner.nii -thickness -output 3LN_fa_inner

