function textCell = getTextCell(X,stringArray)
% Função que serve para mapear a minha matriz contendo os bits, 
% X, visando encontrar os bits que representam cada tipo de 
% informação no meu pacote.


D = cell(stringArray);
stringIndex = 1;
%textVector = NaN(size(X),1);
textCell = java_array('java.lang.String', size(X,2));
for i = 1:size(X,2)
    textCell(i) = java.lang.String(D(stringIndex));
    stringIndex = stringIndex + 1;
    if stringIndex > size(D,1)
        stringIndex = 1;
    end
end
end