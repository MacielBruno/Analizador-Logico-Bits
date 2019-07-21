function [matrixWithNoIdle, timeWithNoIdles, indexMatrix] = getRidOfIdles(package, packageTime, NbitsWithStartBit, idle)
% Esta fun��o serve para pegar uma matriz de dados gerada pela fun��o
% GetPackagesAndTime e filtrar apenas os pacotes, isto �, devolver uma
% matriz contendo apenas os pacotes com os start bits sem os per�odos em
% idle. Dessa forma, esta fun��o deve alterar a matriz que monitora o tempo
% de in�cio de cada bit;

    % Transformamos a matriz package em um vetor  coluna
    packageVector = package';
    packageVector = packageVector(:);
    
    % Transforma a matriz packageTime em um vetor coluna
    timeVector = packageTime';
    timeVector = timeVector(:);
    
    % �ndices que servir�o como ferramentas nos loops abaixo
    index = 1; % �ndice que vai trabalhar sobre a packageVector (vetor de 
    % entrada);
    output_index = 1; %�ndice que vai trabalhar sobre a packageWithNoIdle 
    % (vetor de sa�da)
    
    % Pega os �ndices os quais se encontram os bits de pacotes
    indexMatrix = [];
    for i = 1:size(packageVector,1)
        
        %Procuramos o startbit, esta parte do software vai cortar os idles
        if size(packageVector,1) - index == 0
            break
        end
        while packageVector(index) == idle
            index = index + 1;
            if size(packageVector,1) - index == 0
                break
            end
        end
        
        % Pegamos os peda�os que n�o cont�m os bits idle, apenas os pacotes
        %em si
        if size(packageVector,1) - index <  NbitsWithStartBit
                break
        else
            for i2 = 1:NbitsWithStartBit
                packageWithNoIdle(output_index) = packageVector(index);
                timeWithNoIdle(output_index) = timeVector(index);
                indexMatrix(output_index) = index;
                index = index + 1;
                output_index = output_index + 1;
            end
        end
    end
    
    % Esta parte vai pegar o vetor com os pacotes sem os idles e gera uma
    % matriz com os pacotes
    matrixWithNoIdle = reshape(packageWithNoIdle,NbitsWithStartBit,floor(size(packageWithNoIdle,2)/NbitsWithStartBit));
    matrixWithNoIdle =  matrixWithNoIdle';
    timeWithNoIdles = reshape(timeWithNoIdle,NbitsWithStartBit,floor(size(packageWithNoIdle,2)/NbitsWithStartBit));
    timeWithNoIdles = timeWithNoIdles';
end