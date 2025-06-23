clear;clc;
close all

% expected results: get X,Y, time, wvsp

%% read from model
Glon=importdata('grid/gridgen_out_2km/Barents202007.x_ascii.txt');
Glon=Glon/10000;
Glon=flipud(Glon);
Glat=importdata('grid/gridgen_out_2km/Barents202007.y_ascii.txt');
Glat=Glat/10000;
Glat=flipud(Glat);
[m,n]=size(Glon);
mask=importdata('grid/gridgen_out_2km/Barents202007.maskorig_ascii.txt');
mask=flipud(mask);

for i=1:m
    for j=1:n
        if(Glon(i,j)>180)
            Glon(i,j)=Glon(i,j)-360;
        end
    end
end

X=zeros(m,n);
Y=zeros(m,n);

for j=1:n
    X(:,j)=3638000+2000*(j-1);  % check this values, it should be from ww3_grid
end

for i=1:m
    Y(i,:)=2538000+2000*(i-1);  % check this values, it should be from ww3_grid
end
Y=flipud(Y);


%%
fname='2020_07.nc';
info=ncread(fname,'message_kind');
frq=ncread(fname,'frequency');
buoy_frq=frq;
time=ncread(fname,'time');
lon=ncread(fname,'lon');
lat=ncread(fname,'lat');
wvsp=ncread(fname,'wave_spectrum');
hs=ncread(fname,'hs');
tp=ncread(fname,'tp');
swh=ncread(fname,'swh');

lon1=lon(find(info(:,1)=='G'),1);
lat1=lat(find(info(:,1)=='G'),1);
loc_time1=time(find(info(:,1)=='G'),1);
wvsp1=wvsp(:,find(info(:,1)=='W'),1);
wv_time1=time(find(info(:,1)=='W'),1);

lon2=lon(find(info(:,2)=='G'),2);
lat2=lat(find(info(:,2)=='G'),2);
loc_time2=time(find(info(:,2)=='G'),2);
wvsp2=wvsp(:,find(info(:,2)=='W'),2);
wv_time2=time(find(info(:,2)=='W'),2);

lon3=lon(find(info(:,3)=='G'),3);
lat3=lat(find(info(:,3)=='G'),3);
loc_time3=time(find(info(:,3)=='G'),3);
wvsp3=wvsp(:,find(info(:,3)=='W'),3);
wv_time3=time(find(info(:,3)=='W'),3);

lon4=lon(find(info(:,4)=='G'),4);
lat4=lat(find(info(:,4)=='G'),4);
loc_time4=time(find(info(:,4)=='G'),4);
wvsp4=wvsp(:,find(info(:,4)=='W'),4);
wv_time4=time(find(info(:,4)=='W'),4);

% lon5=lon(find(info(:,5)=='G'),5);
% lat5=lat(find(info(:,5)=='G'),5);
% loc_time5=time(find(info(:,5)=='G'),5);
% wvsp5=wvsp(:,find(info(:,5)=='W'),5);
% wv_time5=time(find(info(:,5)=='W'),5);
% 
% lon6=lon(find(info(:,6)=='G'),6);
% lat6=lat(find(info(:,6)=='G'),6);
% loc_time6=time(find(info(:,6)=='G'),6);
% wvsp6=wvsp(:,find(info(:,6)=='W'),6);
% wv_time6=time(find(info(:,6)=='W'),6);

% figure
% m_proj('lambert','lon',[-10 30],'lat',[75 85])
% m_line(lon1,lat1);
% hold on
% m_line(lon2,lat2);
% m_line(lon3,lat3);
% m_line(lon4,lat4);
% % m_line(lon5,lat5);
% % m_line(lon6,lat6);
% shading flat
% m_gshhs_i;
% m_grid


t1=datetime(1970,1,1) + seconds(wv_time1);
t2=datetime(1970,1,1) + seconds(wv_time2);
t3=datetime(1970,1,1) + seconds(wv_time3);
t4=datetime(1970,1,1) + seconds(wv_time4);
% t5=datetime(1970,1,1) + seconds(wv_time5);
% t6=datetime(1970,1,1) + seconds(wv_time6);
%% select records from observations
% deterimine time range to compute index
timestr1=datetime(2020,8,27,0,0,0);
timestr2=datetime(2020,9,22,12,0,0);
[timestart,timeend]=timeconverse2(timestr1,timestr2);


ind1=find(wv_time1>timestart & wv_time1<timeend);
ind2=find(wv_time2>timestart & wv_time2<timeend);
ind3=find(wv_time3>timestart & wv_time3<timeend);
ind4=find(wv_time4>timestart & wv_time4<timeend);
% ind5=find(wv_time5>timestart & wv_time5<timeend);
% ind6=find(wv_time6>timestart & wv_time6<timeend);

IND1=find(loc_time1>timestart & loc_time1<timeend);
IND2=find(loc_time2>timestart & loc_time2<timeend);
IND3=find(loc_time3>timestart & loc_time3<timeend);
IND4=find(loc_time4>timestart & loc_time4<timeend);
% IND5=find(loc_time5>timestart & loc_time5<timeend);
% IND6=find(loc_time6>timestart & loc_time6<timeend);



% in this period, trj#1,#2,#3,#4, #5, #6 have records and thus are used. 
lon1=lon1(IND1);lat1=lat1(IND1);loc_time1=loc_time1(IND1);wv_time1=wv_time1(ind1);wvsp1=wvsp1(:,ind1);
lon2=lon2(IND2);lat2=lat2(IND2);loc_time2=loc_time2(IND2);wv_time2=wv_time2(ind2);wvsp2=wvsp2(:,ind2);
lon3=lon3(IND3);lat3=lat3(IND3);loc_time3=loc_time3(IND3);wv_time3=wv_time3(ind3);wvsp3=wvsp3(:,ind3);
lon4=lon4(IND4);lat4=lat4(IND4);loc_time4=loc_time4(IND4);wv_time4=wv_time4(ind4);wvsp4=wvsp4(:,ind4);
% lon5=lon5(IND5);lat5=lat5(IND5);loc_time5=loc_time5(IND5);wv_time5=wv_time5(ind5);wvsp5=wvsp5(:,ind5);
% lon6=lon6(IND6);lat6=lat6(IND6);loc_time6=loc_time6(IND6);wv_time6=wv_time6(ind6);wvsp6=wvsp6(:,ind6);


% estimate lon,lat at the time when wave spectrum is collected
[lon1,lat1,wvsp1,time1]=matchtime(lon1,lat1,loc_time1,wvsp1,wv_time1);
[lon2,lat2,wvsp2,time2]=matchtime(lon2,lat2,loc_time2,wvsp2,wv_time2);
[lon3,lat3,wvsp3,time3]=matchtime(lon3,lat3,loc_time3,wvsp3,wv_time3);
[lon4,lat4,wvsp4,time4]=matchtime(lon4,lat4,loc_time4,wvsp4,wv_time4);
% [lon5,lat5,wvsp5,time5]=matchtime(lon5,lat5,loc_time5,wvsp5,wv_time5);
% [lon6,lat6,wvsp6,time6]=matchtime(lon6,lat6,loc_time6,wvsp6,wv_time6);

% get X,Y value in cartesian coordinate of our model
point1=getpoint(lon1,lat1,Glon,Glat,X,Y);
point2=getpoint(lon2,lat2,Glon,Glat,X,Y);
point3=getpoint(lon3,lat3,Glon,Glat,X,Y);
point4=getpoint(lon4,lat4,Glon,Glat,X,Y);
% point5=getpoint(lon5,lat5,Glon,Glat,X,Y);
% point6=getpoint(lon6,lat6,Glon,Glat,X,Y);

X1=point1(:,1);Y1=point1(:,2);
X2=point2(:,1);Y2=point2(:,2);
X3=point3(:,1);Y3=point3(:,2);
X4=point4(:,1);Y4=point4(:,2);
% X5=point5(:,1);Y5=point5(:,2);
% X6=point6(:,1);Y6=point6(:,2);

figure
m_proj('lambert','lon',[-10 30],'lat',[75 85])
m_line(lon1,lat1);
hold on
m_line(lon2,lat2);
m_line(lon3,lat3);
m_line(lon4,lat4);
% m_line(lon5,lat5);
% m_line(lon6,lat6);
shading flat
m_gshhs_i;
m_grid


% test results
figure
plot(lon4,'*');
hold on
plot(point4(:,3),'o');

point=[point1;point2;point3;point4];
point_unique=unique(point, 'rows');
[tx,ty]=size(point_unique);
temp_point=zeros(2,4);
flag=1;
for i=1:tx
    if(~isnan(point_unique(i,1)))
        temp_point(flag,:)=point_unique(i,:);
        flag=flag+1;
    end
end
point_unique=temp_point;
save("output/point_unique.mat","point_unique");

save("output/X1.mat","X1");
save("output/X2.mat","X2");
save("output/X3.mat","X3");
save("output/X4.mat","X4");

save("output/Y1.mat","Y1");
save("output/Y2.mat","Y2");
save("output/Y3.mat","Y3");
save("output/Y4.mat","Y4");

save("output/lon1.mat","lon1");
save("output/lon2.mat","lon2");
save("output/lon3.mat","lon3");
save("output/lon4.mat","lon4");

save("output/lat1.mat","lat1");
save("output/lat2.mat","lat2");
save("output/lat3.mat","lat3");
save("output/lat4.mat","lat4");

save("output/time1.mat","time1");
save("output/time2.mat","time2");
save("output/time3.mat","time3");
save("output/time4.mat","time4");

save("output/wvsp1.mat","wvsp1");
save("output/wvsp2.mat","wvsp2");
save("output/wvsp3.mat","wvsp3");
save("output/wvsp4.mat","wvsp4");

save("output/buoy_frq.mat","buoy_frq");
%% appendix: functions
function [timestr]=timeconverse(timenum)
    timestr=datetime(1970,1,1) + seconds(timenum);
end

function [timestart,timeend]=timeconverse2(timestr1,timestr2)
    timestart=seconds(timestr1-datetime(1970,1,1));
    timeend=seconds(timestr2-datetime(1970,1,1));
end

function [point1]=getpoint(lon1,lat1,Glon,Glat,X,Y)
point1=zeros(length(lon1),4);
for i=1:length(lon1)
    [ind_i,ind_j]=searchforloc(lat1(i),lon1(i),Glat,Glon);
    x1=X(ind_i,ind_j);
    y1=Y(ind_i,ind_j);
    long1=Glon(ind_i,ind_j);
    lati1=Glat(ind_i,ind_j);
    point1(i,:)=[x1,y1,long1,lati1];
end
end

function [outlon,outlat,outwvsp,outtime]=matchtime(lon,lat,loc_time,wvsp,wv_time)
    flag=1;
    [m,n]=size(wvsp);
    outlon=zeros(2,1);outlat=zeros(2,1);outtime=zeros(2,1);outwvsp=zeros(m,2);

    for i=1:n
        [M,I]=min(abs(wv_time(i)-loc_time));
        if M<2*3600 % set max time range, here is 3 hours
            outlon(flag)=lon(I);
            outlat(flag)=lat(I);
            outtime(flag)=wv_time(i);
            outwvsp(:,flag)=wvsp(:,i);
            flag=flag+1;
        end
    end
end
