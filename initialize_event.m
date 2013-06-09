function [event_list] = initialize_event(event_list,sim_rep) 


event_list.id = sim_rep;
event_list.type = 'testo';
event_list.size = 1.5e10;
event_list.t_ist = sim_rep;
event_list.t_event = sim_rep;
event_list.onu_dest = sim_rep;
event_list.src = sim_rep;
event_list.flow_req = sim_rep;
event_list.t_finish = sim_rep;
event_list.link_path = [1 2 3];
event_list.tdm_own = sim_rep;
event_list.g_id = sim_rep;
event_list.t_delay = sim_rep;
event_list.color = sim_rep;


event_list(sim_rep).id = 0;

end

