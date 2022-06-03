%% Segment cortex into layers using kmeans when k=2-max_k. p=0 features dont contain GFA;p=1 features contain GFA
function []=k_means_all(p)

%area start id and end id
start_id=1002;
end_id=1044;
name=['all_result_mat/features.mat'];
features=importdata(name);
n=size(features,2);
features_sta=features;
features_sta(:,5:n) = zscore(features(:,5:n));
name=['all_result_mat/features_sta.mat'];
save(name,'features_sta');

n=size(features_sta,2);
m=size(features_sta,1);
%if features dont contain GFA
if(p==0)
    n=n-1;
end
%k=2~max_k
max_k=15;
id=zeros(m,max_k);
% SSE=zeros(max_k,1);
ids=[];
for a=start_id:end_id
    features_sta_area=[];
    [pos]=find(features_sta(:,1)==a);
    features_sta_area=features_sta(pos,:);
    id=[];
    for z=1:max_k
        [id(:,z),center,sumD]=kmeans(features_sta_area(:,5:n),z, 'Replicates' ,100);
        %SSE(z)=sum(sumD.*sumD);
        if(z==2)
            n1=sum(id(:,z)==1);
            n2=sum(id(:,z)==2);
            if(n1>n2)
                id(id(:,z)==1,z)=3;
                id(id(:,z)==2,z)=1;
                id(id(:,z)==3,z)=2;
            end
        end
    end
    ids=[ids;id];
end

name=['lh_vertex_.nii'];
info=niftiinfo(name);
V_id=niftiread(info);
V_id=V_id*0;
max_k=2;
for j=2:max_k
    for i=1:m
        %V_id(normalized_feature(i,1),normalized_feature(i,2),normalized_feature(i,3))=id(i);
        V_id(features_sta(i,2),features_sta(i,3),features_sta(i,4))=ids(i,j);
    end
    if(p==0)
        name=['all_result_kmeans/k' num2str(j) 'means.nii'];
        niftiwrite(V_id,name,info);
    else
        name=['all_result_kmeans/k' num2str(j) 'means_fa.nii'];
        niftiwrite(V_id,name,info);
    end
end

if(p==0)
    name=['all_result_mat/ids.mat'];
else
    name=['all_result_mat/ids_fa.mat'];
end
save(name,'ids');
