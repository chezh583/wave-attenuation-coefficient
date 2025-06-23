clear;clc;
close all

info1=importdata('buoy1_geo_info.txt');
info2=importdata('buoy2_geo_info.txt');
[len tmep]=size(info1);
% dime: lon, lat, time

lon1=info1(:,1); lat1=info1(:,2);
lon2=info2(:,1); lat2=info2(:,2);

ice_thickness=zeros(len,2);


for i=1:len
    i
    buoytime=num2str(floor(info1(i,3)/10000));
    ff=['../data_nest/Barents25/Barents-2.5km_ZDEPTHS_his.an.',buoytime(1:8),'00.nc'];
    ICE=ncread(ff,'ice_thickness'); % unit: meter
    time=ncread(ff,'time');
    time_str=datestr(datetime(1970,1,1)+seconds(time),'yyyymmddHH');
    longrid=ncread(ff,'lon');
    latgrid=ncread(ff,'lat');
    
    [lennc,temp]=size(time_str);
    index=0;
    for j=1:lennc
        if(strcmp(buoytime,time_str(j,:)))
            index=j;
        end
    end
    [ind1_i,ind1_j]=searchforloc(lat1(i),lon1(i),latgrid,longrid);
    [ind2_i,ind2_j]=searchforloc(lat2(i),lon2(i),latgrid,longrid);
    ice_thickness(i,1)=ICE(ind1_i,ind1_j,index);
    ice_thickness(i,2)=ICE(ind2_i,ind2_j,index);
end

save('ice_thickness.mat','ice_thickness')
