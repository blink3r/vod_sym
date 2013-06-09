
clc
clear all

verbose = 0;

cds = [1 3];
link_mesh = [3 4];
switch_nodes = [3];
capacity = 1;
replicability = 1;

p_b_multi_replicability_percent = zeros(length(p_b_th),1);

tic
for i = 1:length(p_b_th)      
    for j = 1:1
        seed = RandStream.create('mcg16807','Seed',100*sum(clock));
        RandStream.setDefaultStream(seed);
        disp(['% of capacity is ', num2str(j/10)]);
        p_b_multi_replicability_percent(i,j) = main_events('meshed', ...
            p_b_th(i),max_events,verbose,cds,link_mesh, ...
            replicability,capacity,switch_nodes);        
        clearvars -global
        clc
    
    end

end

