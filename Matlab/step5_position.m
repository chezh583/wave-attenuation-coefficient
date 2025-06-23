clear;clc;
close all

%purpose: get a position matrix that describe which is upstream or downstream in a buoy pair. 

l=importdata('output/list_rotated.mat');
[m,n]=size(l);

flag=zeros(m,1);
dx=zeros(m,1);
dy=zeros(m,1);

load('output/buoy_frq.mat');
load('output/buoylist1.mat'); %dim: buoy_frq,num
load('output/buoylist2.mat');

for i=1:m
    theta=-l(i,1);
    x1=l(i,2);
    y1=l(i,3);
    x2=l(i,5);
    y2=l(i,6);

    % % line function: tand(theta)*x-y=0.
    % % distance of points to the line
    % 
    % lineD1=abs(tand(theta)*x1-y1);
    % lineD2=abs(tand(theta)*x2-y2);


    buoy1=buoylist1(:,i); buoy1=trapz(buoy_frq,buoy1);
    buoy2=buoylist2(:,i); buoy2=trapz(buoy_frq,buoy2);

    if(buoy1>buoy2) % point 1 is close to open ocean, and thus used as boundary condition
        flag(i)=1;
        [new_x1,new_y1]=rotatecoord(x1,y1,theta);
        [new_x2,new_y2]=rotatecoord(x2,y2,theta);
        dx(i)=abs(new_x2-new_x1);
        dy(i)=abs(new_y2-new_y1);
    end
    if(buoy2>=buoy1) % point 2 is close to open ocean, and thus used as boundary condition
        flag(i)=2;
        [new_x1,new_y1]=rotatecoord(x1,y1,theta);
        [new_x2,new_y2]=rotatecoord(x2,y2,theta);
        dx(i)=abs(new_x1-new_x2);
        dy(i)=abs(new_y1-new_y2);
    end
end

position=[flag,dx,dy];
% dlmwrite('output/position.txt', position, '-append', 'delimiter', ' ','precision','%.2f');
save("output/position.mat","position");




%% function appendix
function [outx,outy]=rotatecoord(inx,iny,theta)
    outx=inx*cosd(theta)+iny*sind(theta);
    outy=-inx*sind(theta)+iny*cosd(theta);
end
