function tree = buildC45(train_features,train_targets,layer,varargin)
    [feaNum,L]=size(train_features);
    Label=unique(train_targets);
    tree.feature_tosplit=0;
    tree.location=inf;
    if isempty(train_features)
        return
    end
    
    %����ֹͣ����
    if (  (L==1)||(length(Label) <=1)||(layer==6)) %���ʣ��ѵ������̫С(С��pruning)����ֻʣһ������ֻʣһ���ǩ���˳�    
        his= hist(train_targets, length(Label));  %ͳ�������ı�ǩ���ֱ�����ÿ����ǩ����Ŀ  
        [num, largest]= max(his); 
        tree.value= [];    
        tree.location  = [];    
        tree.child= Label(largest);
        return    
    end    
    
    %C4.5
    for i=1:length(Label)
        PD(i)=length(find(train_targets==Label(i)))/L;
    end
    %���㵱ǰ�ڵ����Ϣ�� -��pi*log2(pi)
    Info_D=-sum(PD.*log2(PD));
    %��¼ÿ����������Ϣ������
    GainRatio=zeros(1,feaNum);
    location=ones(1,feaNum)*inf;
    for i=1:feaNum
        Di=train_features(i,:);
        Si=unique(Di);
        subNum=length(Si);
        
            node=zeros(length(Label),2);
            %����
            [sorted_data,indx]=sort(Di);
            [sorted_data2,indx2]=sort(Si);
            sorted_targets=train_targets(indx);
        
            GainA=zeros(1,subNum);
            GainRatioA=zeros(1,subNum);

            for j=1:subNum
                N(j)=length(sorted_targets(find(sorted_data==Si(j))));
                if j~=subNum
                    Th(j)=(sorted_data2(j)+sorted_data2(j+1))/2;
                else 
                    Th(j)=sorted_data2(j);
                end
            end
            
            SplitInfoA=-sum((N/L).*log2(N/L));
            for j=1:subNum-1
                node(:, 1) = hist(sorted_targets(find(sorted_data <= Th(j))) , Label);
                node(:, 2) = hist(sorted_targets(find(sorted_data > Th(j))) , Label);
                Ps=sum(node)/L; %|Dv|/|D|
                Ln=sum(node);
                Ln=Ln+eps*(Ln==0);
                %EntD(+)
                InfoDj(1)=-sum(node(:,1)./Ln(1).*log2(eps+node(:,1)/Ln(1)));
                %EntD(-)
                InfoDj(2)=-sum(node(:,2)./Ln(1).*log2(eps+node(:,2)/Ln(2)));
                GainA(j)=Info_D-sum(Ps.*InfoDj);
                GainRatioA(j)=GainA(j)/SplitInfoA;
            end
        [~,s]=max(GainRatioA);
        GainRatio(i)=GainRatioA(s);
        location(i)=Th(s);
    end
    [val,feature_tosplit]=max(GainRatio);
    dims=1:feaNum;
    tree.feature_tosplit=feature_tosplit;
    value=unique(train_features(feature_tosplit,:));
    subNum=length(value);
    tree.value=value;
    tree.location=location(feature_tosplit);
    
    if (subNum == 1)  %���ظ�������ֵ����Ŀ==1�����������ֻ����һ������ֵ���Ͳ��ܽ��з���  
        his= hist(train_targets, length(Label));
        [num, largest]= max(his); 
        tree.value= [];
        tree.location  = [];    
        tree.child= Label(largest); 
        return    
    end    
        %�����ǰѡ��������Ϊ���������������Ǹ���������
        indx1= find(train_features(feature_tosplit,:) <= location(feature_tosplit));  %�ҵ�����ֵ<=����ֵ��������������  
        indx2= find(train_features(feature_tosplit,:) > location(feature_tosplit));
        if ~(isempty(indx1) || isempty(indx2))  %���<=����ֵ >����ֵ��������Ŀ��������0    
            tree.child(1)= buildC45(train_features(dims, indx1), train_targets(indx1),layer+1);
            tree.child(2)= buildC45(train_features(dims, indx2), train_targets(indx2),layer+1);   
        else    
            his= hist(train_targets, length(Label));  %ͳ�Ƶ�ǰ���������ı�ǩ���ֱ�����ÿ����ǩ����Ŀ 
            [num, largest]= max(his);
            tree.child= Label(largest);   
            tree.feature_tosplit= 0;  %���ķ���������Ϊ0  
        end 
%     end
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
