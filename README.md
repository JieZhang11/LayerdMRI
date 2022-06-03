# LayerdMRI
This project is to segment the cerebral cortex into layers using diffusion MRI based on von Economo atlas. 

# Dependencies
It needs following software: Freesurfer, mrtrix, LAYNII, python, and matlab. Some matlab codes about spherical harmonic (euler2rotationMatrix.m, getSHrotMtx.m, getTdesign.m, SphHarmonic.m, t_designs_1_21.mat) need be download at https://github.com/polarch/Spherical-Harmonic-Transform. lh.colortable.txt, rh.colortable.txt,  lh.economo.gcs, and rh.economo.gcs are need be download from Supplementary material in 
> Scholtens LH, de Reus MA, de Lange SC, Schmidt R, van den Heuvel MP. An MRI Von Economo - Koskinas atlas. Neuroimage. 2018 Apr 15;170:249-256. doi: 10.1016/j.neuroimage.2016.12.069

Running

Prepare preprocessed dMRI and T1 data (T1w.nii.gz and data.nii.gz) which are in the same size and resolution. Change directories' name in preprocess.sh, and run it. 
After that, you will get parcellation image based on von economo atlas economo.nii, ADC image adc.nii, and spherical harmonics coefficients image sh_adc.nii.

Enter into data directory and add the code directory into path.
Run RUN.M. You will get two direcories: all_result_kmeans (containing K means image in .nii format before and after adding GFA when k=2) and all_result_mat (containing features and K means results when k=2-15). 

Analysis steps when k=2 are as follows:
You'd better to confirm every regions' segmentation result. Actually, 1 represent superficial layer and 2 represent deep layer, but not for all regions.  Moreover, some regions are poor segmented. Let's assume that all well-segmented regions are adjused so that 1 represents the superficial layer and 2 represents the deep layer.

Then change directories' name in cal_thickness.sh, and run it. 
Run LNthickness(fsdir,p)
