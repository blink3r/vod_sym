%% Upgrade delay to all elements in queue
function[] = upgrade_queue_list(element)

global queue_list time_v;

%Perchè usavo questo prima???
%index_to_queue = find_queue_el(element.g_id,queue_list);

time_temp = time_v(time_v > 0);
%For each element  upgrade its start time and its
%delay on queue


for i = 1:length(queue_list)
    queue_list(i).t_delay = queue_list(i).t_delay + (time_temp(length(time_temp)) - time_temp(length(time_temp)-1));    
end



end

