D{1} = load('../reval_calc/output_data/delta_vals_optim_per_suj_folke.mat');
D{2} = load('../reval_calc/output_data/delta_vals_optim_per_suj_sepulveda_PREF.mat');
D{3} = load('../reval_calc/output_data/delta_vals_optim_per_suj_sepulveda_NPREF.mat');

%%

d = D{3};

% plot(d.dev_opt, d.dev_opt_bwards,'o');
% hold all
% refline(1,0)


%%
p = publish_plot(3,3);
set(gcf,'Position',[717  294  907  890]);

N = length(D);
for k=1:N
    d = D{k};

    p.current_ax(k);
    a = d.delta_v_opt;
    b =  d.delta_v_opt_fake;

    [~,pval] = ttest(a,b);
    p.text_draw(p.current_ax,['p =',num2str(pval)]);

    % do hist
    % edges = -0.5:0.02:0.5;
    m = max(abs([a(:);b(:)]));
    m = ceil(m*10)/10;
    edges = linspace(-m,m,30);
    h(1) = histogram(a,edges);
    hold on
    h(2) = histogram(b,edges);
    % set(h,'binwidth',0.02);

    set(h(1),'FaceColor',0.8*[1,1,1],'edgecolor','k','LineWidth',0.5);
    set(h(2),'FaceColor',[250,208,208]/255,'edgecolor','r','LineWidth',0.5);

    ylabel('# of participants');
    xlabel('Best \delta [$]');

    symmetric_x(gca);
    % set(gca,'xtick',-0.5:0.25:0.5);


    p.current_ax(k + N);
    a1 = d.dev_opt;
    b1 =  d.dev_noreev_persuj';
    plot(a1,b1,'ko','markerfacecolor',0.8*[1,1,1]);

    hold on
    a2 =  d.dev_opt_fake;
    b2 = d.dev_noreev_persuj_fake';
    plot(a2,b2,'o','color','r','markerfacecolor',[250,208,208]/255);
    same_xylim(gca);
    axis square

    [~,pval] = ttest(a1-b1,a2-b2);
    p.text_draw(p.current_ax,['p =',num2str(pval)]);

    h = refline(1,0);
    set(h,'color',0.7*[1,1,1]);
    hold on

    borde_en_axis(gca,'color','k');

    xlabel('Deviance (Reval)')
    ylabel('Deviance (No Reval)');
    axis square

    p.current_ax(k + 2*N);
    a = d.dev_opt;
    b =  d.dev_opt_bwards;
    plot(a,b,'ko','markerfacecolor',0.8*[1,1,1]);

    hold on
%     [~,pval] = ttest(a,b,'tail','left');
    [~,pval] = ttest(a,b);
    p.text_draw(p.current_ax,['p =',num2str(pval)]);
    % a = NR.dev_opt;
    % b =  NR.dev_noreev_persuj';
    % plot(a,b,'o','color','r','markerfacecolor',[250,208,208]/255);
    same_xylim(gca);
    axis square

    h = refline(1,0);
    set(h,'color',0.7*[1,1,1]);
    hold on
    borde_en_axis(gca,'color','k');

    xlabel('Deviance (Forward Reval)')
    ylabel('Deviance (Backwards Reval)');



    p.format('FontSize',13,'LineWidthPlot',0.5);

end
