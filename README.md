# LayerdMRI
This project is to segment the cerebral cortex into layers using diffusion MRI data based on von Economo atlas as presented in the paper:

"Cerebral Cortex Layer Segmentation Using Diffusion MRI in vivo with Applications to Laminar Connections and Working Memory Analysis", Jie Zhang, Zhe Sun, Feng Duan, Liang Shi, Yu Zhang, Jordi Solé-Casals1, and Cesar F. Caiafa, *xxxxx xxxx*, xx, xx, 2022 (under review).

Figure 1 below shows the pipeline to obtain layer segmentation from Diffusion MRI data.

![Fig 1](https://user-images.githubusercontent.com/11638664/172012776-f54e7a02-44d2-4152-b8d7-9b6d692d4f53.png "Fig. 1: Flow chart of the used method. First, we used preprocessed dMRI data to extract features from ADC and generalized fractional anisotropy for segmenting the cortex into layers by applying k-means clustering. The results were compared with histological data, with the superficial layer corresponding to Brodmann’s 1 to 3 layers and the deep layer corresponding to 4 to 6 layers. Finally, the results were used for laminar connections estimation and laminar analysis of working memory.") 



Figure 2 below shows the results of clustering some regions in two layers (superficial and deep).

<p align="center">
<img width="600" src="https://user-images.githubusercontent.com/11638664/172013948-ab5d2221-c74b-4b10-970c-a2575ccaae58.png" alt="Material Bread logo">
  
  Fig. 2: Clustering results of some axial sections of a subject. The results of a section of regions FA, OB, OC and PC are presented.
</p>
  
  




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
