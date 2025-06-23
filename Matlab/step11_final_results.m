% THIS IS DEFINITE EDITION OF step10 function

clear;clc;
close all

% purpose: filtered out noise data.

frq=zeros(25,1);
frq(1)=0.05;
for i=2:25
     frq(i)=frq(i-1)*1.0694;
end

alpha=importdata('output/alpha.mat');
out_ki=importdata('output/out_ki.mat');
disparity=importdata('output/disparity.mat');
out_ki_simple=importdata('output/out_ki_simple.mat');
dic=importdata('interpolated_variables/dictionary.txt');



HS=importdata('output/HS.mat'); HS=0.5*(HS(:,1)+HS(:,2));
high_HS=importdata('output/high_HS.mat');
h=importdata('output/ice_thickness.mat'); h=0.5*h(:,1)+0.5*h(:,2);
dx=importdata('output/dxdMIZ.mat'); dx=0.5*dx(:,1)+0.5*dx(:,2);
sic=importdata('output/buoysic.mat'); sic=0.5*(sic(:,1)+sic(:,2));
load('output/buoy1_allage.mat');
load('output/buoy2_allage.mat');
load('output/buoy1_age.mat');
load('output/buoy2_age.mat');

load('output/buoy1_WS.mat');
load('output/buoy2_WS.mat');
WS=0.5*(buoy1_WS+buoy2_WS);

load('output/buoy1_fpeak.mat');
load('output/buoy2_fpeak.mat');
buoy_fpeak=0.5*(buoy1_fpeak+buoy2_fpeak);

load('output/Tm01.mat');
Tm=0.5*(Tm01(:,1)+Tm01(:,2));

%% out_ki remove noise
noise=10^(-9.7824)*frq.^(-4.6327);
scalenum=5;
len=length(h);
index=ones(len,1); %combine all criteria to determine final index of selected data


for i=1:length(dx)
    obs_spec_1=ncread(['wvspnc/',num2str(dic(i)),'NO1.nc'],'efth');
    obs_spec_1=squeeze(obs_spec_1(:,:,end,end));
    obs_spec_1=sum(obs_spec_1);

    obs_spec_2=ncread(['wvspnc/',num2str(dic(i)),'NO2.nc'],'efth');
    obs_spec_2=squeeze(obs_spec_2(:,:,end,end));
    obs_spec_2=sum(obs_spec_2);


    for j=1:25
        if(obs_spec_1(j)>noise(j)*scalenum && obs_spec_2(j)>noise(j)*scalenum)
        else
            out_ki(j,i)=nan;
            out_ki_simple(j,i)=nan;
        end
    end
end


figure
loglog(frq,obs_spec_1);
hold on
loglog(frq,obs_spec_2);
loglog(frq,noise*scalenum)



alpha=alpha(:,find(index==1));
out_ki=out_ki(:,find(index==1));
out_ki_simple=out_ki_simple(:,find(index==1));

h=h(find(index==1));
dx=dx(find(index==1));
sic=sic(find(index==1));
HS=HS(find(index==1));
WS=WS(find(index==1));
buoy_fpeak=buoy_fpeak(find(index==1));

buoy1_allage=buoy1_allage(:,find(index==1));
buoy2_allage=buoy2_allage(:,find(index==1));
buoy_allage=0.5*(buoy1_allage+buoy2_allage);

buoy1_age=buoy1_age(find(index==1));
buoy2_age=buoy2_age(find(index==1));
buoy_age=0.5*(buoy1_age+buoy2_age);

Tm=Tm(find(index==1));
%% data save

save('filtered_data/alpha.mat','alpha');
save('filtered_data/buoy_age.mat','buoy_age');
save('filtered_data/buoy_allage.mat','buoy_allage');
save('filtered_data/buoy_fpeak.mat','buoy_fpeak');
save('filtered_data/dx.mat','dx');
save('filtered_data/h.mat','h');
save('filtered_data/HS.mat','HS');
save('filtered_data/out_ki.mat','out_ki');
save('filtered_data/out_ki_simple.mat','out_ki_simple');
save('filtered_data/sic.mat','sic');
save('filtered_data/WS.mat','WS');
save('filtered_data/Tm.mat','Tm');
