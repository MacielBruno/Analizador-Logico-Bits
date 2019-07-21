function textCell = getTextCell(X,stringArrayInput, whereNameStarts)
% Função que serve para mapear a minha matriz contendo os bits, 
% X, visando encontrar os bits que representam cada tipo de 
% informação no meu pacote.

stringArrayNewSize = sum(whereNameStarts);
stringArray = java_array('java.lang.String',stringArrayNewSize);
index = 1;
for i = 1:size(whereNameStarts,2)
    for j = 1:whereNameStarts(i)
        stringArray(index) = java.lang.String(stringArrayInput(i));
        index = index + 1;
    end
end

D = cell(stringArray);
stringIndex = 1;
textCell = java_array('java.lang.String', size(X,2));
for i = 1:size(X,2)
    textCell(i) = java.lang.String(D(stringIndex));
    stringIndex = stringIndex + 1;
    if stringIndex > size(D,1)
        stringIndex = 1;
    end
end
end