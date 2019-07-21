function [textCell,startText] = textCellCreator(X,indexMatrix, Nbits,matrixOfTexts)
numOfColumns = size(matrixOfTexts,2);
for i = 1:size(matrixOfTexts,1) % �ndice que vai percorrer todos os pacotes
    if i == 385
        UYUIYI = 1;
    end
    for j = 2:size(matrixOfTexts,2) % �ndice que percorre todas as colunas
        if isequal(matrixOfTexts{i,j},[]) == 0
            if isequal(matrixOfTexts{i,j}, cell(0))
                matrixOfTexts{i,1}{size(matrixOfTexts{i,1},1)+1,1} = (matrixOfTexts{i,j});
            else
                matrixOfTexts{i,1}{size(matrixOfTexts{i,1},1)+1,1} = (matrixOfTexts{i,j}{1});
            end
        else
            continue
        end
    end
end
matrixOfTexts = matrixOfTexts(:,1);
counter = 1;
textCell = {};
startText = [];
j = 1;
start = 1;
for i = 1:size(matrixOfTexts,1)
    length = size(matrixOfTexts{i},1);
    for j = 1:size(matrixOfTexts{i})
        if isequal(matrixOfTexts{i,1}{length+1-j,1},cell(0))
            matrixOfTexts{i,1}(length+1-j) = [];
        end
    end
end

for i = 2:size(matrixOfTexts,1)
    if isequal(matrixOfTexts{i}, matrixOfTexts{i-1}) == 0
        textCell{counter} = matrixOfTexts{i-1};
        startText(counter) = X(1,indexMatrix(start));
        counter = counter + 1;
        start = j;
    elseif i == size(matrixOfTexts,1)
        textCell{counter} = matrixOfTexts{i-1};
        startText(counter) = X(1,indexMatrix(start));
        counter = counter + 1;
        start = j;
    end
    j = j + Nbits;
end

contador = 0;
textCell = textCell';
for i = 1:size(textCell,1)
    for j = 1:size(textCell{i},1)
        textCell{i,1}{j,1} = char(textCell{i,1}{j,1});
        contador = contador + 1;
    end
end
textCell = textCell';     
end