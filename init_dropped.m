function[dropped_list] = init_dropped(dropped_list,max_conn)


dropped_list.id = max_conn;
dropped_list.type = 'testo';
dropped_list.size = 1.5e10;
dropped_list.t_ist = max_conn;
dropped_list.t_event = max_conn;
dropped_list.onu_dest = max_conn;
dropped_list.src = max_conn;
dropped_list.flow_req = max_conn;
dropped_list.t_finish = max_conn;
dropped_list.link_path = [1 2 3];
dropped_list.tdm_own = max_conn;
dropped_list.g_id = max_conn;
dropped_list.t_delay = max_conn;
dropped_list.color = max_conn;


dropped_list(max_conn).id = 0;






end