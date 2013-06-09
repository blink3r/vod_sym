function [path, totalCost] = dijkstra_simple(n, netCostMatrix, s, d)
% path: the list of nodes in the path from source to destination;
% totalCost: the total cost of the path; equals to inf if there is no path
% farthestNode: the farthest node to reach for each node after performing
% the routing;
% n: the number of nodes in the network;
% netCostMatrix: connectivity matrix
% s: source node index;
% d: destination node index;

    
%Cost Matrix Normalization

for i=1:n
    for j=1:n
        if netCostMatrix(i,j) == 0
            netCostMatrix(i,j) = inf;
        end
    end
end
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all the nodes are un-visited;
visited(1:n) = 0;

distance(1:n) = inf;    % it stores the shortest distance between each node and the source node;
parent(1:n) = 0;
totalCost = 0;
distance(s) = 0;
for i = 1:(n-1),
    temp = [];
    for h = 1:n,
         if visited(h) == 0   % in the tree;
             temp=[temp distance(h)];
         else
             temp=[temp inf];
         end
     end;
     [t, u] = min(temp);    % it starts from node with the shortest distance to the source;
     visited(u) = 1;       % mark it as visited;
     for v = 1:n,           % for each neighbors of node u;
         %if ( ( netCostMatrix(u, v) + distance(u)) < distance(v) && (c_link(u,v,wdm_order,tdm_order) - single_flow >0))
         if ( ( netCostMatrix(u, v) + distance(u)) < distance(v))
             distance(v) = distance(u) + netCostMatrix(u, v);   % update the shortest distance when a shorter path is found;
             parent(v) = u;                                     % update its parent;
         end;             
     end;
end;

path = [];
if parent(d) ~= 0   % if there is a path!
    t = d;
    path = [d];
    while t ~= s
        p = parent(t);
        path = [p path];
        t = p;      
    end;
end;

totalCost = distance(d);

return;