function bitTimeVector = packageToBitTime(packageTime, Nbits, Tbit)
    % Esta função serve para pegar um vetor contendo o tempo que começa
    % cada pacote de bits e a partir dele gerar um vetor contendo o tempo
    % de início de cada bit individual;
    
    % Esta função contém o tempo que se inicia cada bit, indistinguindo se
    % é um bit de um pacote ou de idle, logo devemos passar,
    % posteriormente, o vetor gerado por esta função em outro software,
    % chamado getRidOfIdles.m;

    % Iremos trabalhar se o modelo for um vetor linha
    if size(packageTime, 1) == 1
        % Transformamos o vetor em um vetor coluna
        packageTime = packageTime';
    end
    
    bitTime = zeros(size(packageTime,1),Nbits);
    bitTimeVector = bitTime';
    bitTimeVector = bitTime(:);
    bitTimeVector(1) = packageTime(1);
    %bitTimeVector(2) = packageTime(1) + Tbit/2; % Este vai ser o segundo 
    % elemento da matriz de saída, que nada mais é do que o valor inicial
    % da matriz, i.e., o tempo em que é iniciado um pacote completo, mais o
    % tempo da metade de um bit
    
    
    % Fizemos um vetor coluna com o número de elementos igual ao da matriz de
    % saída, contendo o valor de início de cada bit
    for i = 2:size(packageTime,1)*(Nbits)
        bitTimeVector(i) = bitTimeVector(i-1) + Tbit;
    end
%     bitTimeVectorStep = reshape(bitTimeVector, Nbits, size(packageTime,1));
%     bitTime = bitTimeVectorStep';
    
end