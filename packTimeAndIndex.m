function [time,index] = packTimeAndIndex(everyTime, everyIndex, nBits)
time = zeros(1,size(everyIndex,2)/nBits);
index = zeros(1,size(everyIndex,2)/nBits);
j = 1;
for i = 1:size(everyIndex,2)/nBits
    time(i) = everyTime(everyIndex(j));
    index(i) = everyIndex(j);
    j = j + nBits;
end
end