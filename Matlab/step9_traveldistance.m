clear;clc;
close all

%NOTICE: NEED CHANGE POSSIBLE WAVE DIRECTION RANGE
%purpose: calculate the distance between the buoy and the ice edge. 


% loop data
list=importdata('output/list_rotated.mat');
dic=importdata("interpolated_variables/dictionary.txt");
len=length(dic);

ncf='nest_result.nc';
time=datestr(days(ncread(ncf,'time'))+datetime(1990,1,1),'yyyymmddHH');
sic=ncread(ncf,'ice'); %dim=[x,y,time]
x=ncread(ncf,'x');
y=ncread(ncf,'y');
[modeltimelen,temp]=size(time);
Y=repmat(y',length(x),1);
X=repmat(x,1,length(y));

dxdMIZ=zeros(len,2);
disparity=ones(len,1);
buoysic=zeros(len,2);

%%
close all
%=======================%
method=2;
%=======================%

if(method==1)
for i=1:len
    ind=find(list(:,end)==dic(i));
    buoytime=list(ind,4);
    buoytime=num2str(buoytime);
    buoytime=buoytime(1:10);
    wavedir=list(ind,1);
    if(wavedir>30 && wavedir<210) %% wave direction in this rage is possibly wind wave offshore
    % if(0)
        disparity(i)=0;
        dxdMIZ(i,1)=nan;
        dxdMIZ(i,2)=nan;
    else
        buoy1_x=list(ind,2);
        buoy1_y=list(ind,3);
        buoy2_x=list(ind,5);
        buoy2_y=list(ind,6);
        buoysic(i,1)=list(ind,8);
        buoysic(i,2)=list(ind,9);
        for t=1:modeltimelen
            if(strcmp(buoytime,time(t,:)))
                M=contour(X,Y,sic(:,:,t),[0.15, 0.15], 'LineWidth', 2);
                [s,num]=contourdata(M);
                points=zeros(num,1);
                for x=1:num
                    points(x)=s(x).numel;
                end
                [maxval,index]=max(points);
                [out,idx] = sort(points);

                line_x=[s(idx(end)).xdata];
                line_y=[s(idx(end)).ydata];
                
                [x1series, y1series] = createline(buoy1_x,buoy1_y,100);
                [x2series, y2series] = createline(buoy2_x,buoy2_y,100);
                
                 wavedir=-wavedir; %this is used to fit lrotate function settings. 
                [newx1, newy1]=lrotate(x1series,y1series, wavedir, buoy1_x, buoy1_y);
                [newx2, newy2]=lrotate(x2series,y2series, wavedir, buoy2_x, buoy2_y);
                % 
                % figure
                % h=pcolor(X,Y,sic(:,:,t));
                % set(h, 'EdgeColor', 'none');
                % hold on
                % plot(line_x,line_y,'r-', 'LineWidth', 2);
                % hold on
                % plot(newx1,newy1, 'LineWidth', 2,'Color','k')
                % hold on
                % plot(newx2,newy2, 'LineWidth', 2,'Color','k')
                % plot(buoy1_x,buoy1_y,'*');
                % plot(buoy2_x,buoy2_y,'*');

                [buoy1_intersec_x,buoy1_intersec_y] = intersections(newx1,newy1,line_x,line_y);
                [buoy2_intersec_x,buoy2_intersec_y] = intersections(newx2,newy2,line_x,line_y);
                
                if (length(buoy1_intersec_x)>=1)
                    D=sqrt((buoy1_x-buoy1_intersec_x).^2+(buoy1_y-buoy1_intersec_y).^2);
                    [minval,mindex]=min(D);
                    buoy1_intersec_x=buoy1_intersec_x(mindex);
                    buoy1_intersec_y=buoy1_intersec_y(mindex);
                    % plot([buoy1_x buoy1_intersec_x],[buoy1_y buoy1_intersec_y], 'LineWidth', 4,'Color','r')
                    dxdMIZ(i,1)=sqrt((buoy1_x-buoy1_intersec_x)^2+(buoy1_y-buoy1_intersec_y)^2);
                else
                    dxdMIZ(i,1)=nan;
                end
                if(length(buoy2_intersec_x)>=1)
                    D=sqrt((buoy2_x-buoy2_intersec_x).^2+(buoy2_y-buoy2_intersec_y).^2);
                    [minval,mindex]=min(D);
                    buoy2_intersec_x=buoy2_intersec_x(mindex);
                    buoy2_intersec_y=buoy2_intersec_y(mindex);
                    % plot([buoy2_x buoy2_intersec_x],[buoy2_y buoy2_intersec_y], 'LineWidth', 4,'Color','r')
                    dxdMIZ(i,2)=sqrt((buoy2_x-buoy2_intersec_x)^2+(buoy2_y-buoy2_intersec_y)^2);
                else
                    dxdMIZ(i,2)=nan;
                end
            end
        end
    end

end
end

if(method==2)
for i=1:len
    ind=find(list(:,end)==dic(i));
    buoytime=list(ind,4);
    buoytime=num2str(buoytime);
    buoytime=buoytime(1:10);
    wavedir=list(ind,1);
    % if(wavedir>=30 && wavedir<=210) %% wave direction in this range is possibly wind wave offshore
    %     disparity(i)=0;
    %     dxdMIZ(i,1)=nan;
    %     dxdMIZ(i,2)=nan;
        % wavedir=330;
    % end
    % else
        buoy1_x=list(ind,2);
        buoy1_y=list(ind,3);
        buoy2_x=list(ind,5);
        buoy2_y=list(ind,6);
        buoysic(i,1)=list(ind,8);
        buoysic(i,2)=list(ind,9);
        for t=1:modeltimelen
         
            if(strcmp(buoytime,time(t,:)))
                
                M=contour(X,Y,sic(:,:,t),[0.15, 0.15], 'LineWidth', 2);
                [s,num]=contourdata(M);
                points=zeros(num,1);
                for x=1:num
                    points(x)=s(x).numel;
                end
                [maxval,ind]=max(points);
                line_x=s(ind).xdata;
                line_y=s(ind).ydata;
                lenp=length(line_x);
                
                dx1=1e9; dx2=1e9;
                flag=1;
                for lin=1:lenp
                    tempD1=sqrt((line_x(lin)-buoy1_x)^2+(line_y(lin)-buoy1_y)^2);
                    tempD2=sqrt((line_x(lin)-buoy2_x)^2+(line_y(lin)-buoy2_y)^2);

                    if(tempD1<dx1)
                        dx1=tempD1;
                        flag=lin;
                    end
                    if(tempD2<dx2)
                        dx2=tempD2;
                    end
                end
               dxdMIZ(i,1)=dx1;
               dxdMIZ(i,2)=dx2;
               % 
               % figure
               % h=pcolor(X,Y,sic(:,:,t));
               % set(h, 'EdgeColor', 'none');
               % hold on
               % plot(line_x,line_y,'r-', 'LineWidth', 2);
               % plot(buoy1_x,buoy1_y,'*');
               % plot(line_x(flag),line_y(flag),'*');
                % [x1series, y1series] = createline(buoy1_x,buoy1_y,100);
                % [x2series, y2series] = createline(buoy2_x,buoy2_y,100);
                % 
                %  wavedir=-wavedir; %this is used to fit lrotate function settings. 
                % [newx1, newy1]=lrotate(x1series,y1series, wavedir, buoy1_x, buoy1_y);
                % [newx2, newy2]=lrotate(x2series,y2series, wavedir, buoy2_x, buoy2_y);
                % 
                % figure
                % h=pcolor(X,Y,sic(:,:,t));
                % set(h, 'EdgeColor', 'none');
                % hold on
                % plot(line_x,line_y,'r-', 'LineWidth', 2);
                % hold on
                % plot(newx1,newy1, 'LineWidth', 2,'Color','k')
                % hold on
                % plot(newx2,newy2, 'LineWidth', 2,'Color','k')

                % [buoy1_intersec_x,buoy1_intersec_y] = intersections(newx1,newy1,line_x,line_y);
                % [buoy2_intersec_x,buoy2_intersec_y] = intersections(newx2,newy2,line_x,line_y);
                % 
                % if (length(buoy1_intersec_x)>=1)
                %     D=sqrt((buoy1_x-buoy1_intersec_x).^2+(buoy1_y-buoy1_intersec_y).^2);
                %     [minval,mindex]=min(D);
                %     buoy1_intersec_x=buoy1_intersec_x(mindex);
                %     buoy1_intersec_y=buoy1_intersec_y(mindex);
                %     % plot([buoy1_x buoy1_intersec_x],[buoy1_y buoy1_intersec_y], 'LineWidth', 4,'Color','r')
                %     dxdMIZ(i,1)=sqrt((buoy1_x-buoy1_intersec_x)^2+(buoy1_y-buoy1_intersec_y)^2);
                % else
                %     dxdMIZ(i,1)=nan;
                % end
                % if(length(buoy2_intersec_x)>=1)
                %     D=sqrt((buoy2_x-buoy2_intersec_x).^2+(buoy2_y-buoy2_intersec_y).^2);
                %     [minval,mindex]=min(D);
                %     buoy2_intersec_x=buoy2_intersec_x(mindex);
                %     buoy2_intersec_y=buoy2_intersec_y(mindex);
                %     % plot([buoy2_x buoy2_intersec_x],[buoy2_y buoy2_intersec_y], 'LineWidth', 4,'Color','r')
                %     dxdMIZ(i,2)=sqrt((buoy2_x-buoy2_intersec_x)^2+(buoy2_y-buoy2_intersec_y)^2);
                % else
                %     dxdMIZ(i,2)=nan;
                % end
            end
        end
    % end

end
end

figure
plot(dxdMIZ(:,1))
figure
plot(dxdMIZ(:,2))

save('output/disparity.mat','disparity');
save('output/dxdMIZ.mat','dxdMIZ');
%% test
% clear;clc;
% x=ones(100,1)*100;
% y=[1:100]';
% xc=x(50); yc=y(50);
% wavedir=345;
% wavedir=-wavedir;
% [newx, newy]=lrotate(x,y, wavedir, xc, yc);
% 
% figure
% plot(x,y)
% hold on
% plot(newx,newy)
% axis equal;

%% appendix function
function [s,num]=contourdata(c)

if nargin<1 || ~isfloat(c) || size(c,1)~=2 || size(c,2)<4
   error('CONTOURDATA:rhs',...
         'Input Must be the 2-by-N Contour Matrix C.')
end

tol=1e-12;
k=1;     % contour line number
col=1;   % index of column containing contour level and number of points

while col<size(c,2); % while less than total columns in c
   s(k).level = c(1,col); %#ok
   s(k).numel = c(2,col); %#ok
   idx=col+1:col+c(2,col);
   s(k).xdata = c(1,idx).'; %#ok
   s(k).ydata = c(2,idx).'; %#ok
   s(k).isopen = abs(diff(c(1,idx([1 end]))))>tol || ...
                 abs(diff(c(2,idx([1 end]))))>tol; %#ok
   k=k+1;
   col=col+c(2,col)+1;
end
num=k-1;
end

function [xseries, yseries] = createline(x,y,len)
    xseries=ones(len,1)*x;
    yseries=2000*[0:-1:-len+1]';
    yseries=yseries+y;
end

function[xf, yf]=lrotate(x,y, a, x0, y0)
% x and Y are the input vectors whose line graph to be rotated.
% a: angle of rotation
%x0, y0 the x and y coordinate of the point about which the line is to be rotated
% returns: xf and yf which forms the rotated graph
%
n=length(x);
xf=NaN(size(x));
yf=NaN(size(y));
for i=1:n
 x1=x(i);
 y1=y(i);
 r=sqrt((y1-y0)^2+(x1-x0)^2);
 if((x1>=x0)&&(y1>=y0))
     b=atand((y1-y0)/(x1-x0));
     x2=x0+r*cosd(a+b);
     y2=y0+r*sind(a+b);
 elseif((x1<x0)&&(y1>=y0))
     b=atand((y1-y0)/(x0-x1));
     x2=x0-r*cosd(b-a);
     y2=y0+r*sind(b-a);
 elseif ((x1<x0)&&(y1<y0))
     b=atand((y0-y1)/(x0-x1));
     x2=x0-r*cosd(b+a);
     y2=y0-r*sind(b+a);
 elseif ((x1>=x0)&&(y1<y0))
     b=atand((y0-y1)/(x1-x0));
     x2=x0+r*cosd(b-a);
     y2=y0-r*sind(b-a);
 end
 xf(i)=x2;
 yf(i)=y2;
end
end
