function [link_for_sim] = block_link_availability (link_for_sim, link_path)
%Delete the availability of the TS just used by deleting the link
%assignement on the LAST link of the path

i = link_path(length(link_path)-1);
j = link_path(length(link_path));
link_for_sim(i,j) = link_for_sim(i,j) - 1;


end