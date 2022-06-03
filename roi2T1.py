import nibabel as nib
import numpy as np

def gmwm2T1(str0,str1,str2):
    print(str2)
    T1_img_path = str0+'/T1w.nii.gz'
    T1_img = nib.load(T1_img_path)
    T1_data = T1_img.get_data()

    gmwm_img_path = str1+'/surf/'+str2
#hcpmmp1_parcels.nii'
    gmwm_img = nib.load(gmwm_img_path)
    gmwm_data = gmwm_img.get_data()

    dim = gmwm_data.shape
    trans_dim = T1_data.shape
    print(trans_dim, dim)
    #print(T1_img.header)
    #print(gmwm_img.header)
    trans_data = np.zeros((trans_dim[0], trans_dim[1], trans_dim[2]))
    for i in range (0, dim[0]):
        for j in range(0, dim[1]):
            for k in range(0, dim[2]):
                vox_gmwm = np.array([[i], [j], [k], [1]])

                pos = np.dot(gmwm_img.affine, vox_gmwm)

                vox_gmwm2T = np.dot(np.linalg.inv(T1_img.affine), pos)
                #print(vox_gmwm2T)
                vox_gmwm2T[0] = np.round(vox_gmwm2T[0])
                vox_gmwm2T[1] = np.round(vox_gmwm2T[1])
                vox_gmwm2T[2] = np.round(vox_gmwm2T[2])
                vox_gmwm2T[3] = np.round(vox_gmwm2T[3])
                vox_gmwm2T=vox_gmwm2T.astype(int)
                #print(vox_gmwm2T)
                if ((vox_gmwm2T[0] >= 0) & (vox_gmwm2T[0] < trans_dim[0])
                        & (vox_gmwm2T[1] >= 0) & (vox_gmwm2T[1] < trans_dim[1])
                        & (vox_gmwm2T[2] >= 0) & (vox_gmwm2T[2] < trans_dim[2])):
                        trans_data[vox_gmwm2T[0], vox_gmwm2T[1], vox_gmwm2T[2]] = gmwm_data[i][j][k]
                #trans_data[j+34][k+43][i+10] = gmwm_data[i][j][k]

    
    print(trans_data.shape)

    save_nifti = nib.Nifti1Image(trans_data, T1_img.affine, T1_img.header)
    print(save_nifti.shape)
    nib.save(save_nifti, str0+'/'+str2)
#hcpmmp1_parcels_coreg.nii')
    print(str0)#save_nifti.shape) 
