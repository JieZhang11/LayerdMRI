%% Extract features to segment cortex into layers. The rows of features represent the voxel. 
% the first column is the ROI number, 2-4 is the voxel coordinates, and 5: end is the features
function []=extract_features_all
% The orientation perpendicular to the cortex (normal direction) is converted to .Mat format
lhnorm=asc2mat('lh_norm','.asc');
n_vertices=int32(lhnorm(3,1));
lhnorm=lhnorm(4:n_vertices+3,:);
% Convert Cartesian coordinates to spherical coordinates
[aziElev(:,1),aziElev(:,2)]=cart2sph_(lhnorm(:,1),lhnorm(:,2),lhnorm(:,3));
save('aziElev.mat','aziElev');
V_area=niftiread('economo.nii');
%volume of spherical hamo[]=nic coefficient
info=niftiinfo('sh_adc.nii');
V_coef=niftiread(info);
% %volume of the corresponding vertex number index of roi
name='lh_vertex_.nii';
V_vertex=niftiread(name);
V_GFA=niftiread('T1w.nii.gz')*0;
% [aziElev(:,1),aziElev(:,2)]=cart2sph_(lhnorm(:,1),lhnorm(:,2),lhnorm(:,3));
% save('aziElev.mat','aziElev');
normal_directions=importdata('aziElev.mat');
Vsize=size(V_vertex);
%area start id and end id
start_id=1002;
end_id=1044;
%6-order
N=6;
n_coef=28;
features=[];

% Generate a uniform grid for 21th-order integration
[~, tdesign_grid] = getTdesign(21);
Ktdes = size(tdesign_grid,1);

for i=1:Vsize(3)
    %V_area_i=V_area(:,:,i);
    %position of roi
    [pos1,pos2]=find(V_area(:,:,i)>=start_id&V_area(:,:,i)<=end_id);
    if ~isempty(pos1)
        pos_size=size(pos1);
        pos_size=pos_size(1);
        %position of voxel:3    feature:31
        %=area_id + pos(3) + 1 mean_adc+28 coefficient+1 normal+1 tangential plane +fa
        feature=[zeros(pos_size,1) pos1 pos2 ones(pos_size,1)*i zeros(pos_size,n_coef+4)];
        for j=1:pos_size
            posx=pos1(j);
            posy=pos2(j);
            %coefficient of sh
            coef=V_coef(posx,posy,i,:);
            coef=coef(:);
            %some voxels are 'inf' in sh_adc.nii
            if isinf(coef(1))
                feature(j,1)=inf;
%                 disp([pos1(j),pos2(j),i]);
                continue;
            end
            vertex_index=V_vertex(posx,posy,i)+1;
            if(vertex_index==0)
                feature(j,1)=inf;
%                 disp([pos1(j),pos2(j),i]);
                continue;
            end
            
            %feature:area id
            feature(j,1)=V_area(posx,posy,i);
            
            %feature:mean adc
            amp_grid = SphHarmonic(N,tdesign_grid,coef);
            % Integrate by direct summation
            Int = (1/Ktdes)*sum(amp_grid);
            feature(j,5)=Int;
            
            %feature:coefficient of sh
            %feature(j,5:n_coef+4)=coef;
            
            %feature:sh of normal diretion
            
            normal_dir=normal_directions(vertex_index,:);
            amp_normal = SphHarmonic(N,normal_dir,coef);
            feature(j,n_coef+6)=amp_normal;
            
            %%transform of sh. Rotate z to coincide with the normal direction
            % desired orientation of the rotated function, in Euler Z-Y'-Z'' convention
            alpha = normal_dir(1);
            beta = -normal_dir(2);
            % define the rotation matrices
            R = euler2rotationMatrix(alpha, beta, 0, 'zyz');
            % rotation matrices using the recursive method for real SHs
            R_rSH = getSHrotMtx(R, N, 'real');
            % rotated coefficients of real function
            coef_rot = R_rSH*coef;
            
            %feature: sh in tangential plane
            integral_rot=xyIntegral(N,coef_rot);
            feature(j,n_coef+7)=integral_rot;
            
            %feature: GFA
            V_GFA(posx,posy,i)=sqrt((Ktdes*sum((amp_grid-Int).^2))/(Ktdes-1)*sum((amp_grid).^2));
            feature(j,n_coef+8)=V_GFA(posx,posy,i);
            
            %feature:coefficient of sh
            feature(j,6:n_coef+5)=coef_rot;
            
        end
        features=[features;feature];
    end
end
info=niftiinfo('T1w.nii.gz');
niftiwrite(V_GFA,'GFA.nii',info);
f1=find(features==inf);
features(f1,:)=[];
[f1,f2]=find(isnan(features));
features(f1,:)=[];
folder='./all_result_mat/';
if ~exist(folder,'dir')
    mkdir(folder);
end
folder='./all_result_kmeans/';
if ~exist(folder,'dir')
    mkdir(folder);
end
features=sortrows(features);
name=['all_result_mat/features.mat'];
save(name,'features');


