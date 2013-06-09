function [ connection_matrix ] = conn_matrix( level )

branch=[]; %vettore che descrive per ogni livello il numero di branch
connection_matrix=[]; %matrice finale con un 1 nel caso la l'elemento della riga i abbia come figlio l'elemento della colonna j

for (i=1:level)
    branch(i) = input('Branch del livello: ');
    
end

boundary_level=[]; %matrice 2*numero_livelli indicante il primo e l'ultimo elemento del livello
node_level=[]; % numero di nodi del livello
node_level(1)=1;
sum_node_tot=1; % somma numero totale nodi nel grafo
boundary_level(1,1)=1; %definiamo il nodo radice: un solo elemento
boundary_level(2,1)=1; %è il primo e l'ultimo del suo livello

for (k=2:level+1)
    
    node_level(k) = ((node_level(k-1)) * branch(k-1));
    boundary_level(1,k)= ((boundary_level(2,k-1))+1);
    boundary_level(2,k)= ((boundary_level(1,k))+node_level(k)-1);
    sum_node_tot = sum_node_tot + node_level(k);
  
    
end


% posizione relativa nel nodo = (numero_indice - boundary_level(1,i)+1)
pos_rel=[];

connection_matrix=zeros(sum_node_tot,sum_node_tot); %inizializziamo la matrice

for (l=1:level) %per ogni livello
    for (n=boundary_level(1,l):boundary_level(2,l)) % per ogni nodo del livello
        pos_rel=(n-(boundary_level(1,l))+1);
        for (m=((boundary_level(1,l+1)+((pos_rel-1)*branch(l)))): ...
            (((boundary_level(1,l+1)+((pos_rel-1)*branch(l))))+branch(l)-1)) %per tutti i nodi del livello sottostante collegati al nodo di prima
       
            connection_matrix(n,m)=1;
        end
    end
end

