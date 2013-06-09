%% Build link capacity

function [ token_matrix ] = build_tokens(conn, wdm_order, c_lrpon, small_br)

token_matrix = zeros(size(conn,1),size(conn,1),wdm_order);

for i = 1:wdm_order
    
    token_matrix(:,:,i) = c_lrpon./small_br.*conn;
    
end

end
