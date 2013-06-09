function [link_for_dest] = get_source_dest(olt,link_matrix,pos_matrix,last_branch)

% Function to obtain a matrix which gives info about which ONU can be
% reached by each source.


total_nodes = size(pos_matrix,1);

link_for_dest = zeros(olt(length(olt)),total_nodes);
link_for_dest(1,total_nodes-last_branch+1:total_nodes) = 1;

for i = 2:olt(length(olt))
    if any(find(olt == i))
        for j = total_nodes+1-last_branch:total_nodes
            if any(dijkstra_simple(total_nodes,link_matrix,i,j))
                link_for_dest(i,j) = 1;
            end
        end
    end
end





end