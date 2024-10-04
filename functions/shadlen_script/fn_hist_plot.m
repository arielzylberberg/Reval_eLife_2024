function [newScat, newHist,hfig] = fn_hist_plot(X,Y,limi,xlab,ylab,ncats_for_hist,ratio,plot_mean)


if nargin<7 || isempty(ratio)
    ratio = 4;
end

if nargin<8 || isempty(plot_mean)
    plot_mean = 0;
end

diference = X - Y;
% mdif = max(abs(diference));

%%
doTransparency = false;

hPlot = figure;
if ~doTransparency
    
    plot(X,Y,'marker','o','MarkerSize',9,'LineStyle','none','markerEdgeColor',0.0*[1 1 1],...
         'markerFaceColor',.7*[1 1 1],'LineWidth',0.1);
     
else
    t= 0:pi/10:2*pi;
    % r = diff(limi)/100;
    r = diff(limi)/70;
    for i=1:length(X)
        pb = patch((r*sin(t)+ X(i)),(r*cos(t)+Y(i)),0.5*[1,1,1],'edgecolor','none');
        alpha(pb,.5);
    end
end
 
xlim(limi)
ylim(limi)

hold on
plot(xlim,ylim,'color',0.7*[1,1,1])
xlabel(xlab)
ylabel(ylab)
set(gca,'tickdir','out')


%%
hHist = figure;
x = linspace(-max(limi),max(limi),ncats_for_hist);
% x = linspace(-mdif,mdif,ncats_for_hist);


y = histc(diference,x);
step = x(2)-x(1);
h = bar(x+step/2,y);
xlim([min(x) max(x)])

% h = findobj(gca,'Type','patch');
% set(h,'FaceColor',0.5*[1 1 1],'EdgeColor','none','BarWidth',1);
set(h,'FaceColor',0.5*[1 1 1],'EdgeColor','none','BarWidth',1,'LineWidth',1);
set(gca,'tickDir','out')
hold on
plot([0 0],ylim,'color',0.7*[1,1,1])
set(gca,'xcolor','none','ycolor','none','box','off','color','none');

% plot black line
hold on
j = y>0;
xl = max(abs(x(j)));
% plot([x(j(1))+step/2-step, x(j(end))+step/2+step],[0,0],'k')
plot([-xl+step/2-step, xl+step/2+step],[0,0],'k')
% axis off


%% arrow - test
% plot_mean = false;
if plot_mean
    hold on
    mdif = nanmean(diference);
    yli = ylim;
    arrow([mdif yli(2)*.3],[mdif yli(1)],'facecolor','w','edgecolor','k')
end

%%

[newScat, newHist] = cornerHist(hPlot,hHist,ratio);
set(newScat,'ytick',get(newScat,'xtick'));
displace_ax([newScat,newHist],0.1,1);
displace_ax([newScat,newHist],0.1,2);
same_xytick(newScat);

hfig = gcf;
% nontouching_spines(newScat);
format_figure(gcf,'FontSize',18,'LineWidthPlot',1,'LineWidthAxes',1);
% all_text = findall(gcf,'Type','text');
% set(all_text,'FontSize',18);

set(gcf,'color','w');
set(newScat,'box','off');
set(gcf,'Position',[301  265  452  420])
% set(gcf,'Position',[250  205  500  480])



close(hPlot)
close(hHist)