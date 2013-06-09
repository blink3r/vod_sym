function [token_matrix] = remove_used_tokens(small_br, singleflow, wdm_id, token_matrix,link_path)


token = ceil(singleflow/small_br);

for i = 1:length(link_path)-1
    token_matrix(link_path(i),link_path(i+1),wdm_id) = token_matrix(link_path(i),link_path(i+1),wdm_id) - token;
end


end
