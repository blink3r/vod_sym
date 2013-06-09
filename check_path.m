function[link_path_r] = check_path(link_path,token_matrix,single_flow,small_br,wdm_order)

global c_server

token = ceil(single_flow/small_br);
c_server_1 = c_server(link_path(1));


% if (not(any(token_matrix(link_path,link_path) - token > 0)) | (c_server_1 - single_flow) < 0)
%     link_path_r = [];
%     return
% end


for i = 1:length(link_path)-1
    
   if (((token_matrix(link_path(i),link_path(i+1),wdm_order) - token) < 0) || (c_server_1 - single_flow) < 0)
        link_path_r = [];
        return
        
    end
end

link_path_r = link_path;
end
