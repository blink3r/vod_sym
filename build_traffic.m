function [load_onu] = build_traffic(nodes, branch) 

total_nodes = nodes;
last_branch = branch;
mean_req = 180;
bit_rate_req = 1.5e6;

for i = total_nodes:-1:last_branch
    
    load_onu(i) = bit_rate_req*poissrnd(mean_req);    
    
end


end