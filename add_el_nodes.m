function [link_matrix_half c_link token_matrix] = add_el_nodes(el_nodes,link_matrix_half,c_link,token_matrix,c_lrpon,small_br,wdm_order)

for i = 1:length(el_nodes)
    
    nodi_da_collegare = find(link_matrix_half(:,el_nodes(i))>0);
    
    for j = 1:length(nodi_da_collegare)
        
        link_matrix_half(el_nodes(i),nodi_da_collegare(j)) = 1;    
        c_link(el_nodes(i),nodi_da_collegare(j)) = c_lrpon;
        
        for k = 1:wdm_order
            token_matrix(el_nodes(i),nodi_da_collegare(j),k) = c_lrpon./small_br;
        end
    end    
end

end
