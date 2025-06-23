%% load data
clear;clc;
close all

%%
load('output/X1.mat');
load('output/X2.mat');
load('output/X3.mat');
load('output/X4.mat');



load('output/Y1.mat');
load('output/Y2.mat');
load('output/Y3.mat');
load('output/Y4.mat');



load('output/time1.mat');
load('output/time2.mat');
load('output/time3.mat');
load('output/time4.mat');


%% paring trajs
pair0102=pairtraj(time1,time2,X1,Y1,X2,Y2);
pair0103=pairtraj(time1,time3,X1,Y1,X3,Y3);
pair0104=pairtraj(time1,time4,X1,Y1,X4,Y4);


pair0203=pairtraj(time2,time3,X2,Y2,X3,Y3);
pair0204=pairtraj(time2,time4,X2,Y2,X4,Y4);

pair0304=pairtraj(time3,time4,X3,Y3,X4,Y4);



%test
figure
plot(X1(pair0102(:,1))-X2(pair0102(:,2)))
figure
plot(Y1(pair0102(:,1))-Y2(pair0102(:,2)))
figure
plot((time1(pair0102(:,1))-time2(pair0102(:,2)))/3600)

%% save to /ouput directories

vars = who('pair*');

% Loop through each variable and save it to a separate .mat file
for i = 1:length(vars)
    varName = vars{i};                 % Get the variable name
    data = eval(varName);              % Get the variable data

    [m,n]=size(data);
    if(m>3)
        fileName = sprintf('%s.mat', varName);  % Create a unique file name
        save(['output/',fileName], varName);           % Save the variable to a .mat file
    end
end



%% Function
% criterion: Dx<30km, Dy<30km, Dt<2h. here Dx and Dy are not in wave dirc
% axis. 
function [pair12]=pairtraj(time1,time2,X1,Y1,X2,Y2)
flag=1;
pair12=zeros(2,2);
len1=length(X1);
for i=1:len1
    [M, I]=min(abs(time1(i)-time2));
    Dx=X1(i)-X2(I);
    Dy=Y1(i)-Y2(I);
    D=sqrt(Dx^2+Dy^2);
    if (M<2*3600 && sqrt(Dx^2+Dy^2)<40000 && D>0)
        pair12(flag,1)=i;
        pair12(flag,2)=I;
        flag=flag+1;
    end
end
end