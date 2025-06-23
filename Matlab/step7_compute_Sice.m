clear;clc;
close all


%% dispersion relation, mass-loading model
frq=zeros(25,1);
frq(1)=0.05;
for i=2:25
     frq(i)=frq(i-1)*1.0694;
end
omega=2*pi*frq;
rho_ice=910;
rho_sea=1025;
g=9.8;
% h=importdata('h.mat');
% h=0.5*(h(:,1)+h(:,2));
d=500;

%=========================
source_dir='expoutput/';
%=========================

%%
list=importdata('output/list_rotated.mat');
dic=importdata("interpolated_variables/dictionary.txt");
len=length(dic);
out_ki=zeros(25,len);



%%




i=11;
temparray=importdata(['interpolated_variables/',num2str(dic(i)),'/sic.txt']);
cut=length(temparray);
Ef=zeros(25,cut);
Sin=Ef; Sds=Ef; Snl=Ef;
for j=1:cut
    fname=[source_dir,num2str(dic(i)),'_cut',num2str(j),'.nc'];
    ef=ncread(fname,'ef'); ef=squeeze(ef(:,end,end)); Ef(:,j)=ef;
    sin=ncread(fname,'sin'); sin=squeeze(sin(:,end,end)); Sin(:,j)=sin;
    sds=ncread(fname,'sds'); sds=squeeze(sds(:,end,end)); Sds(:,j)=sds;
    snl=ncread(fname,'snl'); snl=squeeze(snl(:,end,end)); Snl(:,j)=snl;
    f=ncread(fname,'frequency');
end
figure, subplot(121)
plot(f,Ef,'k'), xlim([0.05 0.25])
subplot(122)
plot(f,Sin,'k--'), hold on
plot(f,Sds,':');
plot(f,Snl), xlim([0.05 0.25])
title(source_dir)



% 
figure
subplot(131)
loglog(f,Ef(:,1),'k','LineWidth',1)
hold on
loglog(f,Ef(:,end),'k--','LineWidth',1)
y=1e-9*f(10:23).^(-4);
loglog(f(10:23),y,'LineWidth',1)
xlabel('$f$ (Hz)','fontsize',16,'FontName','times','Interpreter','latex')
ylabel('PSD (m$^2$/Hz)','fontsize',16,'FontName','times','Interpreter','latex')
xlim([0.05 0.25])
legend('$E(f)$ upstream','$E(f)$ downstream','fontsize',14,'fontname','times','Interpreter','latex')

subplot(132)
yyaxis left
plot(f,Sin(:,1),'k','LineWidth',1)
hold on
plot(f,Sin(:,end),'k--','LineWidth',1)
ylabel('$S_{in}$ (m$^{-1}$)','fontsize',16,'FontName','times','Interpreter','latex')


yyaxis right
plot(f,Snl(:,1),'LineWidth',1,'Color',[0.6 0.6 0.6])
hold on
plot(f,Snl(:,end),'--','LineWidth',1,'Color',[0.6 0.6 0.6])
xlim([0.05 0.25])
ylabel('$S_{nl}$ (m$^{-1}$)','fontsize',16,'FontName','times','Interpreter','latex')
legend('$S_{in}$ upstream','$S_{in}$ downstream','$S_{nl}$ upstream','$S_{nl}$ downstream','Interpreter','latex','fontsize',14,'fontname','times')
ylim([-7e-11 5e-11])

ax = gca;
ax.YAxis(1).Color = 'k';
ax.YAxis(2).Color = [0.4 0.4 0.4];
xlabel('$f$ (Hz)','fontsize',16,'FontName','times','Interpreter','latex','fontsize',14,'fontname','times')

subplot(133)

loglog(f,out_ki_simple(:,i),'LineWidth',1,'Color',[0.6 0.6 0.6])
hold on
loglog(f,out_ki(:,i),'k','LineWidth',1)
xlim([0.05 0.25])
xlabel('$f$ (Hz)','fontsize',16,'FontName','times','Interpreter','latex')
ylabel('$k_i$ (m$^{-1}$)','fontsize',16,'FontName','times','Interpreter','latex')
legend('$k_i$ simple','$k_i$ full','Interpreter','latex','fontsize',14,'fontname','times')







method=2;
%%
if (method==1)
% method1: calculate Sice in each cut, and average them to get final results
disparity=ones(len,1);


for i=1:len
if(disparity(i))
        temparray=importdata(['interpolated_variables/',num2str(dic(i)),'/sic.txt']);
         cut=length(temparray);
         Ef=zeros(25,cut);
         Sin=zeros(25,cut);
         Sds=zeros(25,cut);
         Snl=zeros(25,cut);
        for j=1:cut
            fname=[source_dir,num2str(dic(i)),'_cut',num2str(j),'.nc'];
            ef=ncread(fname,'ef'); ef=squeeze(ef(:,end,end)); Ef(:,j)=ef;
            sin=ncread(fname,'sin'); sin=squeeze(sin(:,end,end)); Sin(:,j)=sin;
            sds=ncread(fname,'sds'); sds=squeeze(sds(:,end,end)); Sds(:,j)=sds;
            snl=ncread(fname,'snl'); snl=squeeze(snl(:,end,end)); Snl(:,j)=snl;
            f=ncread(fname,'frequency');
        end

        Sum_Sin_Sds=zeros(25,1);
        Sum_Snl=zeros(25,1);
        Sum_E=zeros(25,1);
        Sice=zeros(25,cut-1);
        ki=zeros(25,cut-1);
        ICE=importdata(['interpolated_variables/',num2str(dic(i)),'/sic.txt']);
        D=importdata(['interpolated_variables/',num2str(dic(i)),'/distance.txt']);
        for dx=1:cut-1
            delta_Sin_Sds=0.5*(Sin(:,dx)+Sin(:,dx+1)+Sds(:,dx)+Sds(:,dx+1));
            delta_Snl=0.5*(Snl(:,dx)+Snl(:,dx+1));
            c=0.5*(ICE(dx)+ICE(dx+1));

            d=D(dx+1)-D(dx);
            Sum_Sin_Sds=(1-c)*delta_Sin_Sds*d;
            Sum_Snl=delta_Snl*d;
            kr=omega.^2./(g-c*rho_ice*h(i)*omega.^2/rho_sea);
            cg=diff(omega)./diff(kr); cg=[cg;cg(end)+cg(end)-cg(end-1)];
            Sum_E=cg.*(Ef(:,dx+1)-Ef(:,dx));
            Sice(:,dx)=(Sum_E-Sum_Snl-Sum_Sin_Sds)/(c*d);
            ki(:,dx)=-Sice(:,dx)./(2*cg.*(Ef(:,dx+1)+Ef(:,dx))*0.5);
        end
        % out_ki(:,i)=mean(ki,2); % method1: direct mean

        temp=ki; 
        for indx=1:25
            count=0;
            sum_k=0;
            for indy=1:cut-1
                if(temp(indx,indy)>0 && temp(indx,indy)<100)
                    count=count+1;
                    sum_k=sum_k+temp(indx,indy);
                end
            end
            if count>5
                out_ki(indx,i)=sum_k/count;
            else
                out_ki(indx,i)=nan;
            end
        end

        % va=var(ki');
        % out_ki(find(va>1e-6),i)=nan;

        % temp(find(ki<0))=nan;
        % logki=log10(temp);
        %
        % out_ki(:,i)=mean(logki,2);
        % out_ki(:,i)=10.^out_ki(:,i);

end
end
% following figure function is used for filtering bad data
% figure
% subplot(121),loglog(frq,Ef)
% xlabel('frequency')
% ylabel('wave spectrum')
% subplot(122),loglog(frq,ki)
% xlim([0.05 0.25])
% xlabel('frequency')
% ylabel('ki')

end

%%
if(method==2)
if(method==2)
% method 2: calculate non-Sic in each cut, and get Sic from residual
 disparity=ones(len,1);
% % disparity([ 4 5 6 8 9 10 11 13 14 15 19 25 26 33 34 40 41 42 43 44 45 46 47 48 52 53 58 61 62 63 64 65 66 67 71 72])=0;
% 
 close all
 
 for i=1:len
     if(disparity(i))
         temparray=importdata(['interpolated_variables/',num2str(dic(i)),'/sic.txt']);
         cut=length(temparray);
         Ef=zeros(25,cut);
         Sin=zeros(25,cut);
         Sds=zeros(25,cut);
         Snl=zeros(25,cut);
         Sice=zeros(25,len);         
         for j=1:cut
             fname=[source_dir,num2str(dic(i)),'_cut',num2str(j),'.nc'];
             ef=ncread(fname,'ef'); ef=squeeze(ef(:,end,end)); Ef(:,j)=ef;
             sin=ncread(fname,'sin'); sin=squeeze(sin(:,end,end)); Sin(:,j)=sin;
             sds=ncread(fname,'sds'); sds=squeeze(sds(:,end,end)); Sds(:,j)=sds;
             snl=ncread(fname,'snl'); snl=squeeze(snl(:,end,end)); Snl(:,j)=snl;
             f=ncread(fname,'frequency');
         end
 
         ICE=importdata(['interpolated_variables/',num2str(dic(i)),'/sic.txt']);
         D=importdata(['interpolated_variables/',num2str(dic(i)),'/distance.txt']);
 
         term0=zeros(25,1); % cgE
         term1=zeros(25,1); % (1-c)(Sin+Sds)
         term2=zeros(25,1); % Snl
         term3_int=zeros(25,1);
         for dx=2:cut
             c=0.5*(ICE(dx-1)+ICE(dx));%
             % c=0.44*c;
             d=D(dx)-D(dx-1);
 
             %dispersion relation
             %h(i)=1; %for testing
             % kr=omega.^2./(g-c*rho_ice*h(i)*omega.^2/rho_sea);
             % cg=diff(omega)./diff(kr); cg=[cg;cg(end)+cg(end)-cg(end-1)];

             k=omega.^2/g;
             cp=sqrt(g*tanh(k*d)./k);
             cg=0.5*(1+(2*k*d)./(sinh(2*k*d))).*cp;
 
             % term0=term0+cg.*(Ef(:,dx)-Ef(:,dx-1))./d;
             % term1=term1+(1-c)*0.5*(Sin(:,dx-1)+Sin(:,dx)+Sds(:,dx-1)+Sds(:,dx));
             % term2=term2+0.5*(Snl(:,dx-1)+Snl(:,dx));
             % term3_int=term3_int-2*c*cg.*0.5.*(Ef(:,dx-1)+Ef(:,dx));

             term0=term0+cg.*Ef(:,dx)-cg.*Ef(:,dx-1);
             % term0=term0-(log(Ef(:,dx)./Ef(:,dx-1)))/d;
             term1=term1+0.5*((Sin(:,dx-1)+Sds(:,dx-1))*(1-c)+(Sin(:,dx)+Sds(:,dx))*(1-c))*d;
             term2=term2+0.5*(Snl(:,dx-1)+Snl(:,dx))*d;
             term3_int=term3_int+0.5*(-2*c*cg.*Ef(:,dx-1)-2*c*cg.*Ef(:,dx))*d;
         end
         term3=term0-term1-term2;
         out_ki(:,i)=term3./term3_int;
         out_ki_simple(:,i)=term0./term3_int;
     end
 
     % va=var(ki');
     % out_ki(find(va>1e-6),i)=nan;
 
     % temp(find(ki<0))=nan;
     % logki=log10(temp);
     %
     % out_ki(:,i)=mean(logki,2);
     % out_ki(:,i)=10.^out_ki(:,i);
 end


end

end


%% apparent attenuation

buoyspec1=importdata(['output/buoylist1.mat']);  % wave spectrum collected by buoy1
buoyspec2=importdata(['output/buoylist2.mat']);  % wave spectrum collected by buoy2
position=importdata(['output/position.mat']);

alpha=zeros(25,len);
D=position(:,3);
dic=num2str(dic);
for i=1:len
    if(disparity(i))
    templabel=str2num(dic(i,:));
    inum=find(list(:,end)==templabel);
    if(position(inum,1)==1)
        b1=buoyspec1(:,inum);b2=buoyspec2(:,inum);
    end
    if(position(inum,1)==2)
        b2=buoyspec1(:,inum);b1=buoyspec2(:,inum);
    end
    alpha(:,i)=log(b1./b2)/(D(inum));
    end
end

ALP=zeros(len,1);
for i=1:len
    if(disparity(i))
    templabel=str2num(dic(i,:));
    inum=find(list(:,end)==templabel);
    if(position(inum,1)==1)
        b1=trapz(f,buoyspec1(:,inum));b2=trapz(f,buoyspec2(:,inum));
    end
    if(position(inum,1)==2)
        b2=trapz(f,buoyspec1(:,inum));b1=trapz(f,buoyspec2(:,inum));
    end
    ALP(i)=log(b1./b2)/(D(inum));
    end
end

figure
plot(f,buoyspec1(:,inum));
hold on
plot(f,buoyspec2(:,inum));

figure
plot(f,alpha(:,1));
hold on
plot(f,ALP(1)*ones(25,1));
plot(f,trapz(f,alpha(:,1))*ones(25,1))
plot(f,mean(alpha(:,1))*ones(25,1))

legend('alpha(f)','alpha_sig','int(f,alpha(f))','mean(alpha(f))')
%%

figure
subplot(131)
loglog(frq,alpha,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Apparent attenuation rate (m^{-1})')
ylim([1e-8 1e-1])
subplot(132)
loglog(frq,out_ki,'Color',[0.3 0.3 0.3])
xlim([0.05 0.25])
xlabel('Frequency (Hz)')
ylabel('Amplitude attenuation rate (m^{-1})')
ylim([1e-7 1e0])
subplot(133)
loglog(frq,out_ki_simple,'Color',[0.3 0.3 0.3])

save('output/alpha.mat',"alpha");
save('output/out_ki.mat',"out_ki");
save('output/out_ki_simple.mat',"out_ki_simple");


% a=0.05:0.01:0.25;
% b1=a.^1.9;
% b2=a.^2.9;
% b3=a.^3.6;
% hold on
% plot(a,b1,'LineWidth',2)
% plot(a,b2,'LineWidth',1)
% plot(a,b3,'LineWidth',2)


% dlmwrite('out_ki2.txt', out_ki, '-append', 'delimiter', ' ','precision','%.10f');
% dlmwrite('alpha2.txt', alpha, '-append', 'delimiter', ' ','precision','%.10f');
 % saveas(gcf,'fig2.png')
%%
