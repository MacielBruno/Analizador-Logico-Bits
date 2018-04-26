function matrixWithNoIdle = getRidOfIdles(package, NbitsWithStartBit, idle)
% Esta função serve para pegar uma matriz de dados gerada pela função
% GetPackagesAndTime e filtrar apenas os pacotes, isto é, devolver uma
% matriz contendo apenas os pacotes com os start bits sem os períodos em
% idle

    % Transformamos a matriz package em um vetor  coluna
    packageVector = package';
    packageVector = packageVector(:);
    
    % Índices que servirão como ferramentas nos loops abaixo
    index = 1; % Índice que vai trabalhar sobre a packageVector (vetor de 
    % entrada);
    output_index = 1; %Índice que vai trabalhar sobre a packageWithNoIdle 
    % (vetor de saída)
    
    for i = 1:size(packageVector,1)
        
        %Procuramos o startbit, esta parte do software vai cortar os idles 
        while packageVector(index) == idle
            index = index + 1;
        end
        
        % Pegamos os pedaços que não contêm os bits idle, apenas os pacotes
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