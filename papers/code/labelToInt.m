function [ res ] = labelToInt( label )
%LABELTOINT Summary of this function goes here
%   Detailed explanation goes here

    %��������������
%���أ����������� 
    n=size(label);
    res=zeros(n);
    for i=1:size(label)
        if strcmp(label(i), '��')
            res(i)=1;
        elseif strcmp(label(i), '��')
            res(i)=2;
        elseif strcmp(label(i), '��')
            res(i)=3;
        elseif strcmp(label(i), '�����Ⱦ')
            res(i)=4;
        elseif strcmp(label(i), '�ж���Ⱦ')
            res(i)=5;
        elseif strcmp(label(i), '�ض���Ⱦ')
            res(i)=6;
        elseif strcmp(label(i), '������Ⱦ')
            res(i)=7;
        end
    end
end

