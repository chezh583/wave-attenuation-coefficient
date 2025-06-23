clear;clc;
close all 

load('output/list.mat');


buoy_frq=importdata('output/buoy_frq.mat');
buoylist1=importdata('output/buoylist1.mat');
buoylist2=importdata('output/buoylist2.mat');


fname='nest_point.nc';
% ncdisp(fname)
nest_x=ncread(fname,'x');
nest_y=ncread(fname,'y');
nest_frq=ncread(fname,'frequency');
nest_frq1=ncread(fname,'frequency1');
nest_frq2=ncread(fname,'frequency2');
nest_dir=ncread(fname,'direction');

load('output/splist1.mat'); % dim: num, dir, frq
load('output/splist2.mat');

%% average buoylist in the frequency range same with model setting
% [m,n]=size(buoylist1);
% new_buoylist1=zeros(25,n);
% new_buoylist2=zeros(25,n);
% 
% for i=1:n
%     new_buoylist1(:,i)= interp1(buoy_frq, buoylist1(:,i), nest_frq, 'linear');
%     new_buoylist2(:,i)= interp1(buoy_frq, buoylist2(:,i), nest_frq, 'linear');
% end
% 
% 
% % test
% figure
% plot(buoy_frq,buoylist1(:,25))
% hold on
% plot(nest_frq,new_buoylist1(:,25))
% 
% buoylist1=new_buoylist1;
% buoylist2=new_buoylist2;
% buoy_frq=nest_frq;
% % 
% if(1)
%     save("output/buoylist1_interp.mat","buoylist1");
%     save("output/buoylist2_interp.mat","buoylist2");
%     save("output/buoy_frq_interp.mat","buoy_frq");
% end
%%
dth=15*pi/180;

[m,n]=size(list);

for i=1:m
    fname1=['wvspnc/',num2str(list(i,18)),'NO1.nc'];
    fname2=['wvspnc/',num2str(list(i,18)),'NO2.nc'];
    
    buoy1=buoylist1(:,i); buoy1=trapz(buoy_frq,buoy1);
    buoy2=buoylist2(:,i); buoy2=trapz(buoy_frq,buoy2);
    
    % Bug here because of buoylist with NaN values. But it has been
    % filtered when decinding position. 
    if(buoy1>buoy2)
        % rotate direction of wave spectrum to your newly defiend model grids.

        % first spectrum
        buoy=buoylist1(:,i);
        nest=squeeze(splist1(i,:,:)); %dim: dir,frq

        buoyspec2D=zeros(length(nest_dir),25); %only frequency<0.25Hz is used, because higher frequencies are not computed in ww3 model
        for j=1:length(nest_dir)
            for k=1:25
                [minval,ind]=min(abs(buoy_frq(k)-nest_frq));
                buoyspec2D(j,k)=(1/dth)*buoy(k)*(nest(j,ind))/sum(nest(:,ind));
            end
        end

        sumsp=zeros(length(nest_dir),1);
        for x=1:length(nest_dir)
            sumsp(x)=trapz(nest_frq,buoyspec2D(x,:));
        end
        [maxval,spind]=max(sumsp);
        list(i,1)=nest_dir(spind); % main direction

        dir=zeros(length(nest_dir),1);

        for j=1:length(nest_dir)
            dir(j)=nest_dir(j)-list(i,1);
            if(dir(j)>=360)
                dir(j)=dir(j)-360;
            end
            if(dir(j)<0)
                dir(j)=dir(j)+360;
            end
        end
        y=dth*sum(buoyspec2D);
        for inddir=1:25
            if(y(inddir)>1e-10)
            else
                buoyspec2D(:,inddir)=buoy(inddir)/(24*dth);
            end
        end

        createnc(fname1,buoy_frq,dir,buoyspec2D);

        % second spectrum
        buoy=buoylist2(:,i);
        nest=squeeze(splist2(i,:,:)); %dim: dir,frq

        buoyspec2D=zeros(length(nest_dir),length(buoy_frq));
        for j=1:length(nest_dir)
            for k=1:length(buoy_frq)
                [minval,ind]=min(abs(buoy_frq(k)-nest_frq));
                buoyspec2D(j,k)=(1/dth)*buoy(k)*(nest(j,ind))/sum(nest(:,ind));
            end
        end
        y=dth*sum(buoyspec2D);
        for inddir=1:25
            if(y(inddir)>1e-10)
            else
                buoyspec2D(:,inddir)=buoy(inddir)/(24*dth);
            end
        end

        createnc(fname2,buoy_frq,dir,buoyspec2D);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
    else
         % rotate direction of wave spectrum to your newly defiend model grids.

        % first spectrum
        buoy=buoylist2(:,i);
        nest=squeeze(splist1(i,:,:)); %dim: dir,frq

        buoyspec2D=zeros(length(nest_dir),length(buoy_frq));
        for j=1:length(nest_dir)
            for k=1:length(buoy_frq)
                [minval,ind]=min(abs(buoy_frq(k)-nest_frq));
                buoyspec2D(j,k)=(1/dth)*buoy(k)*(nest(j,ind))/sum(nest(:,ind));
            end
        end

        sumsp=zeros(length(nest_dir),1);
        for x=1:length(nest_dir)
            sumsp(x)=trapz(buoy_frq,buoyspec2D(x,:));
        end
        [maxval,spind]=max(sumsp);
        list(i,1)=nest_dir(spind); % main direction

        dir=zeros(length(nest_dir),1);

        for j=1:length(nest_dir)
            dir(j)=nest_dir(j)-list(i,1);
            if(dir(j)>=360)
                dir(j)=dir(j)-360;
            end
            if(dir(j)<0)
                dir(j)=dir(j)+360;
            end
        end
        y=dth*sum(buoyspec2D);
        for inddir=1:25
            if(y(inddir)>1e-10)
            else
                buoyspec2D(:,inddir)=buoy(inddir)/(24*dth);
            end
        end

        createnc(fname2,buoy_frq,dir,buoyspec2D);

        % second spectrum
        buoy=buoylist1(:,i);
        nest=squeeze(splist2(i,:,:)); %dim: dir,frq

        buoyspec2D=zeros(length(nest_dir),length(buoy_frq));
        for j=1:length(nest_dir)
            for k=1:length(buoy_frq)
                [minval,ind]=min(abs(buoy_frq(k)-nest_frq));
                buoyspec2D(j,k)=(1/dth)*buoy(k)*(nest(j,ind))/sum(nest(:,ind));
            end
        end
        y=dth*sum(buoyspec2D);
        for inddir=1:25
            if(y(inddir)>1e-10)
            else
                buoyspec2D(:,inddir)=buoy(inddir)/(24*dth);
            end
        end

        createnc(fname1,buoy_frq,dir,buoyspec2D);
    end
end



%% rotate coordinate
[m,n]=size(list);

temp=list;

for i=1:m
    theta=-list(i,1);
    uwnd1=list(i,10);
    vwnd1=list(i,11);
    uwnd2=list(i,12);
    vwnd2=list(i,13);
    ucur1=list(i,14);
    vcur1=list(i,15);
    ucur2=list(i,16);
    vcur2=list(i,17);

    [UWND1,VWND1]=rotatecoord(uwnd1,vwnd1,theta);
    [UWND2,VWND2]=rotatecoord(uwnd2,vwnd2,theta);
    [UCUR1,VCUR1]=rotatecoord(ucur1,vcur1,theta);
    [UCUR2,VCUR2]=rotatecoord(ucur2,vcur2,theta);

    list(i,10)=UWND1;
    list(i,11)=VWND1;
    list(i,12)=UWND2;
    list(i,13)=VWND2;
    list(i,14)=UCUR1;
    list(i,15)=VCUR1;
    list(i,16)=UCUR2;
    list(i,17)=VCUR2;
end

list_rotated=list;
% dlmwrite('output/list_rotated.txt', list_rotated, '-append', 'delimiter', ' ','precision','%.2f');
save("output/list_rotated.mat","list_rotated");
% list contains:
% #1 peak wave direction in model grid
% #2 X1 
% #3 Y1 
% #4 T1
% #5 X2 
% #6 Y2 (point 1 and point2 are either boundary point or model point, not determined)
% #7 T2
% #8 C1
% #9 C2
% #10 UWND1 (rotated to new coordinate)
% #11 VWND1 (rotated to new coordinate)
% #12 UWND2 (rotated to new coordinate)
% #13 VWND2 (rotated to new coordinate)
% #14 UCUR1 (rotated to new coordinate)
% #15 VCUR1 (rotated to new coordinate)
% #16 UCUR2 (rotated to new coordinate)
% #17 VCUR2 (rotated to new coordinate)
% #18 first two numbers mean pair index, last two numbers are used for count
% 
% splist1 is the 2d wave spectra from model outputs, the direction is
% determined by model setting and has not been rotated (will be done in step 4).
% splist2 is the same. 
% buoylist1 and buoylist2 are spectra collected by buoys

%% function appendix
function [outx,outy]=rotatecoord(inx,iny,theta)
    outx=inx*cosd(theta)+iny*sind(theta);
    outy=-inx*sind(theta)+iny*cosd(theta);
end

