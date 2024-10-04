d = load(fullfile('../reval_calc/output_data/delta_vals_optim_per_suj'));

%% histograms
A = d.delta_v_opt(:);

p = publish_plot(1,1);
h1 = histogram(A);
hold all

h1.BinWidth=0.02;


h1.FaceColor = 0.7*[1,1,1];


xlim([-0.5,0.5]);
ylabel('# of participants')
xlabel('Best \delta [$]')
p.format('FontSize',22,'LineWidthAxes',1);
set(gca,'tickdir','out')
set(gca,'xtick',[-0.5:0.25:.5])

set(gcf,'Position',[521  446  479  352])


    plot([0,0],ylim,'k--')
%     xlim([-0.1, 0.5]);
    
    yli = ylim;
    x = mean(A);
    start = [x, yli(1)+diff(yli)*0.15];
    stop = [x, yli(1)];
    h = arrow(start,stop);
    set(h,'LineWidth',2,'FaceColor','b','EdgeColor','b');

    string = [num2str(redondear(x,2))];
    ht = text(x + 0.01,yli(1)+diff(yli)*0.04,string,'VerticalAlignment','bottom','HorizontalAlignment','left');
    set(ht,'FontSize',20,'color','b');

