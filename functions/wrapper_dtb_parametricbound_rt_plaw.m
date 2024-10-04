function [err,P] = wrapper_dtb_parametricbound_rt_plaw(theta,rt,coh,choice,c,pars,plot_flag)
% function [err,P] = wrapper_dtb_parametricbound_rt_2(theta,rt,coh,choice,c,pars,plot_flag)
% written by ariel zylberberg (ariel.zylberberg@gmail.com)


%%
kappa  = theta(1);
ndt_m  = theta(2);
ndt_s  = theta(3);
B0     = theta(4);
a      = theta(5);
d      = theta(6);
coh0   = theta(7);
y0a    = theta(8);
plaw   = theta(9);

%%
if ~isempty(pars) && isfield(pars,'notabs_flag')
    notabs_flag = pars.notabs_flag;
else
    notabs_flag = false;
end

%% scale coh
coh = sign(coh).*(abs(coh).^plaw);

%%
% dt = 0.002;
% t  = 0:dt:6;
% y  = linspace(-3,3,1500)';%esto puede ser problematico
% y0 = normpdf(y,y0a,.01);
% y0 = y0/sum(y0);

if ~isempty(pars) && isfield(pars,'t')
    t = pars.t;
    dt = t(2)-t(1);
else
    dt = 0.0005;
    t  = 0:dt:10;
end

%% bounds
if ~isempty(pars) && isfield(pars,'USfunc')
    USfunc = pars.USfunc;
else
    USfunc = 'Exponential';
end
[Bup,Blo] = expand_bounds(t,B0,a,d,USfunc);

%%

y  = linspace(min(Blo)-0.3,max(Bup)+0.3,512)';%esto puede ser problematico

y0 = zeros(size(y));
y0(findclose(y,0)) = 1;
y0 = y0/sum(y0);


%%
prior = Rtable(coh)/sum(Rtable(coh));

%%
drift = kappa * unique(coh + coh0);
% notabs_flag = false;

% P = feval(F,drift,t,prior,hazard,y,y0,notabs_flag);
% P = dtb_fp_cn_searchbnd2(drift,t,prior,q,y,y0,notabs_flag);
% P = dtb_fp_cn_vec(drift,t,Bup,Blo,y,y0,notabs_flag);
if ~isempty(pars) && isfield(pars,'methodforward_flag')
    methodforward_flag = pars.methodforward_flag;
else
    methodforward_flag = 1;%chang cooper
end
switch methodforward_flag
    case 1 % chang cooper
        P = dtb_fp_cc_vec(drift,t,Bup,Blo,y,y0,notabs_flag);
    case 2 % fft
        P = spectral_dtbAA(drift(:)',t,Bup,Blo,y,y0,notabs_flag);
    case 3 %cn
        P = dtb_fp_cn_vec(drift,t,Bup,Blo,y,y0,notabs_flag);
end

%% likelihood other
% ucoh = unique(coh);
% dt = t(2)-t(1);
% for i = 1:length(coh)
%     Ic = ucoh == coh(i); % index for the coherence
%     It = find(t>=rt(i), 1); % index for the time (end of viewing time or rt)
%     
%     r = normpdf(rt(i)-(1:It)*dt,ndt_m,ndt_s)*dt;
%     
%     % reaction time
%     p_up(i) = P.up.pdf_t(Ic,1:It) * r'; %#ok<AGROW>
%     p_lo(i) = P.lo.pdf_t(Ic,1:It) * r'; %#ok<AGROW>
% end
% 
% % ensure that probabilites lie between eps and 1-eps
% p_up = clip(p_up,eps,1-eps);
% p_lo = clip(p_lo,eps,1-eps);
% pPred = p_up.*choice'+ p_lo.*~choice';
% % pcorr = p_up'.*(scoh>0)+ p_lo'.*(scoh<0);
% logl = -mean(log(pPred));    
% err = logl;


%% likelihood

err = logl_choiceRT_1d(P,choice,rt,coh,ndt_m,ndt_s);

% %convolve for non-decision times
% %sanity check
% if t(1)~=0
%     error('for conv to work, t(1) has to be zero');
% end
% nt = length(t);
% dt = t(2)-t(1);
% ntr = length(coh);
% 
% ndt = normpdf(t,ndt_m,ndt_s)*dt;
% upRT = conv2(1,ndt(:),P.up.pdf_t);
% loRT = conv2(1,ndt(:),P.lo.pdf_t);
% upRT = upRT(:,1:nt);
% loRT = loRT(:,1:nt);
% 
% rt_step = ceil(rt/dt);
% ucoh = unique(coh);
% ncoh = length(ucoh);
% p_up = nan(ntr,1);
% p_lo = nan(ntr,1);
% for i=1:ncoh
%     inds = coh == ucoh(i);
%     %if RT too long, clamp to last
%     J = min(rt_step(inds),nt);
%     p_up(inds) = upRT(i,J);
%     p_lo(inds) = loRT(i,J);
% end
% 
% %correct prob by the prob. that the ndt
% %is below zero. ?
% % ptrunk = 1./(1-normcdf(0,rt-ndt_m,ndt_s));
% % p_up = p_up.*ptrunk;
% % p_lo = p_lo.*ptrunk;
% 
% %clip
% p_up(p_up<eps) = eps;
% p_lo(p_lo<eps) = eps;
% pPred = p_up.*(choice==1) + p_lo.*(choice==0);
% % logl = -sum(log(pPred));
% logl = -nanmean(log(pPred));
% 
% err = logl;
% 


%%
%% print
fprintf('err=%.3f kappa=%.2f ndt_mu=%.2f ndt_s=%.2f B0=%.2f a=%.2f d=%.2f coh0=%.2f y0=%.2f plaw=%.2f \n',...
    err,kappa,ndt_m,ndt_s,B0,a,d,coh0,y0a,plaw);

%%
if plot_flag
    m = prctile(rt,99.5);
    
    figure(1);clf
    %     subplot(2,3,1);
    %     stairs(edges,d/(edges(2)-edges(1)));
    %     hold on
    %     plot(t,q);
    %     xlim([0,m])
    
    subplot(2,3,2);
    plot(t,P.Bup,'k');
    hold all
    plot(t,P.Blo,'k');
    xlim([0,m])
    
    subplot(2,3,3);
    curva_media(choice,coh,[],1);
    hold all
    ucoh = unique(coh);
    plot(ucoh,P.up.p,'.-');
    
    subplot(2,3,4);
    aa = sum(bsxfun(@times,P.up.pdf_t + P.lo.pdf_t, prior));
    dect = rt - ndt_m;
    inds = dect>0;
    q = ksdensity(dect(inds),t,'kernel','epanechnikov','support','positive','bandwidth',.2,'support','positive');
    plot(t,aa/dt,t,q);
    %     title('inexact!!')
    xlim([0,m])
    
    subplot(2,3,5);
    rt_model = (P.up.mean_t.*P.up.p+P.lo.mean_t.*P.lo.p)./(P.up.p+P.lo.p) + ndt_m; %is not exact because it
    % doesn't take into account the curtailing of the non-decision time
    % distribution !
    curva_media(rt,coh,[],1);
    hold all
    plot(ucoh,rt_model,'.-');
    
    set(gcf,'Position',[329   900  1074   415])
    format_figure(gcf);
    
    drawnow
    
end