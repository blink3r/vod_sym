function [posMatrix, conn_sim, conn_sim_half, last_branch, total_nodes, last_grade] = build_topology( deep, xArea, yArea )

%% Build Tree Topology alpha version
global branch 

%% Init Vars
yVal = yArea;

posMatrix(1,1) = xArea/2;
posMatrix(1,2) = yVal;

branch = zeros(deep + 1);
branch(1) = 1;

count = 2;
end_of_tree = 1;


%% Let users choose degree of each node for each stage

% while count <= deep + 1
%     branch(count) = input('Select branch ');
%     count = count + 1;
% end
last_grade = branch(2);

branch = [1 1 4 4 4];
%% Building position algorithm

for d = 1:deep
    
    yVal = yVal - d*10;    
    cc = 2;
    end_of_tree = end_of_tree*branch(d + 1);
    
    for i = size(posMatrix,1)+1:size(posMatrix,1)+end_of_tree
        posMatrix(i,1) = ((xArea)/(end_of_tree))*(cc-1)-xArea/((end_of_tree)*2);
        posMatrix(i,2) = yVal;
        cc = cc + 1;
    end

end

total_nodes = size(posMatrix,1);

%% Reset of useful variables

yVal = yArea;
end_of_tree = 1;

%% Building connection matrix v1 (with geometric searching)

conn_matr = zeros(1,size(posMatrix,1));
end_of_iter = 0;
feed = 0;
 
%Forse è meglio partire da 2?
for d = 1:deep
    
    %% Many things that can be shortened
    if(d == 2)
        end_of_iter = 1;
        feed = 1;
    end
    
    if( d > 1)
        yVal1 = yVal1 - (d - 1) * 10;
    else 
        yVal1 = yArea;
    end    
        
    if(d == 1)
        yVal = yArea - d * 10 - (d + 1) * 10;
    else
        yVal = yVal - (d + 1)* 10;
    end
    
    cc = 1;   
    
    end_of_tree = end_of_tree * branch(d + 1);
    tmpLen = size(conn_matr, 1);
    
    end_of_iter = end_of_iter * branch(d);
    
    %% Main building
    
    for i = (tmpLen + feed):(tmpLen  + end_of_iter)
        neighbourList = ((posMatrix(:,1) >= xArea/end_of_tree*cc -xArea/(end_of_tree*2)) & (posMatrix(:,1) <= (xArea/end_of_tree*cc + xArea/end_of_tree*(branch(d+1)-1) - xArea/(end_of_tree*2))) & ((posMatrix(:,2) < yVal1) & (posMatrix(:,2) > yVal)));
        conn_matr(i,neighbourList) = 1;
        cc = cc + branch(d+1);        
    end
        
end


%% Building connection matrix v2 

%% Connecting just root 
conn(1,1) = 0;
for j = 2:2+branch(2)-1
    conn(1,j) = 1;
end

c = 2;
group = 0;

n = size(posMatrix,1);


%% Connecting other nodes
for d = 1:deep-1
    feed = feed*branch(d+1);
    for i = c: c + feed-1        
        for j = i+feed+group:i+feed+group+branch(d+2)-1            
            conn(i,j) = 1;
        end        
    group = group + branch(d+2)-1;    
    end
    c = c + feed;
    group = 0;
end

last_branch = feed * branch(d+2);

% It may be useful to not do such lines editing dijkstra
conn_sim_half = zeros(n,n);
conn_sim_half(1:size(conn,1),1:size(conn,2)) = conn;

conn_sim = zeros(n,n);
conn_sim(1:size(conn,1),1:size(conn,2)) = conn;
conn_sim(1:size(conn',1),1:size(conn',2)) = conn_sim(1:size(conn',1),1:size(conn',2)) + conn';


end

