function[] = generate_new_events(i_from,number,time,total_nodes,last_branch,wdm_order,tdm_order,bit_rate,diurnal_access,link_matrix,seed,token_matrix,tipo_sym)

global event_list
id = i_from;

if seed > 0
    event_list(seed+number).id = 0;
else
    event_list = initialize_event(event_list,number);
end

index = seed + 1;    
generate_event(index,id,total_nodes,last_branch,'send_video',[],wdm_order,tdm_order,bit_rate,diurnal_access,link_matrix,time,1,token_matrix,tipo_sym);


end