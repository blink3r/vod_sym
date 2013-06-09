function[path_matrix] = get_path_matrix(olt,link_matrix,pos_matrix,last_branch,type)

% This function computes all possible path from source to destination and
% store it in a matrix structure ordering paths by score.
% ES: path_matrix(i,j,1) = shortest path
%     path_matrix(i,j,2) = less short path

total_nodes = size(pos_matrix,1);

if (strcmp(type,'blocco') || strcmp(type,'blocco_m'))    
    
    disp('Computing paths....');

    for i = 1:olt(length(olt))
        for j = total_nodes-last_branch+1:total_nodes
            path_matrix(i,j).link_path = dijkstra_simple(total_nodes,link_matrix,i,j);
        end
    end
    
    disp('Done.');
end

if (strcmp(type,'meshed'))
    
    disp('Computing paths on merged network....');    
   
    for i = 1:olt(length(olt))
        for j = total_nodes-last_branch+1:total_nodes
            temp_paths_cells = kShortestPath(total_nodes,link_matrix,i,j,10);
            for c = 1:length(temp_paths_cells)
                if temp_paths_cells{c}
                    path_matrix(i,j,c).link_path = temp_paths_cells{c};
                end
            end
        end        
    end  
    
    disp('Done.');   
    
    
end


end