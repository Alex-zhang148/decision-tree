function tree = newBuildTree(train_features,train_targets,discrete_dim,layer,varargin)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����C4.5�������㷨����������
%training_features��ѵ������������  
%training_targets��ѵ�������������  
%discrete_dim������ά�ȵ������Ƿ�������������0ָ������������  
%layer:�ڵ��������Ĳ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if nargin>4
    pruning=varargin{1};
else
    pruning=35;
end
[fea, L]= size(train_features);  
ale= unique(train_targets);  
tree.feature_tosplit= 0;  
tree.location=inf;  %��ʼ������λ����inf  
        
if isempty(train_features)   
    return    
end    
           
if ((pruning > L) || (L == 1) ||(length(ale) == 1)) %���ʣ��ѵ������̫С(С��pruning)����ֻʣһ������ֻʣһ���ǩ���˳�    
    his= hist(train_targets, length(ale));  %ͳ�������ı�ǩ���ֱ�����ÿ����ǩ����Ŀ  
    [num, largest]= max(his); 
    tree.value= [];    
    tree.location  = [];    
    tree.child= ale(largest);
    return    
end    
         
for i = 1:length(ale) %�����б��ǩ����Ŀ   
    Pnode(i) = length(find(train_targets == ale(i))) / L; 
end   

%���㵱ǰ�ڵ����Ϣ�� 
Inode = -sum(Pnode.*LOG2F(Pnode));

        
el= zeros(1, fea);  %��¼ÿ����������Ϣ������  
location= ones(1, fea)*inf;
        
for i = 1:fea %����ÿ������    
    data= train_features(i,:); 
    pe= unique(data);    
    nu= length(pe);   
    if (discrete_dim(i)) %��ɢ����   
        node= zeros(length(ale), nu);
        for j = 1:length(ale) %����ÿ����ǩ    
            for k = 1:nu %����ÿ������ֵ    
                indices     = find((train_targets == ale(j)) && (train_features(i,:) == pe(k)));    
                node(j,k)  = length(indices);
            end    
        end    
        rocle= sum(node);
        P1= repmat(rocle, length(ale), 1);
        P1= P1 + eps*(P1==0);
        node= node./P1;
        rocle= rocle/sum(rocle);
        info= sum(-node.*LOG2F(eps+node));  %ÿ�������ֱ������Ϣ��,eps��Ϊ�˷�ֹ����Ϊ1 
        el(i) = (Inode-sum(rocle.*info))/(-sum(rocle.*LOG2F(eps+rocle))); %��Ϣ������  
    else
        %��������
        node= zeros(length(ale), 2);
        
        [sorted_data, indices] = sort(data);
        sorted_targets = train_targets(indices);
        
        %���������Ϣ����  
         I = zeros(1,nu);  
         spl= zeros(1, nu);  
         for j = 1:nu-1  %����i��Nbins������ֵ���趨Nbins-1�����ܵķָ�㣬��ÿ���ָ�������Ϣ������
             node(:, 1) = hist(sorted_targets(find(sorted_data <= pe(j))) , ale);  
             node(:, 2) = hist(sorted_targets(find(sorted_data > pe(j))) , ale);   
             Ps= sum(node)/L; 
             node= node/L; 
             rocle= sum(node);    
             P1= repmat(rocle, length(ale), 1); 
             P1= P1 + eps*(P1==0);    
             info= sum(-node./P1.*LOG2F(eps+node./P1)); %��Ϣ����
             I(j)= Inode - sum(info.*Ps);   
             spl(j) =I(j)/(-sum(Ps.*LOG2F(eps+Ps)));  %��j���ָ�����Ϣ������
         end  
  
       [~, s] = max(I);  %�����зָ��������Ϣ������
       [~,S]=max(spl);
       el(i)=spl(S);
       location(i) = pe(S);  %��Ӧ����i�Ļ���λ�þ�����ʹ��Ϣ�������Ļ���ֵ 
   end    
end    
        
%�ҵ���ǰҪ��Ϊ��������������  
[num, feature_tosplit]= max(el); 
dims= 1:fea;  %������Ŀ  
tree.feature_tosplit= feature_tosplit;  %��Ϊ���ķ�������  
        
value= unique(train_features(feature_tosplit,:)); 
nu= length(value);
tree.value = value;  %��Ϊ���ķ����������� ��ǰ�����������������������ֵ  
tree.location = location(feature_tosplit);  %���ķ���λ��
           
if (nu == 1)  %���ظ�������ֵ����Ŀ==1�����������ֻ����һ������ֵ���Ͳ��ܽ��з���  
    his= hist(train_targets, length(ale));
    [num, largest]= max(his); 
    tree.value= [];
    tree.location  = [];    
    tree.child= ale(largest); 
    return    
end    
        
if (discrete_dim(feature_tosplit))  %�����ǰѡ��������Ϊ���������������Ǹ���ɢ����   
    for i = 1:nu   %����������������ظ�������ֵ����Ŀ  
        indices= find(train_features(feature_tosplit, :) == value(i));
        tree.child(i)= newBuildTree(train_features(dims, indices), train_targets(indices), discrete_dim(dims), layer, pruning);%�ݹ�  
       
        %��ɢ�������ֲ��Nbins�����ֱ����ÿ������ֵ��������������ٷֲ�  
    end    
else
    
%�����ǰѡ��������Ϊ���������������Ǹ���������
indices1= find(train_features(feature_tosplit,:) <= location(feature_tosplit));  %�ҵ�����ֵ<=����ֵ��������������  
indices2= find(train_features(feature_tosplit,:) > location(feature_tosplit));
  if ~(isempty(indices1) || isempty(indices2))  %���<=����ֵ >����ֵ��������Ŀ��������0    
      tree.child(1)= newBuildTree(train_features(dims, indices1), train_targets(indices1), discrete_dim(dims),layer+1, pruning);
      tree.child(2)= newBuildTree(train_features(dims, indices2), train_targets(indices2), discrete_dim(dims),layer+1, pruning);   
  else    
      his= hist(train_targets, length(ale));  %ͳ�Ƶ�ǰ���������ı�ǩ���ֱ�����ÿ����ǩ����Ŀ 
      [num, largest]= max(his);
      tree.child= ale(largest);   
      tree.feature_tosplit= 0;  %���ķ���������Ϊ0  
  end    
end 

