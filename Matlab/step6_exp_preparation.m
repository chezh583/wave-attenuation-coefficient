% This step has been moved to tetralith due to large data size
clear;clc;
close all

filedir='output/';
list=importdata([filedir,'list_rotated.mat']); % a list containg variables that have been rotated 
% to be pointing to the main wave direction. list includes following variables:
% [wavedir1, X1, Y1, T1, X2, Y2, T2, ICE1, ICE2, UWND1, VWND1, UWND2, VWND2,UCUR1, VCUR1, UCUR2,VCUR2,label]

buoyspec1=importdata(['output/','buoylist1.mat']);  % wave spectrum collected by buoy1
buoyspec2=importdata(['output/','buoylist2.mat']);  % wave spectrum collected by buoy2
frq=importdata(['output/','buoy_frq.mat']); % frequency for wave spectrum collected by buoy
position=importdata([filedir,'position.mat']);

wavedir=list(:,1);
X1=list(:,2); Y1=list(:,3);
X2=list(:,5); Y2=list(:,6);
ICE1=list(:,8); ICE2=list(:,9);
UWND1= list(:,10); VWND1=list(:,11);
UWND2=list(:,12); VWND2=list(:,13);
UCUR1= list(:,14); VCUR1=list(:,15);
UCUR2=list(:,16); VCUR2=list(:,17);
label=list(:,18);
m=length(X1);

% constant
dpt=500; % sea water depth
g=9.8;
thwave=[90 75 60 45 30 15 0 345 330 315 300 285 270 255 240 225 210 195 180 165 150 135 120 105]';
rhow=1030;
rhoa=1.23;
%% quality control
quality=ones(m,1);
for i=1:m
    if (ICE1(i)>0.95 || ICE1(i)<0.15 || ICE2(i)>0.95 || ICE2(i)<0.15)  % limit sea ice concentration
        quality(i)=0;
    end
    if(abs(position(i,2))>30e3 || position(i,3)>50e3)  % limit distance between the two buoys for the assumption of stationarity
        quality(i)=0;
    end
    % if(position(i,1)==1 && ICE1(i)>ICE2(i)+0.1) % buoy1 should be more close to open ocean
    %     quality(i)=0;
    % end
    % if(position(i,1)==2 && ICE2(i)>ICE1(i)+0.1) % buoy2 should be more close to open ocean
    %     quality(i)=0;
    % end
    if(position(i,1)==0)
        quality(i)=0;
    end
    if(position(i,2)^2+position(i,3)^2<8000000)
        quality(i)=0;
    end
end

%% manual quality control and data visualization
myswitch=0;

if(myswitch) % swith on/off manual quality control
    close all
    for i=12%:m
        if (position(i,1)==1)
            fname1=['wvspnc/',num2str(label(i)),'NO1.nc'];
            fname2=['wvspnc/',num2str(label(i)),'NO2.nc'];
            Eftheta1=ncread(fname1,'efth'); Eftheta1=squeeze(Eftheta1(:,:,end,end)); %size: [direction, frequency]
            Eftheta2=ncread(fname2,'efth'); Eftheta2=squeeze(Eftheta2(:,:,end,end)); %size: [direction, frequency]
        end
        if (position(i,1)==2)
            fname1=['wvspnc/',num2str(label(i)),'NO2.nc'];
            fname2=['wvspnc/',num2str(label(i)),'NO1.nc'];
            Eftheta1=ncread(fname1,'efth'); Eftheta1=squeeze(Eftheta1(:,:,end,end)); %size: [direction, frequency]
            Eftheta2=ncread(fname2,'efth'); Eftheta2=squeeze(Eftheta2(:,:,end,end)); %size: [direction, frequency]
        end
    end

    % quality check!
    figure
    subplot(121),wvsp(thwave,frq,Eftheta1);
    title('buoyA')
    subplot(122),wvsp(thwave,frq,Eftheta2);
    title('buoyB')

end
% num=35,40,41,51 is a good case

%% interpolate variables between two buoys
% cut=10; % make two grids to ten grids (eight interpolations between buoys)
dictionary=zeros(2,1);
flag=1;
cutnum=zeros(4,1);
for i=1:m
    if(quality(i) && position(i,3))
        dictionary(flag)=label(i);
        

        %=========read wind speed, current speed, ice concentration========%
        if (position(i,1)==1)
            fname1=['wvspnc/',num2str(label(i)),'NO1.nc'];
            fname2=['wvspnc/',num2str(label(i)),'NO2.nc'];
            Eftheta1=ncread(fname1,'efth'); Eftheta1=squeeze(Eftheta1(:,:,end,end)); %size: [direction, frequency]
            Eftheta2=ncread(fname2,'efth'); Eftheta2=squeeze(Eftheta2(:,:,end,end)); %size: [direction, frequency]
            nc_frq=ncread(fname1,'frequency');
            nc_dir=ncread(fname1,'direction');

            uwnd1=UWND1(i); vwnd1=VWND1(i);uwnd2=UWND2(i); vwnd2=VWND2(i);
            ucur1=UCUR1(i); vcur1=VCUR1(i);ucur2=UCUR2(i); vcur2=VCUR2(i);
            sic1=ICE1(i); sic2=ICE2(i);
        end
        if (position(i,1)==2)
            fname1=['wvspnc/',num2str(label(i)),'NO2.nc'];
            fname2=['wvspnc/',num2str(label(i)),'NO1.nc'];
            Eftheta1=ncread(fname1,'efth'); Eftheta1=squeeze(Eftheta1(:,:,end,end)); %size: [direction, frequency]
            Eftheta2=ncread(fname2,'efth'); Eftheta2=squeeze(Eftheta2(:,:,end,end)); %size: [direction, frequency]
            nc_frq=ncread(fname1,'frequency');
            nc_dir=ncread(fname1,'direction');

            uwnd1=UWND2(i); vwnd1=VWND2(i);uwnd2=UWND1(i); vwnd2=VWND1(i);
            ucur1=UCUR2(i); vcur1=VCUR2(i);ucur2=UCUR1(i); vcur2=VCUR1(i);
            sic1=ICE2(i); sic2=ICE1(i);
        end

        D=position(i,3);
        cut=ceil(D/2000)+1;
        cutnum(flag)=cut;
        flag=flag+1;
        directory=['interpolated_variables/',num2str(label(i)),'/'];
        if not(isfolder(directory))
            mkdir(directory);
        end
        WNDarray=zeros(cut,2);
        CURarray=zeros(cut,2);
        SICarray=zeros(cut,1); 
        DISTANCEarray=zeros(cut,1);

        %apparent attenuation, this might caus nan and inf in Alpha due to
        %measuring error
        Alpha1=log(Eftheta1./Eftheta2)/(2*D);
        Alpha2=log(Eftheta2./Eftheta1)/(2*D);


        for ic=1:cut

            Dic=(ic-1)*D/(cut-1);
            new_uwnd=(uwnd2-uwnd1)*Dic/D+uwnd1;
            new_vwnd=(vwnd2-vwnd1)*Dic/D+vwnd1;
            new_ucur=(ucur2-ucur1)*Dic/D+ucur1;
            new_vcur=(vcur2-vcur1)*Dic/D+vcur1;
            new_sic=(sic2-sic1)*Dic/D+sic1;
            WNDarray(ic,:)=[new_uwnd, new_vwnd];
            CURarray(ic,:)=[new_ucur, new_vcur];
            SICarray(ic)=new_sic;
            DISTANCEarray(ic)=Dic;

            new_nc_name=[directory,'cut',num2str(ic),'.nc'];
            % interp_wvsp=Eftheta1*(cut-ic)/(cut-1) + Eftheta2*(ic-1)/(cut-1);
            interp_wvsp=zeros(24,25);
            % eliminate nan, inf, -inf. Use orignal linear interpolation
            % instead for those points. 
            for indx=1:24
                for indy=1:25                    
                    if(Eftheta1(indx,indy)>Eftheta2(indx,indy))
                        interp_wvsp(indx,indy)=Eftheta1(indx,indy)./exp(2*Alpha1(indx,indy)*Dic);
                    else
                        interp_wvsp(indx,indy)=Eftheta2(indx,indy)./exp(2*Alpha2(indx,indy)*Dic);
                    end
                    if(interp_wvsp(indx,indy)>-10000 && interp_wvsp(indx,indy)<10000)
                    else
                        interp_wvsp(indx,indy)=0;
                    end
                end
            end
            createnc(new_nc_name,nc_frq,nc_dir,interp_wvsp)
        end

        dlmwrite([directory,'wind.txt'], WNDarray, '-append', 'delimiter', ' ','precision','%.2f');
        dlmwrite([directory,'cur.txt'], CURarray, '-append', 'delimiter', ' ','precision','%.2f');
        dlmwrite([directory,'sic.txt'], SICarray, '-append', 'delimiter', ' ','precision','%.2f');
        dlmwrite([directory,'distance.txt'], DISTANCEarray, '-append', 'delimiter', ' ','precision','%.2f');
    end
end
dlmwrite('interpolated_variables/dictionary.txt', dictionary, '-append', 'delimiter', ' ','precision','%i');

%% check intepolation results
result_switch=0;
if(result_switch)
i=232;

    %=========read wind speed, current speed, ice concentration========%
    if (position(i,1)==1)
        fname1=['wvspnc/',num2str(label(i)),'NO1.nc'];
        fname2=['wvspnc/',num2str(label(i)),'NO2.nc'];
        Eftheta1=ncread(fname1,'efth'); Eftheta1=squeeze(Eftheta1(:,:,end,end)); %size: [direction, frequency]
        Eftheta2=ncread(fname2,'efth'); Eftheta2=squeeze(Eftheta2(:,:,end,end)); %size: [direction, frequency]
        nc_frq=ncread(fname1,'frequency');
        nc_dir=ncread(fname1,'direction');

        uwnd1=UWND1(i); vwnd1=VWND1(i);uwnd2=UWND2(i); vwnd2=VWND2(i);
        ucur1=UCUR1(i); vcur1=VCUR1(i);ucur2=UCUR2(i); vcur2=VCUR2(i);
        sic1=ICE1(i); sic2=ICE2(i);
    end
    if (position(i,1)==2)
        fname1=['wvspnc/',num2str(label(i)),'NO2.nc'];
        fname2=['wvspnc/',num2str(label(i)),'NO1.nc'];
        Eftheta1=ncread(fname1,'efth'); Eftheta1=squeeze(Eftheta1(:,:,end,end)); %size: [direction, frequency]
        Eftheta2=ncread(fname2,'efth'); Eftheta2=squeeze(Eftheta2(:,:,end,end)); %size: [direction, frequency]
        nc_frq=ncread(fname1,'frequency');
        nc_dir=ncread(fname1,'direction');

        uwnd1=UWND2(i); vwnd1=VWND2(i);uwnd2=UWND1(i); vwnd2=VWND1(i);
        ucur1=UCUR2(i); vcur1=VCUR2(i);ucur2=UCUR1(i); vcur2=VCUR1(i);
        sic1=ICE2(i); sic2=ICE1(i);
    end
    directory=['interpolated_variables/',num2str(label(i)),'/'];
    WNDarray=importdata([directory,'wind.txt'])
    CURarray=importdata([directory,'cur.txt'])
    SICarray=importdata([directory,'sic.txt'])
end


% for ic=1:floor(cutnum(i)/2):cutnum(i)
%    new_nc_name=[directory,'cut',num2str(ic),'.nc'];
%    efth=ncread(new_nc_name,'efth'); sp=squeeze(efth(:,:,end,end));
%    figure
%    wvsp(nc_dir,nc_frq,sp)
% end



%directory='ww3model/interpolated_variables/90102043/';
%figure
%for ic=1:10
%    new_nc_name=[directory,'cut',num2str(ic),'.nc'];
%    nc_frq=ncread(new_nc_name,'frequency');
%    nc_dir=ncread(new_nc_name,'direction');
%    efth=ncread(new_nc_name,'efth'); sp=squeeze(efth(:,:,end,end));
%    subplot(2,5,ic)
%    wvsp(nc_dir,nc_frq,sp)
%end


