%% Calculate stability of kmeans
n_rep=100;
n_subjects=1;
start_id=1002;
end_id=1044;
stability=[(start_id:end_id)' zeros(end_id-start_id+1,n_subjects)];
file=dir('features_*');
features_name={file.name};
file=dir('ids_fa_*');
ids_name={file.name};
% features_sta=importdata(name);
% [m,n]=size(features_sta);
% if(p==0)
%     n=n-1; 
% else
%     name=['id_fa_' area '.mat'];
%     id=importdata(name);
% end
for i=1:n_subjects
    feature=importdata(features_name{i});
    ids=importdata(ids_name{i});
    feature_sta=feature;
    feature_sta(:,5:end)=zscore(feature(:,5:end));
    for j=start_id:end_id
        features_sta_=[];
        index=find(feature(:,1)==j);
        m=size(index,1);
        features_sta_=[feature_sta(index,:)  (1:m)'];
        id=ids(index,2);
        m_=round(m*0.9);
        q=zeros(n_rep,1);
        for k=1:n_rep
            features_sta_random=features_sta_(randperm(m, m_),:);
            [id_random,center,sumD]=kmeans(features_sta_random(:,5:end-1),2, 'Replicates' ,100);
            c=0;
            for z=1:m_
                index1=features_sta_random(z,end);
                if(id(index1)==id_random(z))
                    c=c+1;
                end
            end
            q(k)=c/m_;
            if(q(k)<0.5)
                q(k)=1-q(k);
            end
        end
        stability(j-start_id+1,i+1)=mean(q);
    end
end

