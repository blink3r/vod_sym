function[total_token] = get_token_path(token_matrix,link_path)

if not(link_path)
    total_token = 0;
    return
end


total_token = 0;

for i = 1:length(link_path)-1
    total_token = total_token + token_matrix(link_path(i),link_path(i+1));
end

end