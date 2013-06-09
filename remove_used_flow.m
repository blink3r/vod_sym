function [c_link] = remove_used_flow(c_link,link_path,flow_req,lambda,tdm)


for i = 1:length(link_path)-1
    
    c_link(link_path(i),link_path(i+1),lambda,tdm) = c_link(link_path(i),link_path(i+1),lambda,tdm) - flow_req;
    
end



end

