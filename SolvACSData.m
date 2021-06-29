clc
clear all
close all
%% �������� ������ ������������
LoadDataset=load('D:\Users\Tuck\Documents\������\�����������\��������\Simulink\������\ASCtestDataNorm005_v2.mat');
Dataset=LoadDataset.data;
%% ������ ������ � ������� ��������
i=0;
j=0;
k=0;
while i<4
     i=i+1;
    SensorData{i}=Dataset{i}.Values.Data'; % �������� �������� �� ��������
    SensorTime{i}=Dataset{i}.Values.Time;
    SubstractData{i}=Dataset{i+4}.Values.Data'; % ���������� ����������� ��������
    ComparisionData{i}=Dataset{i+8}.Values.Data; % �������� ����������� �� ��
    ANDData{i}=Dataset{i+12}.Values.Data; % �������� ����������� �� �
    SelectorData{i}=Dataset{i+16}.Values.Data'; % �������� �������� ���������� �������� �� ������
    %%
    MaxSensorData{i}=max(SensorData{i});
    MinSensorData{i}=min(SensorData{i});
end
KoderData=Dataset{21}.Values.Data';
KoderTime=Dataset{21}.Values.Time';
NominalValue=Dataset{22}.Values.Data(1);
Tolerance=Dataset{23}.Values.Data(1);
TimeOfModeling=max(KoderTime);
%% ��� ������������ ������� �������
disp(['������������ �������� ������� ������: ',MaxSensorData(1:end)])
disp(['����������� �������� ������� ������: ',MinSensorData(1:end)])
%%
disp(['����������� ��������: ',num2str(NominalValue)])
disp(['���������� ����������: ', num2str(Tolerance)])
disp(['����� ������������, �: ', num2str(TimeOfModeling)])
%% ������ ������������ ������
while j<4
    j=j+1;
LenSData(j)=length(SensorData{j});
end
SumLenSData=sum(LenSData);
LenKData=length(find(KoderData));
KcompressionPoints=SumLenSData/LenKData;
disp(['����������� ������ �� ��������: ',num2str(KcompressionPoints)])
%% ��������������
Performance=TimeOfModeling/length(KoderData);
disp(['��������������: ',num2str(Performance)])
%% ����� �������������
figure('color','white')
set(0,'DefaultAxesFontSize',20,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',20,'DefaultTextFontName','Times New Roman');
while k<4
    k=k+1;
[f{k},x{k}]=ksdensity(SensorData{k});
subplot(2,2,k)
plot(x{k},f{k})
MeanSensorData(k)=mean(SensorData{k});
STDSensorData(k)=std(SensorData{k});
end
figure('color','white')
set(0,'DefaultAxesFontSize',20,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',20,'DefaultTextFontName','Times New Roman');
plot(x{1},f{1})
title('��������� ����������� �������� ������� ���')
ylabel('P(F_C)')
xlabel('F_C')
grid on
%
figure('color','white')
set(0,'DefaultAxesFontSize',20,'DefaultAxesFontName','Times New Roman');
set(0,'DefaultTextFontSize',20,'DefaultTextFontName','Times New Roman');
plot(SensorTime{1},SensorData{1})
ylabel('F_C(t)')
xlabel('t, c')
grid on
%
disp(['�������������� �������� ��. ����: ',num2str(MeanSensorData(1:end))])
disp(['��� ��. ����: ',num2str((STDSensorData(1:end)))])
%% ������ ������������� ��������
MatCompData=cell2mat(ComparisionData);
MatANDData=cell2mat(ANDData);
SumCompData=sum(MatCompData,2);
SumANDData=sum(MatANDData,2);
% ���������� ������������
Quantity0SCData=length(find(SumCompData==0));
Quantity1SCData=length(find(SumCompData==1));
Quantity2SCData=length(find(SumCompData==2));
Quantity3SCData=length(find(SumCompData==3));
Quantity4SCData=length(find(SumCompData==4));
Quantity0ANDData=length(find(SumANDData==0));
Quantity1ANDData=length(find(SumANDData==1));
Quantity2ANDData=length(find(SumANDData==2));
Quantity3ANDData=length(find(SumANDData==3));
Quantity4ANDData=length(find(SumANDData==4));
disp('���������� ������������ ��')
disp(['   0   ','   1   ','   2   ','   3   ','   4   '])
disp(['   ',num2str(Quantity0SCData),'   ','   ',num2str(Quantity1SCData),'   ','   ',num2str(Quantity2SCData),'   ',...
    '   ',num2str(Quantity3SCData),'   ','   ',num2str(Quantity4SCData),'   '])
disp('���������� ������������ �')
disp(['   0   ','   1   ','   2   ','   3   ','   4   '])
disp(['   ',num2str(Quantity0ANDData),'   ','   ',num2str(Quantity1ANDData),'   ','   ',num2str(Quantity2ANDData),'   ',...
    '   ',num2str(Quantity3ANDData),'   ','   ',num2str(Quantity4ANDData),'   '])
%
% for r=1:length(MatANDData)
%     NumQANDData(r)=find(MatANDData(r,:)==1);
% end
NumQANDData=find(MatANDData(1:length(MatANDData),:)==1);
GrupSumCompData=sum(SumCompData);
GrupSumANDData=sum(SumANDData);
Reliability=GrupSumANDData/GrupSumCompData;
disp(['������������� ��������: ',num2str(Reliability)])