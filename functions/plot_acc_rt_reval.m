function p = plot_acc_rt_reval(values_re,values,choices,rt)

% load ../rawdata/prepro_data.mat
% struct2vars(dat);

p = publish_plot(2,1);
set(gcf,'Position',[495  484  362  575])
legends = {'original vals','re-vals'};
for i=1:2
    p.next();
    if i==2
        dv_re = values_re(:,2) - values_re(:,1);
    else
        dv_re = values(:,2) - values(:,1);
    end
    [~,~,~,mean_val] = index_prctile(dv_re + randn(size(dv_re))*0.0001,[0:5:100]);
    [X{i}] = curva_media(choices,mean_val,[],1);
    hold all
    
    %title(titles{i})
    
    
    p.next();
    curva_media(rt,mean_val,[],2);
    hold all
end

p.current_ax(1);
hl = legend(legends);
set(hl,'location','best','box','off');

p.current_ax(1);
ylabel({'Proportion','right choice'})

p.current_ax(2);
xlabel('\delta V')
ylabel('Reaction time (s)')

% same_ylim(p.h_ax([1,2]))
% same_ylim(p.h_ax([3,4]))
m = max(abs([X{1}(:);X{2}(:)]));
m = m*1.1;
set(p.h_ax,'xlim',[-m,m]);
set(p.h_ax([1]),'xticklabel','');
% set(p.h_ax([2,4]),'yticklabel','');
p.format('FontSize',14);

% export_fig('-pdf','fig_ch_rt_optim_per_suj');
