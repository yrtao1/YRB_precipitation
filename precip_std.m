clear;clc;clf;close all;

path2='E:\研究生\MJO\2022暑期工作\(4)降水序列\降水滤波\滤波\';
load ([path2,'p_ano_extended.mat']);
load ([path2,'time_1980to20205to10.mat']);

path3='E:\研究生\MJO\2022暑期工作\(4)降水序列\降水滤波\把1980-2020降水数据拼接起来\';
load ([path3,'lonlat_precipCN.mat']);

%% 选时间区域
lon_area1=find(lon1>=100 & lon1<=130);
lat_area1=find(lat1>=15 & lat1<=45);
lon_pre=lon1(lon_area1,:);
lat_pre=lat1(lat_area1,:);
save lonlat_pre.mat lon_pre lat_pre

pos_1998=find(time_5to10(:,1)==1998 & time_5to10(:,2)>=6 & time_5to10(:,2)<=7);
time1998=time_5to10(pos_1998,:);

ddm=184; % 5-10月
yydm=41; % 1980-2020共41年
precip_ano1=reshape(p_ano,[length(lon1),length(lat1),ddm*yydm]);
precip_1998=precip_ano1(lon_area1,lat_area1,pos_1998);

pos_2016=find(time_5to10(:,1)==2016 & time_5to10(:,2)>=6 & time_5to10(:,2)<=7);
time2016=time_5to10(pos_2016,:);
precip_2016=precip_ano1(lon_area1,lat_area1,pos_2016);
%% 
% std
for ii=1:length(lon_area1)
    for jj=1:length(lat_area1)
        p_1998_std(ii,jj)=nanstd(precip_1998(ii,jj,:));
        p_2016_std(ii,jj)=nanstd(precip_2016(ii,jj,:));
    end
end
clear ii jj

% mean
for ii=1:length(lon_area1)
    for jj=1:length(lat_area1)
        p_1998(ii,jj)=nanmean(precip_1998(ii,jj,:));
        p_2016(ii,jj)=nanmean(precip_2016(ii,jj,:));
    end
end
clear ii jj
%%
[Y,X]=meshgrid(lat_pre,lon_pre);

load std_green.mat
colormap(std_green);
colorbar;
set(gca,'fontsize',12);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'points');
% set(gcf,'position',[0 0 800 400]);
set(gcf,'position',[0 0 1000 400]);
set(gcf, 'PaperPositionMode', 'auto');
set(gcf,'Color',[1,1,1]); 
clf;

% chinamap中国国界线
bond=shaperead('E:\研究生\chinamap\china.shp');
bond_0x=[bond(:).X];
bond_0y=[bond(:).Y];
% chinamap九段线
coast=shaperead('E:\研究生\chinamap\COAST.shp');
%长江黄河
load('E:\研究生\chinamap\长江黄河\yellow.mat'); 
load('E:\研究生\chinamap\长江黄河\yangtze.mat');

figure(1)

subplot(1,2,1)
m_proj('Equidistant','lat',[17 41],'lon',[100 127]);hold on
% m_proj('Equidistant','lat',[25 35],'lon',[100 127]);hold on
m_contourf(X,Y,p_1998_std,10,'LineColor','none');
caxis([0 20]);
ax=colorbar;
colorbar('delete');
hold on
p1=p_1998;
p1(p1<0)=nan;
[c1,h1]=m_contour(X,Y,p1,1:1.5:10,'-k','linewidth',1);
clabel(c1,h1,'color','k','fontsize',8);
set(h1,'ShowText','on','TextList',[1:1.5:10]);
hold on
p12=p_1998;
p12(p12>=0)=nan;
[c1,h1]=m_contour(X,Y,p12,-3:1:0,'--k','linewidth',1);
clabel(c1,h1,'color','k','fontsize',8);
set(h1,'ShowText','on','TextList',[-3:1:0]);
hold on

m_coast('linewidth',0.3,'color','k');
m_plot(coast.X,coast.Y,'k','linewidth',1)  %九段线
hold on
m_plot(yellow_x,yellow_y,'Color','b','LineWidth',1.3); % 叠加黄河
m_plot(yangtze_x,yangtze_y,'Color','b','LineWidth',1.3); % 叠加长江
hold on
m_grid('xtick',90:10:180,'ytick',20:5:40,...
    'linestyle','none','fontsize',8,'tickdir','out');

m_plot([110 122],[27 27],'-r','LineWidth',1.3);
hold on;
m_plot([110 122],[32.5 32.5],'-r','LineWidth',1.3);
hold on;
m_plot([110 110],[27 32.5],'-r','LineWidth',1.3);
hold on;
m_plot([122 122],[27 32.5],'-r','LineWidth',1.3);
hold on;

title('(a) 1998 JJ','FontSize',12 );
ax = gca;
ax.TitleHorizontalAlignment = 'left';


subplot(1,2,2)
m_proj('Equidistant','lat',[17 41],'lon',[100 127]);hold on
% m_proj('Equidistant','lat',[25 35],'lon',[100 127]);hold on
m_contourf(X,Y,p_2016_std,10,'LineColor','none');
caxis([0 20]);
ax=colorbar;
colorbar('delete');
hold on
p2=p_2016;
p2(p2<0)=nan;
[c2,h2]=m_contour(X,Y,p2,1:1.5:10,'-k','linewidth',1);
clabel(c2,h2,'color','k','fontsize',8);
set(h2,'ShowText','on','TextList',[1:1.5:10]);
hold on
p22=p_2016;
p22(p22>=0)=nan;
[c1,h1]=m_contour(X,Y,p22,-3:1:0,'--k','linewidth',1);
clabel(c1,h1,'color','k','fontsize',8);
set(h1,'ShowText','on','TextList',[-3:1:0]);
hold on

m_coast('linewidth',0.3,'color','k');
m_plot(coast.X,coast.Y,'k','linewidth',1)  %九段线
hold on
m_plot(yellow_x,yellow_y,'Color','b','LineWidth',1.3); % 叠加黄河
m_plot(yangtze_x,yangtze_y,'Color','b','LineWidth',1.3); % 叠加长江
hold on
m_grid('xtick',90:10:180,'ytick',20:5:40,...
    'linestyle','none','fontsize',8,'tickdir','out');

m_plot([110 122],[27 27],'-r','LineWidth',1.3);
hold on;
m_plot([110 122],[32.5 32.5],'-r','LineWidth',1.3);
hold on;
m_plot([110 110],[27 32.5],'-r','LineWidth',1.3);
hold on;
m_plot([122 122],[27 32.5],'-r','LineWidth',1.3);
hold on;

title('(b) 2016 JJ','FontSize',12 );
ax = gca;
ax.TitleHorizontalAlignment = 'left';

caxis([0 20]);
hBar=colorbar('location','eastoutside');
set(hBar,'position',[0.942 0.1756 0.0204 0.680],'FontSize',5,'LineWidth',0.5);
% set(hBar,'position',[0.941 0.3365 0.0196 0.368],'FontSize',5,'LineWidth',0.5);
set(hBar,'ytick',[0:4:20],'FontSize',8);% 修改colorbar的间隔
hBar.Label.String = '';
hBar.Label.LineStyle = 'none'; 

%%
print(1,'-r600','JJ 降水std & ano','-djpeg')
print(1,'-r600','JJ 降水std & ano','-depsc')
print(1,'-r600','JJ 降水std & ano','-dsvg')

