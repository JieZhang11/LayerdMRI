
import nibabel as nib
import numpy as np
# import pandas as pd
#import os

def change_header(str0,str1):
    mask_img_path = str0+'/T1w.nii.gz'
    mask_img = nib.load(mask_img_path)
    #mask_data = mask_img.get_data()


    target_img_path = str1+'/surf/lh_vertex_.nii'
    target_img = nib.load(target_img_path)
    target_data = target_img.get_data()
    # print(save_data.shape)


    save_nifti = nib.Nifti1Image(target_data, mask_img.affine, mask_img.header)
    #print(mask_img.header)
    #print(target_img.header)
    #print(save_nifti.shape)
    nib.save(save_nifti, str0+'/lh_vertex_.nii')
    #save_nifti_ = nib.Nifti1Image(mask_data, mask_img.affine, mask_img.header)
