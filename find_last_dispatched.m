function[index_to_compare] = find_last_dispatched(onu_dest,completed_list)

%% Find the last completed element

%index_vector = [completed_list.onu_dest] == onu_dest;

% Find the max t_finish of completed element with the same dest id as the
% one passed to the function. Actually this function identify the last
% dispatched element of the same onu_dest

%EDITED FOR CAPACITY PACKING

t_ev = max([completed_list.t_event]);

if any(t_ev)
    index_to_compare = find(([completed_list.t_event] == t_ev));
else
    index_to_compare = [];
end

end