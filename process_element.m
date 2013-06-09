function[link_for_sim_new c_link token_matrix] = process_element(element,link_for_sim,~,~,c_link,use_queue,token_matrix, small_br, verbose,~)

% Processing of every element of the event_list

%% Global declaration of variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global event_list queue_list start_compute count_c;
global count_d count_e path_matrix link_for_dest;
global c_server
if verbose
    disp(['Connection ' num2str(element.id) ' is processing']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update queue time if BCD is used
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if use_queue && size(queue_list,2) > 0
%     upgrade_queue_list(element);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Processing video sending and receiving events
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch element.type
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Video visualization request
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'send_video'        
        count_e = count_e+1;
        if verbose 
            disp(['Elaborating packet ' num2str(element.id) ...
                ' using lambda ' num2str(element.g_id) ...
                ' to node ' num2str(element.onu_dest)]);       
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Policy of Link Balancing starts
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        a_s = element.content_source;
        trovati = find((link_for_dest(a_s,element.onu_dest) == 1));
        lunghezza = length(trovati);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % If at least one caching nodes can deliver the requested content.. 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(lunghezza >= 1)
            for i=1:lunghezza
                j_cost = 1;
                while(1)
                    element.src = a_s(trovati(i));
                    token_of_path(i,j_cost) = get_token_path ...
                        (token_matrix,path_matrix(element.src, ...
                        element.onu_dest,j_cost).link_path)./ ...
                        length(path_matrix(element.src, ...
                        element.onu_dest,j_cost).link_path);
                    if (token_of_path(i,j_cost) > 0) && j_cost < ...
                            size(path_matrix(:,:,:),3)
                        j_cost = j_cost + 1;
                        continue
                    else
                        break
                    end
                end
            end
            [~,idx] = max(token_of_path(:));
            [idx_2 i] = ind2sub(size(token_of_path),idx);
            element.src = a_s(trovati(idx_2));
            link_path = check_path(path_matrix(element.src, ...
                                element.onu_dest,i).link_path, ...
                                token_matrix, element.flow_req, ...
                                small_br,element.g_id);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Policy of Link Balancing ends
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Policy of Node Balancing starts
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         a_s = element.content_source;
%         c_i = 0;
%         trovati = find((link_for_dest(a_s,element.onu_dest) == 1));
%         lunghezza = length(trovati);
%         if(lunghezza>1)
%                 while(lunghezza-c_i > 0 )
%                     if(token_matrix(1,2)/token_matrix ...
%                             (a_s(trovati(lunghezza-c_i)), ...
%                             a_s(trovati(lunghezza-c_i))+1) ...
%                             >= 1 + p_average_global)
%                         element.src = 1;
%                         link_path = check_path(path_matrix ...
%                             (element.src,element.onu_dest).link_path, ...
%                             token_matrix,element.flow_req, ...
%                             small_br,element.g_id);
%                         break
%                     end
%                     element.src = a_s(trovati(lunghezza-c_i));
%                     link_path = check_path(path_matrix(element.src, ...
%                         element.onu_dest).link_path,token_matrix, ...
%                         element.flow_req,small_br,element.g_id);
%                     c_i = c_i + 1;            
%                     if any(link_path,1)
%                         break
%                     else 
%                         continue                
%                     end          
%                 end
%         else
%             element.src = a_s(trovati);
%             link_path = check_path(path_matrix(element.src, ...
%                 element.onu_dest).link_path,token_matrix, ...
%                 element.flow_req,small_br,element.g_id);
%         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Policy of Node Balancing ends
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Policy of Nearest Routing starts
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%         a_s = element.content_source;
%         c_i = 0;
%         trovati = find((link_for_dest(a_s,element.onu_dest) == 1));
%         lunghezza = length(trovati);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         % If at least one caching nodes can deliver the requested content.. 
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         if(lunghezza >= 1)
%             while( lunghezza-c_i > 0 )
%                 element.src = a_s(trovati(lunghezza-c_i));
%                 tentativi = size(path_matrix(element.src, ...
%                     element.onu_dest,:),3);
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 % If at least two paths can deliver the content ...
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 if tentativi > 1
%                     for i = 1:tentativi
%                         if path_matrix(element.src,element.onu_dest, ...
%                                 i).link_path
%                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             % Check the availability of shortest paths
%                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                             link_path = check_path(path_matrix(element.src, ...
%                                 element.onu_dest,i).link_path,token_matrix, ...
%                                 element.flow_req,small_br,element.g_id);                    
%                             if link_path
%                                 break
%                             else
%                                 continue
%                             end
%                         else
%                             break
%                         end
%                     end
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 % If only one path has been found, check it directly
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 else
%                     link_path = check_path(path_matrix(element.src, ...
%                         element.onu_dest,1).link_path,token_matrix, ...
%                         element.flow_req,small_br,element.g_id);                    
%                 end
%                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 if link_path
%                     break
%                 else
%                     c_i = c_i + 1;
%                     continue
%                 end                      
%             end
%         end
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         %% Policy of nearest routing ends caching node ends
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        %% Connection request accepted
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if(isempty(link_path)) == 0                       
            element.link_path = link_path;                                                 
            % Remove used capacity
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %c_link = remove_used_flow(c_link,element.link_path,element. ...
            %flow_req,element.g_id,element.tdm_own);            
            c_server(element.link_path(1)) = c_server(element. ... 
                link_path(1))-element.flow_req;           
            token_matrix = remove_used_tokens(small_br, ...
                element.flow_req,element.g_id, token_matrix, ...
                element.link_path);
            link_for_sim_new = link_for_sim;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Generating event 'video_recvd' event
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            generate_event(size(event_list,2)+1,1,1,1,'video_recvd', ...
                element,1,1,1,1,1,1,2,[]);      
            count_c = count_c+1;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %completed_list(count_c) = element;            
%             if verbose
%                 c_req = c_link(element.link_path(1), ...
%                       element.link_path(2),element.g_id,element.tdm_own);
%                 disp('------------------------------------------------');
%                 display(['Dispatched request ' num2str(element.id) ', ...
                        %it will finish at ' num2str(element.t_finish) ... 
%                     ' residual capacity is ' num2str(c_req)]);
%                 disp('------------------------------------------------');
%             end      
        else
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Connection request dropped 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % BCD behaviour
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if use_queue == 1                                              
                queue_list = [queue_list element];                
                link_for_sim_new = link_for_sim;
                if start_compute == 0
                    start_compute = element.id;
                end                
                if verbose
                    disp(['Connection ' num2str(element.id) ...
                        ' is entering into queue']);
                end                
            else
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % BCC behaviour
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                count_d = count_d + 1;                
                % Check first element dropped and start counting
                if start_compute == 0
                    start_compute = element.id;
                end
                if verbose
                    disp(['Dropped connection ' num2str(element.id)]);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                link_for_sim_new = link_for_sim;            
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Video visualization is ended
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'video_recvd'  
        if verbose
            disp(['Received request ' num2str(element.id) ...
                ' of lambda ' num2str(element.g_id)])
        end                
        link_for_sim_new = link_for_sim;
        %c_link = add_free_flow(c_link,element.link_path,element.flow_req,
            %element.g_id,element.tdm_own);
        c_server(element.link_path(1)) = c_server(element.link_path(1)) ...
            + element.flow_req;        
        token_matrix = add_used_tokens(small_br, element.flow_req, ...
            element.g_id, token_matrix, element.link_path);        
%         if use_queue && size(queue_list,2) >= 1%             
%             queue_list(1).t_finish = queue_list(1).t_finish + 
                %element.t_event - queue_list(1).t_event;
%             queue_list(1).t_event = element.t_event;%             
%             if verbose
%                 disp(['Try to dispatching a queue el ' num2str(queue_list(1).id)]);
%             end%             
%             event_list = [event_list queue_list(1)];
%             queue_list(1) = [];
%            
%         end
        
end
end
