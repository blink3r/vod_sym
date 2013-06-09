% Fissa i parametri di arrivo degli utenti e di servizio e calcola due serie aleatorie 
% con distribuzione esponenziale.

lambda_a=1/7; n0=100;
Ta=exprnd(1/lambda_a,n0,1);

lambda_s=1/20;
Ts=exprnd(1/lambda_s,n0,1);

% Calcola i tempi di arrivo cumulati

ta(1)=Ta(1);

for k=2:n0
ta(k)=Ta(k)+ta(k-1);
end

% Calcola i tempi di servizio cumulati

ts(1)=ta(1)+Ts(1);

for k=2:n0
ts(k)=max(ts(k-1),ta(k))+Ts(k);
end

%Calcola il numero di utenti in coda al momento dell'arrivo di ogni utente

Nc(1)=1; j=1;
for k=2:n0
while ts(j)<=ta(k)
j=j+1;
end
j=j-1;
Nc(k)=k-j;
j=1;
end


TS=ts';
TA=ta';

%Unisce i vettori contenenti i tempi di arrivo e quelli di servizio cumulati e assegna il
%valore 1 ai tempi di arrivo e -1 ai tempi di uscita dal sistema

aux_vector=[TA;TS];

ord_vector=sort(aux_vector);

for k=1:2*n0

ord_matrix(k,1)=ord_vector(k);

    for j=1:n0
    if ord_vector(k)==aux_vector(j)
    ord_matrix(k,2)=1;
    end
    end

     
    for j=n0+1:2*n0 
    if ord_vector(k)==aux_vector(j)
    ord_matrix(k,2)=-1;
    end
    end

end 

%Adesso effettua il calcolo degli utenti in coda istante per istante

for i=2:2*n0

   ord_matrix(i,2)=ord_matrix(i,2)+ord_matrix((i-1),2);

end

ord_matrix(:,1)=[];

%Comando facoltativo per plottare l'andamento della coda nel tempo

%plot(ord_vector,ord_matrix)



%Calcola il numero di utenti serviti in un certo numero di minuti. Nel caso specifico 180

ut_serv=1;
while TS(ut_serv)<180
ut_serv=ut_serv+1;
end
