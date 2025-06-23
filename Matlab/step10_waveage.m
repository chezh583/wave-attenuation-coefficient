clear;clc;
close all

% purpose: calculate the spectral wave age for each attenuation profile.

list=importdata('output/list_rotated.mat');
dic=importdata("interpolated_variables/dictionary.txt");
len=length(dic);

frq=zeros(25,1);
frq(1)=0.05;
for i=2:25
     frq(i)=frq(i-1)*1.0694;
end
omega=2*pi*frq;
k=zeros(25,len);

g=9.815;
rho_ice=910;
rho_sea=1025;
h=importdata('output/ice_thickness.mat');
h=0.5*h(:,1)+0.5*h(:,2);

buoy1_WS=zeros(len,1);
buoy2_WS=zeros(len,1);

% find peak frequency
load('output/buoylist1.mat');
load('output/buoylist2.mat');
buoy1_fpind=zeros(len,1);
buoy2_fpind=zeros(len,1);


for i=1:len
    ind=find(list(:,end)==dic(i));
    c1=list(ind,8); c2=list(ind,9);
    c=0.5*(c1+c2);
    buoy1_u=list(ind,10); buoy1_v=list(ind,11);
    buoy2_u=list(ind,12); buoy2_v=list(ind,13);
    buoy1_WS(i)=sqrt(buoy1_u^2+buoy1_v^2);
    buoy2_WS(i)=sqrt(buoy2_u^2+buoy2_v^2);
    for j=1:25
        k(j,i)=omega(j)^2/(g-c*rho_ice*h(i).*omega(j)^2/rho_sea);
    end

    [maxval, findex]=max(buoylist1(:,ind));
    buoy1_fpind(i)=findex;
    [maxval, findex]=max(buoylist2(:,ind));
    buoy2_fpind(i)=findex;
end

figure
plot(frq,k)
title('dispersion relation')

figure
histogram(buoy1_WS,'Normalization','probability','BinWidth',1)
% hold on
% histogram(buoy2_WS)
title('wind speed distribution')
xlabel('Wind speed (m/s)')


cp=zeros(25,len);
for i=1:len
    for j=1:25
        cp(j,i)=omega(j)/k(j,i);
    end
end

buoy1_age=zeros(len,1);
buoy2_age=zeros(len,1);

for i=1:len
    buoy1_age(i)=cp(buoy1_fpind(i))/buoy1_WS(i);
    buoy2_age(i)=cp(buoy2_fpind(i))/buoy2_WS(i);
end

figure
histogram(buoy1_age)
hold on
histogram(buoy2_age)
title('wave age distribtion')


buoy1_allage=zeros(25,len);
buoy2_allage=zeros(25,len);

for i=1:len
    buoy1_allage(:,i)=cp(:,i)/buoy1_WS(i);
    buoy2_allage(:,i)=cp(:,i)/buoy2_WS(i);
end

save('output/buoy1_age.mat','buoy1_age');
save('output/buoy2_age.mat','buoy2_age');
save('output/buoy1_allage.mat','buoy1_allage');
save('output/buoy2_allage.mat','buoy2_allage');


buoy1_fpeak=frq(buoy1_fpind);
buoy2_fpeak=frq(buoy2_fpind);
save('output/buoy1_fpeak.mat',"buoy1_fpeak");
save('output/buoy2_fpeak.mat',"buoy2_fpeak");
save('output/buoy1_WS.mat',"buoy1_WS");
save('output/buoy2_WS.mat',"buoy2_WS");
