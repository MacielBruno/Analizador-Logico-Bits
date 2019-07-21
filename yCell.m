function y = yCell(length)
y = zeros(length,1);
for i = 1:length
    y(i) = i*0.025;
end
end