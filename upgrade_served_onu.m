function [load_onu] = upgrade_served_onu(load_onu, link_path)

load_onu(link_path(length(link_path)))=0;

end

