function [test] = find_knee(serventi,carico)


for i = 0:0.1:10
    if erlangb(serventi+i/10*serventi,carico) <= erlangb(serventi,carico*3/4)*3/4
        test = i/10;
        break
    end
end




end