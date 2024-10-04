function [newScat, newHist] = fn_hist_plot_many(X,Y,limi,xlab,ylab,ncats_for_hist,ratio,varargin)


if nargin<7 || isempty(ratio)
    ratio = 4;
end

if ~iscell(X) % expects cell
    X = {X};
    Y = {Y};
end

nx = length(X);
colores = cbrewer('qual','Set2',max(nx,3));
colores = colores(1:nx,:);

doTransparency = true;
for i=1:length(varargin)
    if isequal(varargin{i},'transparency')
        doTransparency = varargin{i+1}==1;
    elseif isequal(varargin{i},'colores')
        colores = varargin{i+1};
    end
end

%%

for i=1:nx
    diference{i} = X{i} - Y{i};
end
% mdif = max(abs(diference));

%%


hPlot = figure;
if ~doTransparency
    for i=1:nx
        plot(X{i},Y{i},'marker','o','MarkerSize',7,'LineStyle','none','markerFaceColor',colores(i,:),...
            'markerEdgeColor',0.7*[1 1 1],'LineWidth',0.1);
        hold all
    end
else
    t= 0:pi/10:2*pi;
    % r = diff(limi)/100;
    r = diff(limi)/70;
    for j=1:nx
        x = X{j};
        y = Y{j};
        for i=1:length(x)
            pb = patch((r*sin(t)+ x(i)),(r*cos(t)+y(i)),0.5*[1,1,1],'edgecolor','none','FaceColor',colores(j,:));
            alpha(pb,.5);
            hold all
        end
    end
end

xlim(limi)
ylim(limi)

hold on
plot(xlim,ylim,'r-')
xlabel(xlab)
ylabel(ylab)
set(gca,'tickdir','out')


%%
hHist = figure;
x = linspace(-max(limi),max(limi),ncats_for_hist);
% x = linspace(-mdif,mdif,ncats_for_hist);


clear y
for i=1:nx
    y(:,i) = histc(diference{i},x);
end

step = x(2)-x(1);
h = bar(x+step/2,y,'stacked');
xlim([min(x) max(x)])

for i=1:nx
    set(h(i),'FaceColor',colores(i,:),'EdgeColor','none','BarWidth',1);
end

set(gca,'tickDir','out')
hold on
plot([0 0],ylim,'r')
axis off


%% arrow - test
plot_mean = true;
if plot_mean
    for i=1:nx
        hold on
        mdif = nanmean(diference{i});
        yli = ylim;
%         plot([mdif mdif],[yli(1) yli(2)*.2],'color','w');
        arrow([mdif,yli(2)*0.2],[mdif,yli(1)],'facecolor',colores(i,:),'edgecolor','w')
    end
end

%%

[newScat, newHist] = cornerHist(hPlot,hHist,ratio);
set(newScat,'ytick',get(newScat,'xtick'));

nontouching_spines(newScat);
format_figure(gcf,'FontSize',18)

close(hPlot)
close(hHist)