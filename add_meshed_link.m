function [link_matrix_half c_link token_matrix] = add_meshed_link(link_list,link_matrix_half,c_link,token_matrix,c_lrpon,small_br,wdm_order)

for i = 1:2:length(link_list)-1
    
    link_matrix_half(link_list(i),link_list(i+1)) = 1;
    c_link(link_list(i),link_list(i+1)) = c_lrpon;
    
    for j = 1:wdm_order
        token_matrix(link_list(i),link_list(i+1),j) = c_lrpon./small_br;
    end

end


end
