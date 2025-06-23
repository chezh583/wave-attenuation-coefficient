clear;clc;
close all

%% read netcdf

fname='2020_07.nc';
ncdisp(fname)
frq=ncread(fname,'frequency');
info=ncread(fname,'message_kind'); % G for location, W for wave spectrum, N for none
time=ncread(fname,'time');
lon=ncread(fname,'lon');
lat=ncread(fname,'lat');
wvsp=ncread(fname,'wave_spectrum');
hs=ncread(fname,'hs');
tp=ncread(fname,'tp');


%% read model grids

Glon=importdata('grid/gridgen_out_2km/Barents202007.x_ascii.txt');
Glon=Glon/10000;
Glon=flipud(Glon);
Glat=importdata('grid/gridgen_out_2km/Barents202007.y_ascii.txt');
Glat=Glat/10000;
Glat=flipud(Glat);
[m,n]=size(Glon);
mask=importdata('grid/gridgen_out_2km/Barents202007.maskorig_ascii.txt');
mask=flipud(mask);

figure
h=pcolor(Glon,Glat,mask);
set(h,'EdgeColor','none')

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
    X(:,j)=3638000+2000*(j-1);
end

for i=1:m
    Y(i,:)=2538000+2000*(i-1);
end
Y=flipud(Y);



%% read info separately
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

% lon7=lon(find(info(:,7)=='G'),7);
% lat7=lat(find(info(:,7)=='G'),7);
% loc_time7=time(find(info(:,7)=='G'),7);
% wvsp7=wvsp(:,find(info(:,7)=='W'),7);
% wv_time7=time(find(info(:,7)=='W'),7);
% 
% lon8=lon(find(info(:,8)=='G'),8);
% lat8=lat(find(info(:,8)=='G'),8);
% loc_time8=time(find(info(:,8)=='G'),8);
% wvsp8=wvsp(:,find(info(:,8)=='W'),8);
% wv_time8=time(find(info(:,8)=='W'),8);
% 
% lon9=lon(find(info(:,9)=='G'),9);
% lat9=lat(find(info(:,9)=='G'),9);
% loc_time9=time(find(info(:,9)=='G'),9);
% wvsp9=wvsp(:,find(info(:,9)=='W'),9);
% wv_time9=time(find(info(:,9)=='W'),9);
% 
% lon10=lon(find(info(:,10)=='G'),10);
% lat10=lat(find(info(:,10)=='G'),10);
% loc_time10=time(find(info(:,10)=='G'),10);
% wvsp10=wvsp(:,find(info(:,10)=='W'),10);
% wv_time10=time(find(info(:,10)=='W'),10);
% 
% lon11=lon(find(info(:,11)=='G'),11);
% lat11=lat(find(info(:,11)=='G'),11);
% loc_time11=time(find(info(:,11)=='G'),11);
% wvsp11=wvsp(:,find(info(:,11)=='W'),11);
% wv_time11=time(find(info(:,11)=='W'),11);

%% plot trajectories
timestr1=datetime(2020,8,27,0,0,0);
% timestr2=datetime(2020,9,25,0,0,0);
timestr2=datetime(2020,9,22,12,0,0);
[timestart,timeend]=timeconverse2(timestr1,timestr2);



lon1=lon1(find(loc_time1>timestart & loc_time1<timeend)); lat1=lat1(find(loc_time1>timestart & loc_time1<timeend));
lon2=lon2(find(loc_time2>timestart & loc_time2<timeend)); lat2=lat2(find(loc_time2>timestart & loc_time2<timeend));
lon3=lon3(find(loc_time3>timestart & loc_time3<timeend)); lat3=lat3(find(loc_time3>timestart & loc_time3<timeend));
lon4=lon4(find(loc_time4>timestart & loc_time4<timeend)); lat4=lat4(find(loc_time4>timestart & loc_time4<timeend));
% lon5=lon5(find(loc_time5>timestart & loc_time5<timeend)); lat5=lat5(find(loc_time5>timestart & loc_time5<timeend));
% lon6=lon6(find(loc_time6>timestart & loc_time6<timeend)); lat6=lat6(find(loc_time6>timestart & loc_time6<timeend));

figure
m_proj('stereographic', 'lat',90,'long',0,'radius',20);
temp=ones(m,n);
temp(1:10,end-10:end)=0;
m_pcolor(Glon,Glat,temp);
hold on
 m_line(lon1,lat1,'linewi',1);
 m_line(lon2,lat2,'linewi',1);
 m_line(lon3,lat3,'linewi',1);
  m_line(lon4,lat4,'linewi',1);
 % m_line(lon5,lat5,'linewi',1);
 % m_line(lon6,lat6,'linewi',1);
shading flat
m_gshhs_i;
m_grid

figure
m_proj('lambert','lon',[-15 25],'lat',[76 84],'rectbox','on');
temp=zeros(m,n);
temp(1:3,:)=1;
temp(:,end-2:end)=1;
temp(end-2:end,:)=1;
temp(:,1:3)=1;
m_pcolor(Glon,Glat,temp);
hold on
 m_line(lon1,lat1,'linewi',1.5);
 m_line(lon2,lat2,'linewi',1.5);
 m_line(lon3,lat3,'linewi',1.5);
  m_line(lon4,lat4,'linewi',1.5);
 % m_line(lon5,lat5,'linewi',1);
 % m_line(lon6,lat6,'linewi',1);
shading flat
m_gshhs_i('color','k');
m_grid

%%
point1=getpoint(lon1,lat1,Glon,Glat,X,Y);
point2=getpoint(lon2,lat2,Glon,Glat,X,Y);
point3=getpoint(lon3,lat3,Glon,Glat,X,Y);
point4=getpoint(lon4,lat4,Glon,Glat,X,Y);
% point5=getpoint(lon5,lat5,Glon,Glat,X,Y);
% point6=getpoint(lon6,lat6,Glon,Glat,X,Y);


point=[point1;point2;point3;point4];
point_unique=unique(point, 'rows');



figure
m_proj('stereographic', 'lat',90,'long',0,'radius',20);
temp=ones(m,n);
temp(1:10,end-10:end)=0;
m_pcolor(Glon,Glat,temp);
m_line(point_unique(:,3),point_unique(:,4),'marker','o','linest','none');
shading flat
m_gshhs_i;

station=[point_unique(:,1),point_unique(:,2)];
save('output/station.mat','station')

% figure
% h=pcolor(X,Y,ice);
% set(h,'EdgeColor','none')
% hold on
% plot(point1(:,1),point1(:,2))
% plot(point2(:,1),point2(:,2))
% plot(point3(:,1),point3(:,2))
% plot(point4(:,1),point4(:,2))
% xlabel('X grid (m)')
% ylabel('Y grid (m)')
%%
[pointlen,pointwid]=size(point_unique);
txt=cell(pointlen,3);
for i=1:pointlen
    txt{i,1}=num2str(point_unique(i,1));
    txt{i,2}=num2str(point_unique(i,2));
    txt{i,3}=['NO',num2str(i)];
end
fname='point_0827_0925.txt';
% writecell(txt,fname,'Delimiter',' ');
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
