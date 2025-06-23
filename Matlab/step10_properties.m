clear;clc;
close all

% frq=importdata('output/buoy_frq.mat');
% buoylist1=importdata('output/buoylist1.mat');
% buoylist2=importdata('output/buoylist2.mat');

frq=importdata('output/buoy_frq.mat');
buoylist1=importdata('output/buoylist1.mat');
buoylist2=importdata('output/buoylist2.mat');

list=importdata('output/list_rotated.mat');
dic=importdata("interpolated_variables/dictionary.txt");
len=length(dic);

HS=zeros(len,2);
peak_frequency_index=zeros(25,len);
buoysic=zeros(len,2);

Tm01=zeros(len,2);

for i=1:len
    ind=find(list(:,end)==dic(i));
    buoysic(i,1)=list(ind,8);
    buoysic(i,2)=list(ind,9);
    sp1=buoylist1(:,ind);
    sp2=buoylist2(:,ind);

    HS(i,1)=4*sqrt(trapz(frq,sp1));
    HS(i,2)=4*sqrt(trapz(frq,sp2));

    Tm01(i,1)=trapz(frq,sp1)/trapz(frq,frq.*sp1);
    Tm01(i,2)=trapz(frq,sp2)/trapz(frq,frq.*sp2);

    [maxval1, maxind1]=max(sp1);
    [maxval2, maxind2]=max(sp2);
    
    peakfind=[];
    for j=1:25
        if(sp1(j)>maxval1*0.001 && sp2(j)>maxval2*0.001)
            peakfind=[peakfind,j];
        end
    end
    peak_frequency_index(peakfind,i)=1;
end

figure
histogram(HS(:,1))
hold on
histogram(HS(:,2))
legend('A','B')

high_HS=zeros(len,1);
threshold=0.05;
for i=1:len
    if(HS(i,1)>threshold && HS(i,2)>threshold)
        high_HS(i)=1;
    end
end
sum(high_HS)

save('output/Tm01.mat',"Tm01");
save('output/HS.mat','HS');
save('output/buoysic.mat','buoysic');
save('output/high_HS.mat','high_HS');