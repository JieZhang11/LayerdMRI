% n_subjects=30;
% start_id=1002;
% end_id=1044;
% file=dir('features_*');
% features_name={file.name};
% file=dir('ids_*');
% ids_name={file.name};
% mean_adc_sup=[];
% mean_adc_deep=[];
% label_sup=[];
% label_deep=[];
% p=zeros(end_id-start_id+1,n_subjects);
% p=[(start_id:end_id)' p];
% dim=5;
% 
% for i=1:n_subjects
%     feature=importdata(features_name{i});
%     id=importdata(ids_name{i});
%     for j=start_id:end_id
%         if(isnan(layer_thickness_all(j-start_id+1,2*i)))
%             continue;
%         end
%         index1=[];
%         index2=[];
%         index3=[];
%         index1=find(feature(:,1)==j);
%         index2=index1(find(id(index1,2)==1));
%         index3=index1(find(id(index1,2)==2));
%         mean_adc_sup=[mean_adc_sup;feature(index2,dim)];
%         mean_adc_deep=[mean_adc_deep;feature(index3,dim)];
%         label_sup=[label_sup;(j)*ones(size(feature(index2,dim),1),1)];
%         label_deep=[label_deep;(j)*ones(size(feature(index3,dim),1),1)];
%         mean_adc(j-start_id+1,i*2)=std(feature(index2,dim));
%         mean_adc(j-start_id+1,i*2+1)=std(feature(index3,dim));
%         [~,p(j-start_id+1,i+1),~]=ttest2(feature(index2,dim),feature(index3,dim));
%         
%     end
% end
%  
position_1 = 0.8:1:40.8;
boxplot(mean_adc_sup,label_sup,'positions',position_1,'colors',[0.2 0.8 0.5],'width',0.2,'symbol',''); 
hold on
position_3 = 1.2:1:41.2; %
boxplot(mean_adc_deep,label_deep,'positions',position_3,'colors','r','width',0.2,'symbol','');
% hold on
% position_3 = 1:1:42; 
% boxplot(mean_adc_deep*0,label_deep,'colors','r','positions',position_3,'width',0.2,'symbol','');
set(gca,'XLim',[0 42],'YLim',[0 0.002],'XTickLabelRotation',60,'FontName','Arial','FontSize',12,'LineWidth',1); 
set(gcf,'unit','centimeters','position',[10 5 30 5.7]);
title('Mean ADC','FontName','Arial','FontSize',14,'FontWeight','bold');
xlabel('Regions','FontName','Arial','FontSize',12) 
box_vars=findall(gca,'Tag','Box');
% hLegend=legend(box_vars([44,1]),{'Superficial Layer','Deep Layer'});
set(gca, 'GridLineStyle', ':');  % …Ë÷√Œ™–Èœﬂ
grid on;
% hp=[];
% % hp_=[];
% for j=1002:1044
%     index1=find(label_sup==j);
%     index2=find(label_deep==j);
%     if isempty(index1)
%         continue;
%     else
%         x=mean_adc_sup(index1);
%         y=mean_adc_deep(index2);
%         [hx,px]=kstest(zscore(x));
%         [hy,py]=kstest(zscore(y));
%         if hx==0&&hy==0
%             [h,p]=ttest2(x,y,'Vartype','unequal');
%             hp=[hp; h p];
%             j
%         else
%             [p,h]=ranksum(x,y);
%             hp=[hp;h p];
%         end
%     end
% 
% end

