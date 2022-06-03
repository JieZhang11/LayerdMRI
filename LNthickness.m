%% Extact mean layer thickness of every region from Laynii and freesurfer. fsdir is freesufer subject directory. 
% p=0 is the layer thickness before adding GFA, p=1 is the layer thickness after adding GFA.
function LNthickness(fsdir,p)

%area start id and end id
start_id=1002;
end_id=1044;
if (p==0)
    V_thickness1=niftiread([fsdir '/surf/2LN_inner_thickness.nii']);
    V_thickness2=niftiread([fsdir '/surf/2LN_outer_thickness.nii']);
    V_baseline_inner=niftiread([fsdir '/surf/2LN_inner_midGM_equidist.nii']);
    V_baseline_outer=niftiread([fsdir '/surf/2LN_outer_midGM_equidist.nii']);
else
    V_thickness1=niftiread([fsdir '/surf/3LN_fa_inner_thickness.nii']);
    V_thickness2=niftiread([fsdir '/surf/3LN_fa_outer_thickness.nii']);
    V_baseline_inner=niftiread([fsdir '/surf/3LN_fa_inner_midGM_equidist.nii']);
    V_baseline_outer=niftiread([fsdir '/surf/3LN_fa_outer_midGM_equidist.nii']);
end
name=['economo.nii'];
V_roi=niftiread(name);
Vsize=size(V_roi);
thickness1=[];
thickness2=[];
% thickness2=[];
for i=1:Vsize(3)
    [index1,index2]=find(V_roi(:,:,i)>=start_id&V_roi(:,:,i)<=end_id);
    if(~isempty(index1))
        for j=1:size(index1)
            if V_baseline_inner(index1(j),index2(j),i)~=0
                if V_thickness1(index1(j),index2(j),i)~=0
                    thickness1=[thickness1;V_roi(index1(j),index2(j),i) V_thickness1(index1(j),index2(j),i)];
                end
            end
            if V_baseline_outer(index1(j),index2(j),i)~=0
                if V_thickness2(index1(j),index2(j),i)~=0
                    thickness2=[thickness2;V_roi(index1(j),index2(j),i) V_thickness2(index1(j),index2(j),i)];
                end
            end
        end
    end
end
layer_thickness=[];
for i=start_id:end_id
    index1=find(thickness1(:,1)==i);
    index2=find(thickness2(:,1)==i);
    layer_thickness=[layer_thickness; i mean(thickness2(index2,2)) mean(thickness1(index1,2))];
end
ratio=[layer_thickness(:,1) layer_thickness(:,2)./(layer_thickness(:,2)+layer_thickness(:,3))];
ratio(:,3)=1-ratio(:,2);
thickness = asc2mat([fsdir '/surf/L_thickness'],'.txt');
thickness(isnan(thickness))=[];
thickness=thickness(28:70);
layer_thickness(:,2:3)=thickness.*ratio(:,2:3);
if (p==0)
    save('thickness.mat','thickness');
    save('layer_thickness.mat','layer_thickness');
    save('ratio.mat','ratio');
else
    save('fa_thickness.mat','thickness');
    save('fa_layer_thickness.mat','layer_thickness');
    save('fa_ratio.mat','ratio');
end
