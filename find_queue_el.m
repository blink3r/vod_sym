function[index_to_compare] = find_queue_el(onu_dest,queue_list)
%% Find the earliest element of the queue which must be sent

index_vector = [queue_list.onu_dest] == onu_dest;

t_ev = min([queue_list(index_vector).t_event]);


if any(t_ev)
    index_to_compare = find(([queue_list.t_event] == t_ev));
else
    index_to_compare = [];
end

end