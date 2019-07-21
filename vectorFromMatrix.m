function vector = vectorFromMatrix(matrix)
matrix = matrix';
oneColumnMatrix = matrix(:);
pastValue = oneColumnMatrix(1);
index = 1;
vector(1) = 1;
for element = 2:size(oneColumnMatrix)
    if pastValue == oneColumnMatrix(element)
        vector(index) = vector(index) + 1;
    else
        index = index + 1;
        vector(index) = 1;
    end 
    pastValue = oneColumnMatrix(element);
end
end