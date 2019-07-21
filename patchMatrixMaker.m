function [xPatch, yPatch] = patchMatrixMaker(X,Y,indexMatrix, Nbits, bitInAnalysis, durationOfPackage)
xPatch = [];
yPatch = [];
j = bitInAnalysis;
    for i = bitInAnalysis:size(indexMatrix,2)-(Nbits+1) % Do primeiro bit do pacote até 
        %xPatch = [xPatch,[X(1,indexMatrix(j));X(1,indexMatrix(j)+durationOfPackage);X(1,indexMatrix(j)+durationOfPackage);X(1,indexMatrix(j))]];
        xPatch = [xPatch,[X(1,indexMatrix(j));X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(j)+Nbits+1);X(1,indexMatrix(j))]];
        %yPatch = [yPatch,[Y(indexMatrix(j));Y(indexMatrix(j)+durationOfPackage);Y(indexMatrix(j)+durationOfPackage);Y(indexMatrix(j))]];
        yPatch = [yPatch,[0;0;3;3]];
        if indexMatrix(j)+Nbits+1 > size(X,2)
            break;
        else
            j = j + Nbits;
        end
        if j + Nbits > size(indexMatrix,2)
            break;
        end
    end
end