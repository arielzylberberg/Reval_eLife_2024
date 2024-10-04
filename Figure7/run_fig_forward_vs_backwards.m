
addpath(genpath('../generic_functions/'))

% datasource = 1;
datasource = 1;
switch datasource
    case 1
        load ../data/prepro_data.mat
        d = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');
        str = '';
    

    case 2 % pink ev simulations
        f = '../ceDDM_fit';
        dat = load(fullfile(f,'sim_data.mat'));
        str = 'pink_ev';
        d = load('../reval_calc/output_data/delta_vals_optim_pink_ev.mat');


end

%%


p = publish_plot(1,2);
% set(gcf,'Position',[335  306  394  311]);

A1 = d.dev_opt(:);
B1 = d.dev_opt_bwards(:);

A2 = d.dev_noreev_persuj(:);
B2 = d.dev_opt_bwards(:);

li(1) = min([A1;B1;A2;B2])-5;
li(2) = max([A1;B1;A2;B2])+5;


p.next();

plot(A1,B1,'marker','o','MarkerSize',9,'LineStyle','none','markerEdgeColor',0.0*[1 1 1],...
         'markerFaceColor',.7*[1 1 1],'LineWidth',0.5);
axis square;
xlim(li);
ylim(li);
h(1) = refline(1,0);

xlabel('Deviance (forward Reval)');
ylabel('Deviance (backward Reval)');

borde_en_axis(gca,'color','k');

p.next();

plot(A2,B2,'marker','o','MarkerSize',9,'LineStyle','none','markerEdgeColor',0.0*[1 1 1],...
         'markerFaceColor',.7*[1 1 1],'LineWidth',0.5);
axis square;
xlim(li);
ylim(li);
h(2) = refline(1,0);

borde_en_axis(gca,'color','k');

% same_xylim(p.h_ax(1));




set(h,'color',0.0*[1,1,1],'LineStyle','-','LineWidth',0.5);
set(p.h_ax,'color','w','FontSize',14,'box','off','tickdir','out');
% p.format();
ylabel('Deviance (backward Reval)');
xlabel('Deviance (no Reval)');

%%
% p.current_ax(k + N);
%     a1 = d.dev_opt;
%     b1 =  d.dev_noreev_persuj';
%     plot(a1,b1,'ko','markerfacecolor',0.8*[1,1,1]);
% 
%     hold on
%     a2 =  d.dev_opt_fake;
%     b2 = d.dev_noreev_persuj_fake';
%     plot(a2,b2,'o','color','r','markerfacecolor',[250,208,208]/255);
%     same_xylim(gca);
%     axis square
% 
%     [~,pval] = ttest(a1-b1,a2-b2);
%     p.text_draw(p.current_ax,['p =',num2str(pval)]);
% 
%     h = refline(1,0);
%     set(h,'color',0.7*[1,1,1]);
%     hold on
% 
%     borde_en_axis(gca,'color','k');
% 
%     xlabel('Deviance (Reval)')
%     ylabel('Deviance (No Reval)');

