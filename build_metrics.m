%% Build link capacity

function [ c_link ] = build_metrics(conn, wdm_order,tdm_order)

c_link = zeros(size(conn,1),size(conn,1),wdm_order,tdm_order);

for i = 1: wdm_order
    for j = 1:tdm_order
        c_link(:,:,i,j) = 1e9./tdm_order.*conn;
    end
end


% if (strcmp(type,'blocco_m')) || (strcmp(type,'lossless_m'))
%     
%     for i = 1:wdm_order
%         for j = 1:tdm_order
%             for c = 1:length(sources)
%                 c_link(sources(c),sources(c):length(c_link),i,j) = 1e9./2.*conn(sources(c),sources(c):length(c_link));
%             end        
%         end
%     end
% end


end
