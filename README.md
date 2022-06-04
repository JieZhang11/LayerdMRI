# LayerdMRI
This project is to segment the cerebral cortex into layers using diffusion MRI based on von Economo atlas. 

## Dependencies
It needs the following software: Freesurfer, Mrtrix, LAYNII, python, and Matlab. Some Matlab codes about spherical harmonic (euler2rotationMatrix.m, getSHrotMtx.m, getTdesign.m, SphHarmonic.m, t_designs_1_21.mat) need be downloaded at https://github.com/polarch/Spherical-Harmonic-Transform. lh.colortable.txt, rh.colortable.txt, lh.economo.gcs, and rh.economo.gcs need to be downloaded from the Supplementary material in  
> Scholtens LH, de Reus MA, de Lange SC, Schmidt R, van den Heuvel MP. An MRI Von Economo - Koskinas atlas. Neuroimage. 2018 Apr 15;170:249-256. doi: 10.1016/j.neuroimage.2016.12.069

## Running
1. Download all the codes in a directory, including colortable.txt and economo.gcs. Prepare preprocessed dMRI and T1 data (T1w.nii.gz and data.nii.gz) in the same size and resolution. Change directories' names in preprocess.sh, and run it. 
After that, you will get a parcellation image based on von economo atlas economo.nii, ADC image adc.nii, and spherical harmonics coefficients image sh_adc.nii.

2. Enter the data directory, add the code directory into the Matlab path, and run RUN.m. You will get two directories: all_result_kmeans (containing K-means image in .nii format before and after adding GFA when k=2) and all_result_mat (containing features and K-means results when k=2-15 in .mat format). 

3. Layer thickness calculations when k=2 are as follows:
* It would be better to confirm every region's segmentation result. Actually, 1 represents the superficial layer, and 2 represents the deep layer, but not for all regions. Moreover, some regions are poorly segmented. Let us assume that all well-segmented regions are adjusted so that 1 represents the superficial layer and 2 represents the deep layer.
* Then change the directories' name in cal_thickness.sh, and run it. 
* Finally, run Matlab function LNthickness. You will get layer thickness in .mat format.

## Citations
> Scholtens LH, de Reus MA, de Lange SC, Schmidt R, van den Heuvel MP. An MRI Von Economo - Koskinas atlas. Neuroimage. 2018 Apr 15;170:249-256. doi: 10.1016/j.neuroimage.2016.12.069

> Archontis Politis, Microphone array processing for parametric spatial audio techniques, 2016 Doctoral Dissertation, Department of Signal Processing and Acoustics, Aalto University, Finland
