function[tot_access_day rho carico] = generate_diurnal_access(duration_pdf, capacity_onu,bit_rate, p_b_th)

% This creates the right lambda depending on the time of the day

global content_list;

%affidability = 1000;

%% Decomment from HERE
% X = 50:10e3;
% 
% duration = zeros(affidability,length(X));
% duration_mean_t = zeros(1,affidability);
% 
% for i = 1:affidability;
%     duration(i,:) = randsample(X,length(X),true,duration_pdf);
%     duration_mean_t(i) = mean(duration(i,:));
% end
% TO HERE FOR IDEAL CASE



%duration_mean = mean(duration_mean_t);
%duration_br = mean(bit_rate);

%tot_access_day = ceil(((capacity_onu)./(duration_br.*duration_mean))*3600*24);

%offered = findrhob(400,p_b_th);
% 
% carico = offered/400
% 

duration_mean = 2200;

%duration_mean = mean([content_list.duration]);

%tot_access_day = offered/duration_mean;

tot_access_day = p_b_th/duration_mean;

rho = tot_access_day.*duration_mean;

carico = tot_access_day*duration_mean/400;

end
