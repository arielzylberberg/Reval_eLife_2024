function [choice,dec_sample] = boundcross(ev,Bup,Blo)

%sanity check
if size(ev,2)~=length(Bup)
    error('wrong sizes');
end

% get the c code, for now a hack

[~,s_up] = single_timebarrier_cross_rectified(ev',Bup,-10000);
[~,s_lo] = single_timebarrier_cross_rectified(-ev',-1*Blo,-10000);
% cev = cumsum(ev,2);
% ntr = size(cev,1);
% s_up = nan(ntr,1);
% s_lo = nan(ntr,1);
% for i=1:ntr
%     aa = find(cev(i,:)>Bup,1,'first');
%     if ~isempty(aa)
%         s_up(i) = aa;
%     end
%     aa = find(cev(i,:)<Blo,1,'first');
%     if ~isempty(aa)
%         s_lo(i) = aa;
%     end
% end


choice     = nan(size(ev,1),1);
dec_sample = nan(size(ev,1),1);

I = s_up<s_lo | (~isnan(s_up) & isnan(s_lo));
choice(I)  = 1;
dec_sample(I) = s_up(I);

I = s_lo<s_up | (~isnan(s_lo) & isnan(s_up));
choice(I)  = 0;
dec_sample(I) = s_lo(I);

% [ntr,ntimes] = size(dv);
% for i=1:ntr
%     iup = find(dv(i,:)>Bup,[],2,'first');
%     ilo = find(dv(i,:)<Blo,[],2,'first');
%     if isempty(iup) && isempty(ilo)
%     else

