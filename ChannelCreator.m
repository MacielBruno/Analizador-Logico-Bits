function [channel, packages] = ChannelCreator(N_bits, idle, N_packages, Tbit, SampleTime)
%packages = zeros(2*N_packages, N_bits); % Faz uma matriz com o n�mero de 
% linhas igual a 2 vezes o n�mero de pacotes, pois cada pacote est� 
% espa�ado entre si em pelo menos um pacote de dist�ncia. Ali�s, a matriz
% de canal ter� um n�mero de colunas igual � quantidade de bits em um
% pacote

%%%%%%%%%%%%%%%%%%% PARTE 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gera os pacotes (Est� FUNCIONANDO)
packages = [];
    for i = 1:2*N_packages
        if rem(i,2) == 0
            packages = [packages;[~idle,randi([0 1], 1, N_bits-1)]];
        else
            if idle == 0
                packages = [packages;[zeros(1,N_bits)]];
            elseif idle == 1
                packages = [packages;[ones(1,N_bits)]];
            end
        end
     end


%%%%%%%%%%%%%%%%%%%% PARTE 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
% Gerar o canal a partir dos pacotes

% Iremos contar quantos elementos repetidos temos em sequ�ncia, ent�o
% multiplicaremos tal valor pela quantidade de amostras em um bit e tal
% valor ser� salvo em cada elemento do canal 
% (Est� funcionando)
step = packages';
vector_of_packages = step(:);
samples_in_a_bit = ceil(Tbit/SampleTime);
index = 1;
counter =1;
channel(1) = (counter*samples_in_a_bit);
for i = 2:size(vector_of_packages)
    if vector_of_packages(i-1) == vector_of_packages(i)
        channel(index) = channel(index) + (counter*samples_in_a_bit);
    else
        index = index + 1;
        channel(index) = (counter*samples_in_a_bit);
end
end
end