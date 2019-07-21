function [xPatch, yPatch, colorPatch] = newNewPatchMatrixMaker(X,Y,indexMatrix, Nbits,matrixOfColors, idle,spaceBetweenCurves)
xPatch = [];
yPatch = [];
colorPatch = {};
j = 1;
start = j;
counter = 1;

    if size(matrixOfColors,1) == 1
        xPatch = [xPatch,[X(1,indexMatrix(start));X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(start))]];
        yPatch = [yPatch,[0;0;3;3]];
        colorPatch{1} = matrixOfColors(1,:);
    else
        for i = 2:size(indexMatrix,2) % Do primeiro bit do pacote at� 
            if matrixOfColors(i,:) ~= matrixOfColors(i-1,:)
                xPatch = [xPatch,[X(1,indexMatrix(start));X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(start))]];
                yPatch = [yPatch,[0;0;3;3]];
                start = j + Nbits;
                colorPatch{counter} = matrixOfColors(i-1,:);
                counter = counter + 1;
            elseif i == size(indexMatrix,2)
                xPatch = [xPatch,[X(1,indexMatrix(start));X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(start))]];
                yPatch = [yPatch,[0;0;3;3]];
                colorPatch{counter} = matrixOfColors(i-1,:);
                start = j + Nbits;
            end
            if indexMatrix(j)+Nbits+1 > size(X,2)
                break;
            else
                j = j + Nbits;
            end
            if j + Nbits > size(indexMatrix,2)
                xPatch = [xPatch,[X(1,indexMatrix(start));X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(start))]];
                yPatch = [yPatch,[0;0;3;3]];
                colorPatch{counter} = matrixOfColors(i-1,:);
                start = j + Nbits;
                break;
            end
        end
    end
end