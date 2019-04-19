function targets = predict(tree,test_features, indices)       
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����C4.5�������㷨�Բ�����������Ԥ��
%tree��C4.5�㷨�������ľ����� 
%test_features���������������� 
%indices������ 
%discrete:����ά�ȵ������Ƿ�������ȡֵ��0ָ��������ȡֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% indices

targets = zeros(1, size(test_features,2)); 
if(isempty(indices))
    return;
end
if (tree.feature_tosplit == 0)  
    targets(indices) = tree.child;  %�õ�������Ӧ�ı�ǩ��tree.child  
    return    
end    
        
feature_tosplit = tree.feature_tosplit;  %�õ���������  
dims= 1:size(test_features,1);  %�õ���������  
        
% ���ݵõ��ľ������Բ����������з���  
in= indices(find(test_features(feature_tosplit, indices)<= tree.location));  
targets= targets + predict( tree.child(1),test_features(dims, :), in); 
in= indices(find(test_features(feature_tosplit, indices)>tree.location)); 
targets= targets + predict(tree.child(2),test_features(dims, :),in);      
end 

