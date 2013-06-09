function [link_for_sim_new] = subtract_lambda(link_for_sim,i,j)

link_for_sim_new = zeros(length(link_for_sim));

for c = 1:length(i)
    
    link_for_sim_new(i(c),j(c)) = link_for_sim(i(c),j(c)) - 1;
end


end
