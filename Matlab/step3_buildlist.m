clear;clc;
close all

%purpose: build a matrix that contains all wave properties, enviromental forcings, time, locations. 
%NOTICE: NEED CHANGE TIME_START IN APPENDIX SECTION

fname='nest_result.nc'; % come from modelv14/nest/ww3.202102.nc
% ncdisp(fname);
x=ncread(fname,'x');
y=ncread(fname,'y');
time=ncread(fname,'time');
time=str2num(datestr(datetime(1990,1,1)+days(time),'yyyymmddHHMMSS'));
ucur=ncread(fname,'ucur');
vcur=ncread(fname,'vcur');
uwnd=ncread(fname,'uwnd');
vwnd=ncread(fname,'vwnd');
ice=ncread(fname,'ice');

fname2='nest_point.nc';
% ncdisp(fname2);
efth=ncread(fname2,'efth'); %dimentsion: direction,frequency,station,time
load('output/station.mat'); % station is ouput points, created by create_point function

mat = dir('output/*.mat'); for q = 1:length(mat) load(['output/',mat(q).name]); end
%%
list=zeros(2,18);
% list = [angle, X1, Y1, T1, X2, Y2, T2, ICE1, ICE2, UWND1, VWND1, UWND2, VWND2,UCUR1, VCUR1, UCUR2,VCUR2,num] 
splist1=zeros(2,24,25); % dim: num, dir, frq
splist2=zeros(2,24,25);
% splist is the wave spectra produced by my model
buoylist1=zeros(25,2); % dim: frq, num
buoylist2=zeros(25,2);
% buoylist is the wave spectra produced by observation
flag=1;

[list,splist1,splist2,buoylist1,buoylist2,flag]=buildlist(list,splist1,splist2,buoylist1,buoylist2,flag,pair0102,X1,Y1,time1,wvsp1,X2,Y2,time2,wvsp2,station,x,y,ucur,vcur,uwnd,vwnd,ice,time,efth,90102000);
[list,splist1,splist2,buoylist1,buoylist2,flag]=buildlist(list,splist1,splist2,buoylist1,buoylist2,flag,pair0103,X1,Y1,time1,wvsp1,X3,Y3,time3,wvsp3,station,x,y,ucur,vcur,uwnd,vwnd,ice,time,efth,90103000);
[list,splist1,splist2,buoylist1,buoylist2,flag]=buildlist(list,splist1,splist2,buoylist1,buoylist2,flag,pair0104,X1,Y1,time1,wvsp1,X4,Y4,time4,wvsp4,station,x,y,ucur,vcur,uwnd,vwnd,ice,time,efth,90104000);
[list,splist1,splist2,buoylist1,buoylist2,flag]=buildlist(list,splist1,splist2,buoylist1,buoylist2,flag,pair0203,X2,Y2,time2,wvsp2,X3,Y3,time3,wvsp3,station,x,y,ucur,vcur,uwnd,vwnd,ice,time,efth,90203000);
[list,splist1,splist2,buoylist1,buoylist2,flag]=buildlist(list,splist1,splist2,buoylist1,buoylist2,flag,pair0204,X2,Y2,time2,wvsp2,X4,Y4,time4,wvsp4,station,x,y,ucur,vcur,uwnd,vwnd,ice,time,efth,90204000);
[list, splist1, splist2, buoylist1, buoylist2, flag] = buildlist(list, splist1, splist2, buoylist1, buoylist2, flag, pair0304, X3, Y3, time3, wvsp3, X4, Y4, time4, wvsp4, station, x, y, ucur, vcur, uwnd, vwnd, ice, time, efth, 90304000);


save("output/list.mat","list");
save("output/splist1.mat","splist1");
save("output/splist2.mat","splist2");
save("output/buoylist1.mat","buoylist1");
save("output/buoylist2.mat","buoylist2");





%% appendix function
% buoy traj #1 and #2
function [list,splist1,splist2,buoylist1,buoylist2,flag]=buildlist(list,splist1,splist2,buoylist1,buoylist2,flag,pair12,X1,Y1,time1,wvsp1,X2,Y2,time2,wvsp2,station,x,y,ucur,vcur,uwnd,vwnd,ice,time,efth,labelnum)
%==================Basic Processing==================================%
[len12,temp]=size(pair12);
[lenst,temp]=size(station);

%====================Main program==================================%
for i=1:len12
    % find index of buoy location in model grids
    %list(flag,1)=30; % angle of ice edge
    list(flag,2)=X1(pair12(i,1)); % X1
    list(flag,3)=Y1(pair12(i,1)); % Y1
    list(flag,4)=str2num(datestr(datetime(1970,1,1)+seconds(time1(pair12(i,1))),'yyyymmddHHMMSS')); % time1
    list(flag,5)=X2(pair12(i,2)); % X2
    list(flag,6)=Y2(pair12(i,2)); % Y2
    list(flag,7)=str2num(datestr(datetime(1970,1,1)+seconds(time2(pair12(i,2))),'yyyymmddHHMMSS')); % time2

    % get index in model grids
    indx1=find(list(flag,2)==x);
    indy1=find(list(flag,3)==y);
    indx2=find(list(flag,5)==x);
    indy2=find(list(flag,6)==y);
    [minval,indt]=min(abs(list(flag,4)-time));

    % if(indx1==1 || indx1==350 || indy1==1 || indy1==350 || minval>10000)
    %     printf('error!')
    % end

    list(flag,8)=ice(indx1,indy1,indt); % ice concentration 1
    list(flag,9)=ice(indx2,indy2,indt); % ice concentration 2
    list(flag,10)=uwnd(indx1,indy1,indt);
    list(flag,11)=vwnd(indx1,indy1,indt);
    list(flag,12)=uwnd(indx2,indy2,indt);
    list(flag,13)=vwnd(indx2,indy2,indt);
    list(flag,14)=ucur(indx1,indy1,indt);
    list(flag,15)=vcur(indx1,indy1,indt);
    list(flag,16)=ucur(indx2,indy2,indt);
    list(flag,17)=vcur(indx2,indy2,indt);
    list(flag,18)=labelnum+flag;
    
    for ID=1:lenst
        if(station(ID,1)==X1(pair12(i,1)) && station(ID,2)==Y1(pair12(i,1)))
            indsta1=ID;
        end
    end
    splist1(flag,:,:)=efth(:,:,indsta1,indt);
    
    for ID=1:lenst
        if(station(ID,1)==X2(pair12(i,2)) && station(ID,2)==Y2(pair12(i,2)))
            indsta2=ID;
        end
    end
    splist2(flag,:,:)=efth(:,:,indsta2,indt);
    
    buoylist1(:,flag)=wvsp1(:,pair12(i,1));
    buoylist2(:,flag)=wvsp2(:,pair12(i,2));

    flag=flag+1;
end
end




%%
% % buoy traj #1 and #4
% for i=1:len14
%     % find index of buoy location in model grids
%     %list(flag,1)=30; % angle of ice edge
%     list(flag,2)=X1(pair14(i,1)); % X1
%     list(flag,3)=Y1(pair14(i,1)); % Y1
%     list(flag,4)=str2num(datestr(datetime(1970,1,1)+seconds(time1(pair14(i,1))),'yyyymmddHHMMSS')); % time1
%     list(flag,5)=X4(pair14(i,2)); % X2
%     list(flag,6)=Y4(pair14(i,2)); % Y2
%     list(flag,7)=str2num(datestr(datetime(1970,1,1)+seconds(time4(pair14(i,2))),'yyyymmddHHMMSS')); % time2
% 
%     % get index in model grids
%     indx1=find(list(flag,2)==x);
%     indy1=find(list(flag,3)==y);
%     indx2=find(list(flag,5)==x);
%     indy2=find(list(flag,6)==y);
%     [minval,indt]=min(abs(list(flag,4)-time));
% 
%     if(indx1==1 || indx1==350 || indy1==1 || indy1==350 || minval>10000)
%         printf('error!')
%     end
% 
%     list(flag,8)=ice(indx1,indy1,indt); % ice concentration 1
%     list(flag,9)=ice(indx2,indy2,indt); % ice concentration 2
%     list(flag,10)=uwnd(indx1,indy1,indt);
%     list(flag,11)=vwnd(indx1,indy1,indt);
%     list(flag,12)=uwnd(indx2,indy2,indt);
%     list(flag,13)=vwnd(indx2,indy2,indt);
%     list(flag,14)=ucur(indx1,indy1,indt);
%     list(flag,15)=vcur(indx1,indy1,indt);
%     list(flag,16)=ucur(indx2,indy2,indt);
%     list(flag,17)=vcur(indx2,indy2,indt);
%     list(flag,18)=14000+flag;
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,2) && station(ID,2)==list(flag,3))
%             indsta=ID;
%         end
%     end
%     splist1(flag,:,:)=efth(:,:,indsta,indt);
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,5) && station(ID,2)==list(flag,6))
%             indsta=ID;
%         end
%     end
%     splist2(flag,:,:)=efth(:,:,indsta,indt);
% 
%     buoylist1(:,flag)=wvsp1(:,pair14(i,1));
%     buoylist2(:,flag)=wvsp4(:,pair14(i,2));
% 
%     flag=flag+1;
% end
% 
% % buoy traj #2 and #4
% for i=1:len24
%     % find index of buoy location in model grids
%     %list(flag,1)=30; % angle of ice edge
%     list(flag,2)=X2(pair24(i,1)); % X1
%     list(flag,3)=Y2(pair24(i,1)); % Y1
%     list(flag,4)=str2num(datestr(datetime(1970,1,1)+seconds(time2(pair24(i,1))),'yyyymmddHHMMSS')); % time1
%     list(flag,5)=X4(pair24(i,2)); % X2
%     list(flag,6)=Y4(pair24(i,2)); % Y2
%     list(flag,7)=str2num(datestr(datetime(1970,1,1)+seconds(time4(pair24(i,2))),'yyyymmddHHMMSS')); % time2
% 
%     % get index in model grids
%     indx1=find(list(flag,2)==x);
%     indy1=find(list(flag,3)==y);
%     indx2=find(list(flag,5)==x);
%     indy2=find(list(flag,6)==y);
%     [minval,indt]=min(abs(list(flag,4)-time));
% 
%     if(indx1==1 || indx1==350 || indy1==1 || indy1==350 || minval>10000)
%         printf('error!')
%     end
% 
%     list(flag,8)=ice(indx1,indy1,indt); % ice concentration 1
%     list(flag,9)=ice(indx2,indy2,indt); % ice concentration 2
%     list(flag,10)=uwnd(indx1,indy1,indt);
%     list(flag,11)=vwnd(indx1,indy1,indt);
%     list(flag,12)=uwnd(indx2,indy2,indt);
%     list(flag,13)=vwnd(indx2,indy2,indt);
%     list(flag,14)=ucur(indx1,indy1,indt);
%     list(flag,15)=vcur(indx1,indy1,indt);
%     list(flag,16)=ucur(indx2,indy2,indt);
%     list(flag,17)=vcur(indx2,indy2,indt);
%     list(flag,18)=24000+flag;
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,2) && station(ID,2)==list(flag,3))
%             indsta=ID;
%         end
%     end
%     splist1(flag,:,:)=efth(:,:,indsta,indt);
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,5) && station(ID,2)==list(flag,6))
%             indsta=ID;
%         end
%     end
%     splist2(flag,:,:)=efth(:,:,indsta,indt);
% 
%     buoylist1(:,flag)=wvsp2(:,pair24(i,1));
%     buoylist2(:,flag)=wvsp4(:,pair24(i,2));
% 
%     flag=flag+1;
% end
% 
% % buoy traj #3 and #5
% for i=1:len35
%     % find index of buoy location in model grids
%     %list(flag,1)=30; % angle of ice edge
%     list(flag,2)=X3(pair35(i,1)); % X1
%     list(flag,3)=Y3(pair35(i,1)); % Y1
%     list(flag,4)=str2num(datestr(datetime(1970,1,1)+seconds(time3(pair35(i,1))),'yyyymmddHHMMSS')); % time1
%     list(flag,5)=X5(pair35(i,2)); % X2
%     list(flag,6)=Y5(pair35(i,2)); % Y2
%     list(flag,7)=str2num(datestr(datetime(1970,1,1)+seconds(time5(pair35(i,2))),'yyyymmddHHMMSS')); % time2
% 
%     % get index in model grids
%     indx1=find(list(flag,2)==x);
%     indy1=find(list(flag,3)==y);
%     indx2=find(list(flag,5)==x);
%     indy2=find(list(flag,6)==y);
%     [minval,indt]=min(abs(list(flag,4)-time));
% 
%     if(indx1==1 || indx1==350 || indy1==1 || indy1==350 || minval>10000)
%         printf('error!')
%     end
% 
%     list(flag,8)=ice(indx1,indy1,indt); % ice concentration 1
%     list(flag,9)=ice(indx2,indy2,indt); % ice concentration 2
%     list(flag,10)=uwnd(indx1,indy1,indt);
%     list(flag,11)=vwnd(indx1,indy1,indt);
%     list(flag,12)=uwnd(indx2,indy2,indt);
%     list(flag,13)=vwnd(indx2,indy2,indt);
%     list(flag,14)=ucur(indx1,indy1,indt);
%     list(flag,15)=vcur(indx1,indy1,indt);
%     list(flag,16)=ucur(indx2,indy2,indt);
%     list(flag,17)=vcur(indx2,indy2,indt);
%     list(flag,18)=35000+flag;
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,2) && station(ID,2)==list(flag,3))
%             indsta=ID;
%         end
%     end
%     splist1(flag,:,:)=efth(:,:,indsta,indt);
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,5) && station(ID,2)==list(flag,6))
%             indsta=ID;
%         end
%     end
%     splist2(flag,:,:)=efth(:,:,indsta,indt);
% 
%     buoylist1(:,flag)=wvsp3(:,pair35(i,1));
%     buoylist2(:,flag)=wvsp5(:,pair35(i,2));
% 
%     % sp=squeeze(splist1(flag,:,:)); % dim: dir, frq
%     % sumsp=sum(sp,2);
%     % [maxval,spind]=max(sumsp);
%     % spangle=nest_dir(spind); % main direction
%     % if spangle<=180
%     %     list(flag,1)=180-spangle;
%     % else
%     %     list(flag,1)=540-spangle;
%     % end
% 
%     flag=flag+1;
% end
% 
% 
% % buoy traj #3 and #6
% for i=1:len36
%     % find index of buoy location in model grids
%     %list(flag,1)=30; % angle of ice edge
%     list(flag,2)=X3(pair36(i,1)); % X1
%     list(flag,3)=Y3(pair36(i,1)); % Y1
%     list(flag,4)=str2num(datestr(datetime(1970,1,1)+seconds(time3(pair36(i,1))),'yyyymmddHHMMSS')); % time1
%     list(flag,5)=X6(pair36(i,2)); % X2
%     list(flag,6)=Y6(pair36(i,2)); % Y2
%     list(flag,7)=str2num(datestr(datetime(1970,1,1)+seconds(time6(pair36(i,2))),'yyyymmddHHMMSS')); % time2
% 
%     % get index in model grids
%     indx1=find(list(flag,2)==x);
%     indy1=find(list(flag,3)==y);
%     indx2=find(list(flag,5)==x);
%     indy2=find(list(flag,6)==y);
%     [minval,indt]=min(abs(list(flag,4)-time));
% 
%     if(indx1==1 || indx1==350 || indy1==1 || indy1==350 || minval>10000)
%         printf('error!')
%     end
% 
%     list(flag,8)=ice(indx1,indy1,indt); % ice concentration 1
%     list(flag,9)=ice(indx2,indy2,indt); % ice concentration 2
%     list(flag,10)=uwnd(indx1,indy1,indt);
%     list(flag,11)=vwnd(indx1,indy1,indt);
%     list(flag,12)=uwnd(indx2,indy2,indt);
%     list(flag,13)=vwnd(indx2,indy2,indt);
%     list(flag,14)=ucur(indx1,indy1,indt);
%     list(flag,15)=vcur(indx1,indy1,indt);
%     list(flag,16)=ucur(indx2,indy2,indt);
%     list(flag,17)=vcur(indx2,indy2,indt);
%     list(flag,18)=36000+flag;
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,2) && station(ID,2)==list(flag,3))
%             indsta=ID;
%         end
%     end
%     splist1(flag,:,:)=efth(:,:,indsta,indt);
% 
%     for ID=1:714
%         if(station(ID,1)==list(flag,5) && station(ID,2)==list(flag,6))
%             indsta=ID;
%         end
%     end
%     splist2(flag,:,:)=efth(:,:,indsta,indt);
% 
%     buoylist1(:,flag)=wvsp3(:,pair36(i,1));
%     buoylist2(:,flag)=wvsp6(:,pair36(i,2));
% 
%     % sp=squeeze(splist1(flag,:,:)); % dim: dir, frq
%     % sumsp=sum(sp,2);
%     % [maxval,spind]=max(sumsp);
%     % spangle=nest_dir(spind); % main direction
%     % if spangle<=180
%     %     list(flag,1)=180-spangle;
%     % else
%     %     list(flag,1)=540-spangle;
%     % end
% 
% 
%     flag=flag+1;
% end
% 
% 
% % buoy traj #5 and #6
% for i=1:len56
%     % find index of buoy location in model grids
%     %list(flag,1)=30; % angle of ice edge
%     list(flag,2)=X5(pair56(i,1)); % X1
%     list(flag,3)=Y5(pair56(i,1)); % Y1
%     list(flag,4)=str2num(datestr(datetime(1970,1,1)+seconds(time5(pair56(i,1))),'yyyymmddHHMMSS')); % time1
%     list(flag,5)=X6(pair56(i,2)); % X2
%     list(flag,6)=Y6(pair56(i,2)); % Y2
%     list(flag,7)=str2num(datestr(datetime(1970,1,1)+seconds(time6(pair56(i,2))),'yyyymmddHHMMSS')); % time2
% 
%     % get index in model grids
%     indx1=find(list(flag,2)==x);
%     indy1=find(list(flag,3)==y);
%     indx2=find(list(flag,5)==x);
%     indy2=find(list(flag,6)==y);
%     [minval,indt]=min(abs(list(flag,4)-time));
% 
%     if(indx1==1 || indx1==350 || indy1==1 || indy1==350 || minval>10000)
%         printf('error!')
%     end
% 
%     list(flag,8)=ice(indx1,indy1,indt); % ice concentration 1
%     list(flag,9)=ice(indx2,indy2,indt); % ice concentration 2
%     list(flag,10)=uwnd(indx1,indy1,indt);
%     list(flag,11)=vwnd(indx1,indy1,indt);
%     list(flag,12)=uwnd(indx2,indy2,indt);
%     list(flag,13)=vwnd(indx2,indy2,indt);
%     list(flag,14)=ucur(indx1,indy1,indt);
%     list(flag,15)=vcur(indx1,indy1,indt);
%     list(flag,16)=ucur(indx2,indy2,indt);
%     list(flag,17)=vcur(indx2,indy2,indt);
%     list(flag,18)=56000+flag;
% 
%     for ID=1:113
%         if(station(ID,1)==list(flag,2) && station(ID,2)==list(flag,3))
%             indsta=ID;
%         end
%     end
%     splist1(flag,:,:)=efth(:,:,indsta,indt);
% 
%     for ID=1:113
%         if(station(ID,1)==list(flag,5) && station(ID,2)==list(flag,6))
%             indsta=ID;
%         end
%     end
%     splist2(flag,:,:)=efth(:,:,indsta,indt);
% 
%     buoylist1(:,flag)=wvsp5(:,pair56(i,1));
%     buoylist2(:,flag)=wvsp6(:,pair56(i,2));
% 
%     % sp=squeeze(splist1(flag,:,:)); % dim: dir, frq
%     % sumsp=sum(sp,2);
%     % [maxval,spind]=max(sumsp);
%     % spangle=nest_dir(spind); % main direction
%     % if spangle<=180
%     %     list(flag,1)=180-spangle;
%     % else
%     %     list(flag,1)=540-spangle;
%     % end
% 
%     flag=flag+1;
% end
% 
% 
% 
% 
% 
% 
% 
