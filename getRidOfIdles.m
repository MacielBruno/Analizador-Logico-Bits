function matrixWithNoIdle = getRidOfIdles(package, NbitsWithStartBit, idle)
% Esta fun��o serve para pegar uma matriz de dados gerada pela fun��o
% GetPackagesAndTime e filtrar apenas os pacotes, isto �, devolver uma
% matriz contendo apenas os pacotes com os start bits sem os per�odos em
% idle

    % Transformamos a matriz package em um vetor  coluna
    packageVector = package';
    packageVector = packageVector(:);
    
    % �ndices que servir�o como ferramentas nos loops abaixo
    index = 1; % �ndice que vai trabalhar sobre a packageVector (vetor de 
    % entrada);
    output_index = 1; %�ndice que vai trabalhar sobre a packageWithNoIdle 
    % (vetor de sa�da)
    
    for i = 1:size(packageVector,1)
        
        %Procuramos o startbit, esta parte do software vai cortar os idles 
        while packageVector(index) == idle
            index = index + 1;
        end
        
        % Pegamos os peda�os que n�o cont�m os bits idle, apenas os pacotes
        %em si
        if size(packageVector,1) - index <  NbitsWithStartBit
                break
        else
            for i2 = 1:NbitsWithStartBit
                packageWithNoIdle(output_index) = packageVector(index);
                index = index + 1;
                output_index = output_index + 1;
            end
        end
    end
    
    % Esta parte vai pegar o vetor com os pacotes sem os idles e gera uma
    % matriz com os pacotes
    matrixWithNoIdle = reshape(packageWithNoIdle,NbitsWithStartBit,floor(size(packageWithNoIdle,2)/NbitsWithStartBit));
    matrixWithNoIdle =  matrixWithNoIdle';
end