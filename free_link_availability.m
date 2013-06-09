function [link_for_sim] = free_link_availability (link_for_sim, link_path)

i = link_path(length(link_path)-1);
j = link_path(length(link_path));

link_for_sim(i,j) = link_for_sim(i,j) + 1;


end