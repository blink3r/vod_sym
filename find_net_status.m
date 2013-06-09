function[index_to_compare] = find_net_status(onu_dest,completed_list)

index_vector = [completed_list.onu_dest] == onu_dest;

t_fin = max([completed_list(index_vector).t_finish]);

if any(t_fin)
    index_to_compare = find(([completed_list.t_finish] == t_fin));
else
    index_to_compare = [];
end

end