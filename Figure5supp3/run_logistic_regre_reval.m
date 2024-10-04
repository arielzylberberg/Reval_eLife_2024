

%%

dat = load('../data/prepro_data.mat');
if isfield(dat,'dat')
    dat = dat.dat;
end

ntr = length(dat.choices);

chosen_item = dat.choices.*dat.trials(:,2)+(1-dat.choices).*dat.trials(:,1);
nonchosen_item = dat.choices.*dat.trials(:,1)+(1-dat.choices).*dat.trials(:,2);
uni_group = unique(dat.group);

num_chosen_before = zeros(ntr,2);
num_notchosen_before = zeros(ntr,2);
for i=1:length(uni_group)
    I = find(dat.group==uni_group(i));
    for j=2:length(I)
        for k=1:2
            num_chosen_before(I(j),k) = sum(chosen_item(I(1):(I(j)-1))==dat.trials(I(j),k));
            num_notchosen_before(I(j),k) = sum(nonchosen_item(I(1):(I(j)-1))==dat.trials(I(j),k));
        end
        
    end
end
% W = [-1,1,1,-1];
% v_ch_nch = [num_chosen_before(I,:),num_notchosen_before(I,:)]*W(:);

%%

I = true(size(dat.group)); % should cycle

nitems = size(dat.v,1);
ntr = sum(I);
M = zeros(ntr,nitems); % identifies items left and right

J = sub2ind([ntr,nitems],[1:ntr]',dat.trials(I,1));
M(J) = -1; %left item
J = sub2ind([ntr,nitems],[1:ntr]',dat.trials(I,2));
M(J) = 1; %right item


rt = dat.rt(I);

dep = dat.choices(I);
dv = diff(dat.values,[],2);



        W = [-1,1,1,-1];
        v_ch_nch = [num_chosen_before(I,:),num_notchosen_before(I,:)]*W(:);
        indep = {'dv_group',bsxfun(@times,adummyvar(dat.group(I)),dv(I)),...
                'group',adummyvar(dat.group(I)),...
                'num_chosen_unchosen_group',bsxfun(@times,adummyvar(dat.group(I)),v_ch_nch)};



[beta,idx,stats,x,LRT] = f_regression(dep,[],indep);

yhat = glmval(beta,x,'logit','constant','off');

%%

% if regre_data == 4
%     reval_from_regression = beta(idx.num_chosen_unchosen_group)./beta(idx.dv_group);
    reval = load('../reval_calc/output_data/delta_vals_optim_per_suj.mat');

    p = publish_plot(1,1);
    set(gcf,'Position',[547  479  442  362]);
    delta_from_regre = beta(idx.num_chosen_unchosen_group)./beta(idx.dv_group);
    delta = reval.delta_v_opt;
    plot(delta,delta_from_regre,'color','k','marker','o','markerfacecolor',0.7*[1,1,1],'LineStyle','none');
    axis square
    same_xylim(p.h_ax);
%     xlim([0.05,0.45]);
%     ylim([0.05,0.45]);
    h = refline(1,0);
    set(h,'color',0.5*[1,1,1],'LineStyle','--');
    
    xlabel('\delta from Reval [$]');
    ylabel('\delta from Logistic regression [$]');
    set(p.h_ax,'xtick',0:0.1:1,'ytick',0:0.1:1);
    p.format('FontSize',17,'MarkerSize',8);
    p.append_to_pdf('fig_delta_reval_vs_regression',1);

%     plot(beta(idx.num_chosen_unchosen_group)./beta(idx.dv_group),'.-')
%     hold all
%     plot(reval.delta_v_opt)

    
% end



