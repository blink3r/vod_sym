function [content_list] = build_content(n_content, sources, duration_pdf, bit_rate,p_replication)

% Function that generates content and asssign content to its source.
% Usage:
%       n_content: number of contents you want to be generated
%       sources: possible source of contents
%       duration_pdf: distribution of duration times
%       bit_rate: possible bit rate in b/s (uneusefull?)


disp('Generating content and popularity...');

X = 50:10e3;
C = 0;
k = 11;
alpha = 1.5;

for i = 1:n_content;
    C = C + 1/(i + k)^alpha;
end
C = 1/C;

duration_vector = randsample(X,n_content,true,duration_pdf);

c = 0;
for i = 1:n_content   
    
    % CONTENT DISTRIBUTION
    %This generates possible source of a content.
    % i.e OLT = [1 3]: 
    %                   sorgente may be: [1], [3], [1 3]
    %s.s_temp = combnk(sources,randi(length(sources)));
    %sorgente = s.s_temp(randi(size(s.s_temp,1)),:);

    
%   % CONTENT REPLICATION !!   
     if (rand <= p_replication)       
         sorgente = sources;
         c = c + 1;
     else
         sorgente = 1;
     end
     
    
    % CONTENT REPLICATION!!!
    %sorgente = sources;
    
    content_list(i).id = i;                                         % ID
    content_list(i).duration = duration_vector(i);                  % Duration of the video (unused)
    content_list(i).source = sorgente;                              % Source
    content_list(i).bit_rate = bit_rate(randi(length(bit_rate)));   % Bit-rate (unused)     
    content_list(i).popularity = C/(i + k)^alpha;                   % Popolarity
    
end

disp('Done.');


end