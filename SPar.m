clc
clear all
close all

for s=1:6
%     s=s+1;
%% �������� ������ ������������
LoadDataset=load('D:\Users\Tuck\Documents\������\�����������\��������\Simulink\������\���2\Par_teat_EXP_UK.mat');
Dataset=LoadDataset.data{s};
%% ������ ������ � ������� ��������
i=0;
j=0;
k=0;
s=0;
r=0;
while i<4
     i=i+1;
    SensorData{i}=Dataset{i}.Values.Data'; % �������� �������� �� ��������
    SensorTime{i}=Dataset{i}.Values.Time;
    SubstractData{i}=Dataset{i+4}.Values.Data'; % ���������� ����������� ��������
    ComparisionData{i}=Dataset{i+8}.Values.Data;
    VMSData{i}=Dataset{i+18}.Values.Data; % �������� ����������� �� ���
    ANDData{i}=Dataset{i+12}.Values.Data; % �������� ����������� �� �
    %%
    MaxSensorData{i}=max(SensorData{i});
    MinSensorData{i}=min(SensorData{i});
end
KoderData=Dataset{23}.Values.Data';
KoderTime=Dataset{23}.Values.Time';
NominalValue=Dataset{17}.Values.Data(1);
Tolerance=Dataset{18}.Values.Data(1);
TimeOfModeling=max(KoderTime);
%% ��� ������������ ������� �������
disp(['������������ �������� ������� ������: ',MaxSensorData(1:end)])
disp(['����������� �������� ������� ������: ',MinSensorData(1:end)])
%%
disp(['����������� ��������: ',num2str(NominalValue)])
disp(['���������� ����������: ', num2str(Tolerance)])
%% ������ ������������ ������
while j<4
    j=j+1;
LenSData(j)=length(SensorData{j});
end
SumLenSData=sum(LenSData);
LenKData=length(find(KoderData));
KcompressionPoints=SumLenSData/LenKData;
disp(['����������� ������ �� ��������: ',num2str(KcompressionPoints)])
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
MatVMSData=cell2mat(VMSData);
MatSolvVMSData=MatVMSData;
MatANDData=cell2mat(ANDData);
while r<4
    r=r+1;
MatSolData(:,r)=SubstractData{r}>=Tolerance;
end


MultVMSAND=MatVMSData.*MatANDData;
SlolMultVMSDATA=MatSolvVMSData.*MatSolData;
SumMultVMS=sum(sum(MultVMSAND,2));
SumSlolMultVMSDATA=sum(sum(SlolMultVMSDATA,2));


Reliability1=sum(sum(MatANDData,2))/sum(sum(MatSolData,2));
Reliability2=SumMultVMS/SumSlolMultVMSDATA;
disp(['������������� �������� �� 1: ',num2str(Reliability1)])
disp('-------------------------------------------------')
disp(['������������� �������� �� 2: ',num2str(Reliability2)])
disp('-------------------------------------------------')
clear all
end
close all