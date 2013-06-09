%% CDM Simulator - WDM/TDM Version w/ Capacity Packing Modelling
% Each calls require capacity for some time.


function [result] = main_events(type, p_b_th, max_events, verbose, olt_choosen, link_mesh, p_replication, p_capacity,el_nodes)

%% Init event strucutre and link matrix
global t_start event_list completed_list time time_v start_compute count_c count_d count_e content_list event_selection;
global link_for_dest path_matrix TEST c_server p_capacity_global

p_capacity_global = p_capacity;

%% Just to see the right time of the day
refTime = [2013,02,13,00,00,00];
refNum = datenum(refTime);

%% To create the right distribution of access
duration_pdf = build_duration_pdf;
%diurnal_access_p = [0.041,0.03,0.021,0.020,0.02,0.022,0.029,0.035,0.037,0.036,0.035,0.036,0.040,0.049,0.053,0.055,0.06,0.058,0.057,0.06,0.057,0.057,0.05,0.042];

%% Size of each run
chunk_size = 10000;

%% Init useful variables
deep = 4;       %No of levels in the TREE
wdm_order = 1;  %No of wdm lambda to use


%% Building desired LR-PON topology
[pos_matrix link_matrix link_matrix_half last_branch total_nodes] = build_topology(deep,800,400);

%Number of completed events
count_c = 0;

%% Init architecture capacity
t_start = 0;
c_lrpon = 1e9;
c_server(2:olt_choosen(length(olt_choosen))) = c_lrpon*p_capacity;
c_server(1) = c_lrpon;
start_compute = 0;
completed_list = [];

%% Bit rate, capacity and BBU link assignment
%bit_rate = [500, 1500, 2500].*10^3; %This is the right one
bit_rate = 2500.*10^3;
small_br = min(bit_rate);
%TEST = zeros(3,1);
tdm_order = last_branch./wdm_order; %Number of TDM that are needed to serve all ONUs
c_link = build_metrics(link_matrix, wdm_order, tdm_order); %Capacity assignement, we have to assign it dynamically
token_matrix = build_tokens(link_matrix, wdm_order,  c_lrpon, small_br); %Token (BBU) matrix for each link

%% Init other variables
switch type    
    case 'blocco'
        olt = 1;
        use_queue = 0;
        count_e = 0;    
    case 'blocco_m'
        olt = olt_choosen;    %CDN content servers
        use_queue = 0;  %NO use of queue
        count_e = 0;    %No of parsed events
    case 'lossless'
        olt = 1;
        use_queue = 1;
        count_c = 0;
        %queue_list = init_queue(queue_list,max_conn);
    case 'lossless_m'
        olt = olt_choosen;
        use_queue = 1;
        %queue_list = init_queue(queue_list,max_conn);    
    case 'meshed'
        use_queue = 0;
        olt = olt_choosen;
        count_e = 0;
		
        if any(link_mesh)
            [link_matrix_half c_link token_matrix] = add_meshed_link(link_mesh,link_matrix_half,c_link,token_matrix,c_lrpon,small_br,wdm_order); 
        end
        
        if any(el_nodes)
            [link_matrix_half c_link token_matrix] = add_el_nodes(el_nodes,link_matrix_half,c_link,token_matrix,c_lrpon,small_br,wdm_order);
        end
        
end

%% Building Contents
n_content = 10000;
content_list = build_content(n_content,olt,duration_pdf,bit_rate,p_replication);

%% Generate diurnal access, giving the right lambda for each hour
[diurnal_access , ~, carico] = generate_diurnal_access(duration_pdf,1e9,bit_rate,p_b_th);
disp(['Using lambda = ' num2str(diurnal_access) ' load = ' num2str(carico)]);

%% Init other useful variables
number = 1;
day = 200*86400;
max_conn = ceil(day*diurnal_access)+number;
link_for_sim = link_matrix_half; % This matrix indicates link connection
sim_rep = 0;
time = 0.0001;

%% Initi path matrix and all possible reachable destination from sources
path_matrix = get_path_matrix(olt,link_matrix_half,pos_matrix,last_branch,type);
link_for_dest = get_source_dest(olt,link_matrix_half,pos_matrix,last_branch);

%% Setup of simulation
i_from = 1;
seed = 0;
HUGE_VAL = 10e6;
time_v = zeros(1,HUGE_VAL);
n_event_driven = 0;
count_d = 0;
pdf_pop = [content_list.popularity];
X_i = 1:n_content;
%completed_list = init_completed(completed_list,max_conn);
%event_selection = randsample(X_i,max_conn,true,pdf_pop); % Extract all "content decision" for all events (POPULARITY)
event_selection = randi(n_content,1,max_conn);

%% First Generation
generate_new_events(i_from,number,time,total_nodes,last_branch,wdm_order,tdm_order,bit_rate,diurnal_access,link_matrix,seed,token_matrix,type);
sim_rep = sim_rep + number;
i_from = i_from + number;
conto_chunk = 0;

%% For confidentiality
index_med = 0;
ub = 0;
lb = 0;
media_finally = 0;
alpha = 0.05;
indice = 0;
test = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Starting RUNs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(size(event_list,2)>=0)   
    n_event_driven = n_event_driven + 1;    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Check if exit rules are satisfied
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1) Interval of confidence has been reached
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (index_med > 15 && test == 1)
        if ((ub(index_med)-lb(index_med))/media_totale(index_med) <= 0.05)
            break
        end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 2) RVM is under a certain threshold
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if sqrt(var(media_totale))/media_totale(index_med) <= 0.2
            break
        end
        test = 0;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 3) Max number of events has been reached
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if index_med > max_events
        break
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %% Select upcoming event
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [~, index_to_process] = min([event_list.t_event]);    
    event_to_process = event_list(index_to_process);           
    time = event_to_process.t_event;
    time_str = refNum + time/86400;
    time_v(n_event_driven) = time;    
    if verbose
        disp(' ');
        disp(['Time is ' datestr(time_str,'dd-mm-yyyy HH:MM:SS')]);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Process the selected event
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    [link_for_sim c_link token_matrix] = process_element(event_to_process, ...
        link_for_sim,pos_matrix,olt,c_link,use_queue,token_matrix, ...
        small_br, verbose, type);
    event_list(:,index_to_process) = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Refill event_list
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    seed = size(event_list,2);   
    if (event_to_process.color == 1)
        generate_new_events(i_from,number,time,total_nodes,last_branch, ...
            wdm_order,tdm_order,bit_rate,diurnal_access,link_matrix, ...
            seed,token_matrix,type);
        sim_rep = sim_rep + number;
        i_from = i_from + number;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Process the overall RUN
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if count_e - conto_chunk == chunk_size
        toc;
        tic;        
        index_med = index_med + 1;       
        switch type
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % BCC behaviour
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'meshed'                
                dropped = count_d - indice;
                if dropped > 0
                    indice = indice + dropped;
                end                
                perc = dropped/(chunk_size);
                media_finally(index_med) = perc;
                sigma_finally(index_med) = var(media_finally);       
                media_totale(index_med) = mean(media_finally);                
                nn = 1*(1:index_med);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % BCD behaviour
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 'lossless'                
                temp_med = completed_list(conto_chunk+1:conto_chunk+1 ...
                    +chunk_size);                
                vettore_da_mediare = [temp_med.t_finish] - ...
                    [temp_med.t_event] + [temp_med.t_delay];
                media_finally(index_med) = mean(vettore_da_mediare);
                sigma_finally(index_med) = var(media_finally);       
                media_totale(index_med) = mean(media_finally);
                nn = 1*(1:index_med);
           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Interval of confidence calculation
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        conto_chunk = count_e;       
        if index_med > 1
            ub = media_totale(index_med) + sqrt(var(media_finally))* ...
                tinv(1-alpha/2,index_med-1)./sqrt(nn);
            lb = media_totale(index_med) - sqrt(var(media_finally))* ...
                tinv(1-alpha/2,index_med-1)./sqrt(nn);
            test = 1;
            %plot(si,media_totale,'k-',si,ub,'k:',si,lb,'k:');
        end       
    end   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Just some testing script
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% time_v = time_v(time_v > 0);
% completed_list = completed_list([completed_list.color] < 2000); 
% Final check
% for i = 1:length(time_v)-1
%     if time_v(i) > time_v(i+1);
%         disp(['ERRORE: ' num2str(time_v(i))])
%         pause;
%     end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Final metrics display
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch type
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BCD behaviour
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'lossless'
        media = mean([completed_list(chunk_size:size(completed_list,2)).t_delay]);
        disp(['Tempo medio in coda: ' num2str(media)]);
        result = media;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % BCH behaviour
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'meshed'
        perc = count_d/(sim_rep-start_compute);
        disp(['Dropped packet: ' num2str(dropped)]);
        disp(['Percentage dropped: ' num2str(perc) '%']);
        result = perc;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%plot_topology(pos_matrix,link_matrix); 
end



