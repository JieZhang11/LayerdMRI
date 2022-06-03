#!/bin/bash

# the FreeSurfer subject directory containing FreeSurfer output
SUBJECTS_DIR=/home/zj/1/fs_subjects/
# describing the directory that includes the code, lh.colortable.txt, rh.colortable.txt, lh.economo.gcs, rh.economo.gcs datafiles 
layerdMRI_DIR=/home/zj/1/LayerdMRI/code
# describing the directory that includes the T1w.nii.gz and dMRI data.nii.gz
DATA_DIR=/home/zj/1/LayerdMRI/data
#Freesurfer subject name
SUBJECTNAME=fsLayerdMRI

cd ${DATA_DIR}
recon-all -s ${SUBJECTNAME} -i T1w.nii.gz -all
spmregister --s fsaverage --mov T1w.nii.gz  --reg ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/register.dat 
mri_surf2vol --subject ${SUBJECTNAME} --mkmask --reg ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/register.dat --template T1w.nii.gz --hemi lh --fill-projfrac 0 1 0.05 --o lh_gm.nii --vtxvol ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/lh_vertex_.nii

dwiextract -fslgrad bvecs bvals -shells 2000 -export_grad_fsl bvecs2000 bvals2000  data.nii.gz dti_b2000.nii
dwiextract -fslgrad bvecs bvals -shells 0  data.nii.gz - | mrmath - mean mean_b0.nii -axis 3
mrcalc dti_b2000.nii mean_b0.nii -divide -log -2000 -divide adc.nii
amp2sh -lmax 6 -fslgrad bvecs2000 bvals2000 adc.nii sh_adc.nii

mris_convert -n ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/lh.white ${DATA_DIR}/lh_norm.asc
mris_ca_label -t ${layerdMRI_DIR}/lh.colortable.txt ${SUBJECTNAME} lh ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/lh.sphere.reg ${layerdMRI_DIR}/lh.economo.gcs ${SUBJECTS_DIR}/${SUBJECTNAME}/label/lh.economo.annot
mris_ca_label -t ${layerdMRI_DIR}/rh.colortable.txt ${SUBJECTNAME} rh ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/rh.sphere.reg ${layerdMRI_DIR}/rh.economo.gcs ${SUBJECTS_DIR}/${SUBJECTNAME}/label/rh.economo.annot
mri_aparc2aseg --old-ribbon --s ${SUBJECTNAME} --annot economo --o ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/economo.mgz
mrconvert -datatype uint32 ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/economo.mgz ${SUBJECTS_DIR}/${SUBJECTNAME}/surf/economo.nii

cd ${layerdMRI_DIR}
python3 -c 'import change_header; change_header.change_header("'${DATA_DIR}'","'${SUBJECTS_DIR}/${SUBJECTNAME}'")'
python3 -c 'import roi2T1; roi2T1.gmwm2T1("'${DATA_DIR}'","'${SUBJECTS_DIR}/${SUBJECTNAME}'","economo.nii")'
