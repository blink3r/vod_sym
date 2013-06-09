function [token_matrix] = remove_used_tokens_PON(small_br, singleflow, wdm_id, token_matrix,link_path)


token = ceil(singleflow/small_br);
test_vect = link_path(1);

while not(isempty(test_vect))
    test_1 = find(token_matrix(test_vect,:) > 0);
    test_1 = test_1(test_1 > test_vect);
    token_matrix(test_vect,find(

    
% for i = 1:length(link_path)-1
%     token_matrix(link_path(i),link_path(i+1),wdm_id) = token_matrix(link_path(i),link_path(i+1),wdm_id) - token;
% end


end
