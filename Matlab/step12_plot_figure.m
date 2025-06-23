% THIS IS DEFINITE EDITION OF step10 function

clear;clc;
close all

% purpose: plot the final results, the attenuation profiels as a function of frequency and spectral wave age. 

frq=zeros(25,1);
frq(1)=0.05;
for i=2:25
     frq(i)=frq(i-1)*1.0694;
end

load('filtered_data/alpha.mat'); 
load('filtered_data/buoy_age.mat');
load('filtered_data/buoy_fpeak.mat');
load('filtered_data/dx.mat');
load('filtered_data/h.mat');
load('filtered_data/HS.mat');
load('filtered_data/out_ki_mod.mat');
load('filtered_data/out_ki_simple.mat');
load('filtered_data/sic.mat');
load('filtered_data/WS.mat');

%%
figure
subplot(131)
loglog(frq,alpha,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([1e-7 1e-3])
title('alpha')
subplot(132)
loglog(frq,out_ki_simple,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
ylim([1e-6 1e-2])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
subplot(133)
loglog(frq,out_ki,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
ylim([1e-6 1e-2])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')

%%
h1=find(h<1);
h2=find(h>1 & h<2);
h3=find(h>2 & h<3);


figure
subplot(221)
loglog(frq,alpha,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([1e-7 1e-3])
title('alpha')
subplot(222)
loglog(frq,out_ki(:,h1),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
ylim([1e-6 1e-2])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
title('h<1')
subplot(223)
loglog(frq,out_ki(:,h2),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
ylim([1e-6 1e-2])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
title('1<h<2')
subplot(224)
loglog(frq,out_ki(:,h3),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
ylim([1e-6 1e-2])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
title('2<h<3')

%%
mm=out_ki(1,:);
mm=mm';
hx=find(h<2.5 & mm<2e-3);
figure
subplot(131)
loglog(frq,alpha(:,hx),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([2e-7 2e-3])
title('alpha')
subplot(132)
loglog(frq,out_ki_simple(:,hx),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([2e-6 2e-2])
title('alpha')
subplot(133)
loglog(frq,out_ki(:,hx),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([2e-6 2e-2])
title('alpha')
%%




d1=find(dx<20000);
d2=find(dx>20000 & dx<40000);
d3=find(dx>40000 & dx<60000);


figure
subplot(221)
loglog(frq,alpha,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
ylim([1e-7 1e-3])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
title('alpha')

% subplot(222)
% loglog(frq,out_ki(:,d1),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('d<20')
% 
% subplot(223)
% loglog(frq,out_ki(:,d2),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('20<d<40')
% 
% subplot(224)
% loglog(frq,out_ki(:,d3),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('40<d<60')



d1data=out_ki(:,d1);
% d2data=out_ki(:,d2);
% d3data=out_ki(:,d3);

% save('FIGURE/d1data.mat','d1data');
% save('FIGURE/d2data.mat','d2data');
% save('FIGURE/d3data.mat','d3data');
%%
c1=find(sic<0.3);
c2=find(sic>0.3 & sic<0.6);
c3=find(sic>0.6 & sic<0.9);


% figure
% subplot(221)
% loglog(frq,alpha,'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Apparent attenuation rate (m^{-1})')
% title('alpha')
% ylim([1e-7 1e-3])
% subplot(222)
% loglog(frq,out_ki(:,c1),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('sic<0.3')
% 
% subplot(223)
% loglog(frq,out_ki(:,c2),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('0.3<sic<0.6')

subplot(224)
loglog(frq,out_ki(:,c3),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
ylim([1e-6 1e-2])
title('0.6<sic<0.9')

% c1data=out_ki(:,c1);
% c2data=out_ki(:,c2);
c3data=out_ki(:,c3);


%%
HS1=find(HS<0.15);
HS2=find(HS>0.15 & HS<0.3);
HS3=find(sic>0.3 & sic<0.45);


figure
subplot(221)
loglog(frq,alpha,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
title('alpha')
ylim([1e-7 1e-3])
subplot(222)
loglog(frq,out_ki(:,HS1),'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
ylim([1e-6 1e-2])
title('HS<0.15')

% subplot(223)
% loglog(frq,out_ki(:,HS2),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('0.15<HS<0.3')
% 
% subplot(224)
% loglog(frq,out_ki(:,HS3),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
% xlabel('Frequency (Hz)')
% ylabel('Amplitude attenuation rate (m^{-1})')
% ylim([1e-6 1e-2])
% title('0.3<HS<0.45')

HS1data=out_ki(:,HS1);
% HS2data=out_ki(:,HS2);
% HS3data=out_ki(:,HS3);




%%
figure
subplot(221)
loglog(buoy1_allage,alpha,'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
xlabel('wave age')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([1e-7 1e-3])
title('alpha')
subplot(222)
loglog(buoy1_allage(:,h1),out_ki(:,h1),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
xlabel('wave age')
ylabel('Amplitude attenuation rate (m^{-1})')
ylim([1e-6 1e-2])

subplot(223)
loglog(buoy1_allage(:,h2),out_ki(:,h2),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
xlabel('wave age')
ylabel('Amplitude attenuation rate (m^{-1})')
ylim([1e-6 1e-2])

subplot(224)
loglog(buoy1_allage(:,h3),out_ki(:,h3),'Color',[0.3 0.3 0.3])
% xlim([0.05 0.25])
xlabel('wave age')
ylabel('Amplitude attenuation rate (m^{-1})')
ylim([1e-6 1e-2])




