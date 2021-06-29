clc
clear all
close all

for s=1:6
%     s=s+1;
%% Загрузка данных эксперимента
LoadDataset=load('D:\Users\Tuck\Documents\Работа\Диссертация\Практика\Simulink\САКпар\Алг2\Par_teat_EXP_UK.mat');
Dataset=LoadDataset.data{s};
%% Запись данных в массивы массивов
i=0;
j=0;
k=0;
s=0;
r=0;
while i<4
     i=i+1;
    SensorData{i}=Dataset{i}.Values.Data'; % Значения амплитуд от датчиков
    SensorTime{i}=Dataset{i}.Values.Time;
    SubstractData{i}=Dataset{i+4}.Values.Data'; % Разностные амплитудные значения
    ComparisionData{i}=Dataset{i+8}.Values.Data;
    VMSData{i}=Dataset{i+18}.Values.Data; % Значения поступающие от ВМС
    ANDData{i}=Dataset{i+12}.Values.Data; % Значения поступающие от И
    %%
    MaxSensorData{i}=max(SensorData{i});
    MinSensorData{i}=min(SensorData{i});
end
KoderData=Dataset{23}.Values.Data';
KoderTime=Dataset{23}.Values.Time';
NominalValue=Dataset{17}.Values.Data(1);
Tolerance=Dataset{18}.Values.Data(1);
TimeOfModeling=max(KoderTime);
%% Для нормирования входных величин
disp(['Максимальное значение входных данных: ',MaxSensorData(1:end)])
disp(['Минимальное значение входных данных: ',MinSensorData(1:end)])
%%
disp(['Номинальное значение: ',num2str(NominalValue)])
disp(['Допустимое отклонение: ', num2str(Tolerance)])
%% Расчёт коэффициента сжатия
while j<4
    j=j+1;
LenSData(j)=length(SensorData{j});
end
SumLenSData=sum(LenSData);
LenKData=length(find(KoderData));
KcompressionPoints=SumLenSData/LenKData;
disp(['Коэффициент сжатия по отсчётам: ',num2str(KcompressionPoints)])
%% Закон распределения
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
title('Плотность вероятности входного сигнала САК')
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
disp(['Математическое ожидание вх. сигн: ',num2str(MeanSensorData(1:end))])
disp(['СКО вх. сигн: ',num2str((STDSensorData(1:end)))])
%% Расчёт достоверности контроля
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
disp(['Достоверность контроля по 1: ',num2str(Reliability1)])
disp('-------------------------------------------------')
disp(['Достоверность контроля по 2: ',num2str(Reliability2)])
disp('-------------------------------------------------')
clear all
end
close all