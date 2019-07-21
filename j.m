function err = j(H)
for i = 2:size(H,1)
    if H(i-1) > H(i)
        err = 1;
    end
end