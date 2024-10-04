function [X,Y] = curva_suma(DEP,INDEP,filt,plotflag)

%%function [t,y,STD_ERR]=curva_suma(DEP,INDEP,filt,plotflag)
% Toma una variable dependiente (por ejemplo el tiempo de respuesta) y una
% varaible independiente (por ejemplo el SOA) y devuelve la
% suma. Toma ademas un filtro (por ejemplo si uno quiere solo para las
% correctas) y como cuarta opcion si plotear o no la curva.
% Devuelve X (todos los valores de la variable indpendiente) e Y (los
% valores suma de la variable dependiente en funcion de X).

X = unique(INDEP);

if not(max(size(INDEP))==size(DEP,1)) && max(size(INDEP))==size(DEP,2)
    DEP = DEP'; %trials en las filas
end

if nargin > 2 % A filter has been called
    if not(isempty(filt))
        DEP=DEP(filt,:);INDEP=INDEP(filt);
        X=unique(INDEP); %por si el filtro deja afuera algunos valores de X
    end
end

for i=1:length(X)
    Y(i,:)=nansum(DEP(INDEP==X(i),:),1);
end



if nargin > 3 % A reference to the plot
    if plotflag>0 && isvector(Y)
        
        plot(X,Y,'.-');
    end
end