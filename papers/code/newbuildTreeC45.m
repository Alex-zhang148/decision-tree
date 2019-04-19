function tree = newbuildTreeC45(train_features,train_targets,layer,varargin)
    [feaNum,L]=size(train_features);    
    Label=unique(train_targets);
    tree.feature_tosplit=0;
    tree.location=inf;
    if isempty(train_features)
        return
    end

    for i=1:length(Label)
        PD(i)=length(find(train_targets==Label(i)))/L;
    end
    %���㵱ǰ�ڵ����Ϣ�� -��pi*log2(pi)
    Info_D=-sum(PD.*log2(PD));
    if ( (L==1)||(length(Label) <=1)||(layer==6))     
        his= hist(train_targets, length(Label));  %ͳ�������ı�ǩ���ֱ�����ÿ����ǩ����Ŀ  
        [num, largest]= max(his); 
        tree.value= [];    
        tree.location  = [];    
        tree.child= Label(largest);
        return    
    end    
    
    
    %��¼ÿ����������Ϣ������
    GainRatio=zeros(1,feaNum);
    location=ones(1,feaNum)*inf;
    i=1;
    WW=[];
    while i<=feaNum
        Di=train_features(i,:);
        Si=unique(Di);
        subNum=length(Si);
%             node=zeros(length(Label),2);
            %����
            [sorted_data,indx]=sort(Di);
            sorted_targets=train_targets(indx);
        
            GainA=zeros(1,feaNum);
            GainRatioA=zeros(1,feaNum);
            for j=1:subNum
                N(j)=length(sorted_targets(find(sorted_data==Si(j))));
            end
            Th=edge(Di,train_targets,7);
            SplitInfoA=-sum((N/L).*log2(N/L));
            InfoD=[];
            for j=1:feaNum
                node1= hist(sorted_targets(find(sorted_data <= Th(j))) , Label)';
                node2= hist(sorted_targets(find(sorted_data > Th(j))) , Label)';
                node=[node1,node2];
                Ps=sum(node)/L; %|Dv|/|D|
                Ln=sum(node);
                Ln=Ln+eps*(Ln==0);
                %EntD(+)
                node1(find(node1==0))=[];
                node2(find(node2==0))=[];
                InfoDj(1)=-sum(node1./Ln(1).*log2(node1/Ln(1)));
                %EntD(-)
                InfoDj(2)=-sum(node2./Ln(2).*log2(node2/Ln(2)));
                InfoD(j)=sum(InfoDj);
                
                GainA(j)=Info_D-sum(Ps.*InfoDj);
                GainRatioA(j)=GainA(j)/SplitInfoA;
            end
            InfoD=InfoD./sum(InfoD);
            W=(1-InfoD)./(2-sum(InfoD));
            GainRatioA=W.*GainRatioA;
        [~,s]=max(GainRatioA);
        GainRatio(i)=GainRatioA(s);
        location(i)=Th(s);
        i=i+1;
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
        tree.child(1)= newbuildTreeC45(train_features(dims, indx1), train_targets(indx1),layer+1);
        tree.child(2)= newbuildTreeC45(train_features(dims, indx2), train_targets(indx2),layer+1);   
    else    
        his= hist(train_targets, length(Label));  %ͳ�Ƶ�ǰ���������ı�ǩ���ֱ�����ÿ����ǩ����Ŀ 
        [num, largest]= max(his);
        tree.child= Label(largest);   
        tree.feature_tosplit= 0;  %���ķ���������Ϊ0  
    end 
end


function [out]=edge(di,targets,feaNum)
    out=[];
    for i=1:feaNum
        a=find(targets==i);
        MAX=max(di(a));
        if(isempty(MAX))
            out(i)=0;
        else
            out(i)=MAX;
        end
    end
end


