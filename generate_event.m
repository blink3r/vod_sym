function[] = generate_event(i,id,total_nodes,last_branch,type,element,wdm_order,tdm_order,bit_rate,diurnal_access,link_matrix,time,color,token_matrix,tipo_sym)

%Function that generates one event using parameter passed to it

global event_list content_list event_selection link_for_dest;
%X = 50:10e3;

if(size(element,2) <=0)
    %% Getting right time of the day and obtain relative probability
%     if i == 1
%         t_ref = 0.001;
%     else
%         t_ref = sum([event_list(1:i-1).t_ist]);
%     end
    
    %i_to_ref = ceil(t_ref/3600);
    %my_hour_access = ceil(diurnal_access.*diurnal_access_p(i_to_ref));
    %l_event = my_hour_access/3600;  
    
    seed = total_nodes-last_branch;
    r_num = randi(last_branch);
    onu_dest = seed + r_num;
    
    %% EDIT SOURCE OF CONTENT
    
    % SELECT A CONTENT
    content_selected = event_selection(id);    
    a_s = content_list(content_selected).source;
    bit_rate_req = content_list(content_selected).bit_rate;       
    sorgente = a_s(find((link_for_dest(a_s,onu_dest) == 1),1,'last'));
    
    
%     if strcmp(tipo_sym , 'meshed')
%         c_i = 0;
%         trovati = length(find((link_for_dest(a_s,onu_dest) == 1)));        
%         while(trovati-c_i > 0 )            
%             sorgente = a_s(trovati-c_i);
%             link_path = check_path(path_matrix(sorgente,onu_dest).link_path,token_matrix,bit_rate_req,min(bit_rate),ceil(r_num/(last_branch/wdm_order)));
%             c_i = c_i + 1;            
%             if any(link_path)
%                 break
%             else 
%                 continue                
%             end          
%         end  
%     end
    
    
    %% REST OF REQUEST    
    event_list(i).onu_dest = onu_dest;                 
    l_event = diurnal_access; %Imposed by ME
    %duration = content_list(content_selected).duration;
    duration = -log(rand)*2200;                                             % Duration of each request (IDEAL!)    
    interarrivo = -log(rand)/l_event;
    %TEST(onu_dest) = TEST(onu_dest) + 1;
    tdm_own = mod(r_num,tdm_order);    
    if tdm_own == 0
        tdm_own = tdm_order;
    end
    
    event_list(i).color = color;                                            % Utility
    %i_to_start = find([event_list.color]==1,1,'first');  
    
    event_list(i).id = id;
    event_list(i).type = type;                                              % Type of event
    event_list(i).size = bit_rate_req.*duration;
    event_list(i).t_ist = interarrivo;                              % Interarrival time
    event_list(i).t_event = time + interarrivo;%sum([event_list(i_to_start:i).t_ist]);   % Time of start
    event_list(i).src = sorgente;
    event_list(i).flow_req = bit_rate_req;                                  % Quality
    event_list(i).t_finish = time + interarrivo + duration;              
    event_list(i).link_path = [];
    event_list(i).tdm_own = tdm_own;
    event_list(i).g_id = ceil(r_num/(last_branch/wdm_order));
    event_list(i).t_delay = 0;
    event_list(i).content_source = content_list(content_selected).source;
    
    
end

if(size(element,1)>=1)
    
    event_list(i).id = element.id;
    event_list(i).type = type;
    event_list(i).size = element.size;
    event_list(i).t_ist = element.t_ist;
    event_list(i).t_event = element.t_finish;
    event_list(i).onu_dest = element.onu_dest;
    event_list(i).src = element.src;
    event_list(i).flow_req = element.flow_req;
    event_list(i).t_finish = 0;
    event_list(i).link_path = element.link_path;
    event_list(i).tdm_own = element.tdm_own;
    event_list(i).g_id = element.g_id;
    event_list(i).t_delay = element.t_delay;    
    event_list(i).color = color;
    event_list(i).content_source = element.content_source;
    
end