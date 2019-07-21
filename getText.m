function textStruct = getText(X,stringArray)
% Função que serve para mapear a minha matriz contendo os bits, 
% X, visando encontrar os bits que representam cada tipo de 
% informação no meu pacote.


stringIndex = 1;
%textVector = NaN(size(X),1);
textStruct = struct;
for i = 1:size(X,2)
    textStruct(i).bitName = stringArray(stringIndex).bitName;
    stringIndex = stringIndex + 1;
    if stringIndex == size(stringArray,2)
        stringIndex = 1;
    end
end
end