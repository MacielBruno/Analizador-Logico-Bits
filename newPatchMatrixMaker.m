function [xPatch, yPatch] = newPatchMatrixMaker(X,Y,indexMatrix, Nbits,matrixOfColors,idle,spaceBetweenCurves)
xPatch = [];
yPatch = [];
firstColor = matrixOfColors(1,:);
j = 1;
counter = 1;
%     for i = j:size(indexMatrix,2)-(Nbits+1) % Do primeiro bit do pacote até
%         if j > size(indexMatrix,2)
%             break;
%         end
%         if matrixOfColors(j,:) ~= matrixOfColors(j-1,:)
%             xPatch = [xPatch,[X(1,indexMatrix(j));X(1,indexMatrix(j)+(Nbits+10)*counter);X(1,indexMatrix(j)+(Nbits+1)*counter);X(1,indexMatrix(j))]];
%             yPatch = [yPatch,[idle;idle;spaceBetweenCurves-1;spaceBetweenCurves-1]];
%         end
%         if indexMatrix(j)+Nbits+1 > size(X,2)
%             break;
%         else
%             j = j + Nbits;
%             counter = counter + 1;
%         end
%         if j + Nbits > size(indexMatrix,2)
%             break;
%         end
%     end
beginning = 1;
for i = 2:size(matrixOfColors,1)% Do primeiro bit do pacote até
    if indexMatrix(j)+Nbits+1 > size(X,2)
        break;
    end
    if matrixOfColors(i,:) ~= matrixOfColors(i-1,:)
        xPatch = [xPatch,[X(1,indexMatrix(beginning));X(1,indexMatrix(j)+(Nbits+1));X(1,indexMatrix(j)+(Nbits+1));X(1,indexMatrix(beginning))]];
        yPatch = [yPatch,[idle;idle;spaceBetweenCurves-1;spaceBetweenCurves-1]];
        beginning = j+(Nbits);
    else
        j = j + Nbits;
    end
    if j + Nbits > size(indexMatrix,2)
        break;
    end
end

end