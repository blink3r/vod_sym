function [source] = get_source(sources, onu_dest, link_matrix,want_link)

src_temp = 1;
c = 0;
dst = onu_dest;

while src_temp ~= 0
    c = c+1;
    for i = 1:length(onu_dest)
        
        src_temp = find((link_matrix(onu_dest(i),:) == 1));
        index_temp = src_temp < onu_dest(i);
        
        if any(index_temp)
            src_temp = src_temp(index_temp);
            onu_dest = src_temp(length(src_temp));
        else
            src_temp = 0;
        end
        
        if any(src_temp) 
            source_found(c) = src_temp(length(src_temp)); 
        end
                
    end
    
    if want_link
        if src_temp(length(src_temp)) == sources
            break
        end
    end
    
    
end

d = 0;

if not(want_link)
    for c = 1:length(sources)    
        index_good = find(source_found == sources(c));
    
        if any(index_good)
            d = d+1;
            source_ok(d)  = source_found(index_good);
        else
            1;
        end
    
    end
    source = source_ok;
end




if want_link
    source_found = [source_found dst];
    source_found = sort(source_found);
    source = source_found;
end