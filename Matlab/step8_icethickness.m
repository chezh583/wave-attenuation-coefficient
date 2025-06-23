clear;clc;
close all

dic=importdata("interpolated_variables/dictionary.txt");
list=importdata('output/list_rotated.mat');
load("output/point_unique.mat"); %dimension: x,y,lon,lat, created from step1

len=length(dic);
[lenall,temp]=size(point_unique);
[lenlist,temp]=size(list);

buoy1_lon=zeros(len,1);
buoy1_lat=zeros(len,1);
buoy2_lon=zeros(len,1);
buoy2_lat=zeros(len,1);
buoy1_time=zeros(len,1);
buoy2_time=zeros(len,1);
for i=1:len
    index=find(dic(i)==list(:,end));
    x1=list(index,2);
    y1=list(index,3);
    x2=list(index,5);
    y2=list(index,6);
    
    for j=1:lenall
        if(x1==point_unique(j,1) && y1==point_unique(j,2))
            ind1=j;
        end
        if(x2==point_unique(j,1) && y2==point_unique(j,2))
            ind2=j;
        end
    end

    for k=1:lenlist
        if(x1==list(k,2) && y1==list(k,3) && x2==list(k,5) && y2==list(k,6))
            indt=k;
        end
    end

    buoy1_lon(i)=point_unique(ind1,3);
    buoy1_lat(i)=point_unique(ind1,4);
    buoy2_lon(i)=point_unique(ind2,3);
    buoy2_lat(i)=point_unique(ind2,4);
    buoy1_time(i)=list(indt,4);
    buoy2_time(i)=list(indt,7);
end

buoy1_geo_info=[buoy1_lon, buoy1_lat, buoy1_time];
buoy2_geo_info=[buoy2_lon, buoy2_lat, buoy2_time];

dlmwrite('output/buoy1_geo_info.txt', buoy1_geo_info, '-append', 'delimiter', ' ','precision','%.2f');
dlmwrite('output/buoy2_geo_info.txt', buoy2_geo_info, '-append', 'delimiter', ' ','precision','%.2f');


figure
m_proj('stereographic', 'lat',90,'long',0,'radius',20);
m_line(buoy1_geo_info(:,1),buoy1_geo_info(:,2),'marker','o','linest','none');
hold on
m_line(buoy2_geo_info(:,1),buoy2_geo_info(:,2),'marker','o','linest','none');
shading flat
m_gshhs_i;
m_grid


% NOTE: need further calculation, which is performed in
% write_ice_thickness.m program in UNIX. 