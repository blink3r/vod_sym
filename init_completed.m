function[completed_list] = init_completed(completed_list,max_conn)


completed_list.id = max_conn;
completed_list.type = 'testo';
completed_list.size = 1.5e10;
completed_list.t_ist = max_conn;
completed_list.t_event = max_conn;
completed_list.onu_dest = max_conn;
completed_list.src = max_conn;
completed_list.flow_req = max_conn;
completed_list.t_finish = max_conn;
completed_list.link_path = [1 2 3];
completed_list.tdm_own = max_conn;
completed_list.g_id = max_conn;
completed_list.t_delay = max_conn;
completed_list.color = max_conn;


completed_list(max_conn).id = 0;






end