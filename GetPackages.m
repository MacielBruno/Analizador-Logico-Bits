function output = GetPackages(channel, initial_bit, sampleRate, N_bits, idle, Tbit, N_bits_idle)

%%%%%%%%%%%%%%%%%%% DESCRI��O DAS VARI�VEIS DE ENTRADA %%%%%%%%%%%%%%%%%%%%
%   channel: Cont�m os valores de amostragem feitos com o dispositivo;
%   initial_bit: Apresenta o valor inicial do canal;
%   SampleRate: frequ�ncia de amostragem, quantas vezes por segundo a
% entrada � checada;
%   N_bits: n�mero de bits em cada pacote;
%   idle: se idle = '0' o n�vel l�gico de intervalo de envio � baixo, caso
%contr�rio � alto;
%   Tbit: intervalo de tempo entre cada bit do pacote;
%   N_bits_idle: n�mero de bits m�nimo que � preciso a entrada ficar em
%n�vel l�gico baixo para come�ar a an�li.
% idle_counter = 0; % Conta o n�mero de bits em idle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%[digital_channel,packages] = ChannelCreator(22, 0, 10, 100, 12);
%%
%channel = digital_channel;
%initial_bit = digital_channel_initial_bitstates(2);
% initial_bit = 0;
% sampleRate = digital_sample_rate_hz;
% N_bits = 22;
% idle = 0;
sampleTime = 1/sampleRate; % Per�odo de uma amostragem
% Tbit = 1/(4.8e6);
% N_bits_idle = 22;
% N_packages = 10;
% [digital_channel,packages] = ChannelCreator(N_bits, idle, N_packages, Tbit, sampleTime);
% channel = digital_channel;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Vari�veis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
current_bit = initial_bit; % Mant�m o tracking do bit atual
on_idle_counter = 0; % Conta quantos bits foram mantidos em idle na Parte 1
keep_seeking = 1; % Controle do loop da Parte 1
index = 1; % Mant�m o tracking da posi��o que estamos analisando no canal
firstBit_time = Tbit/2; % Per�odo do primeiro bit do pacote
half_bit_sample_counter = (firstBit_time/sampleTime); % Quantidade de
% amostras na metade de um bit(Se entrarmos no tempo de um bit que n�o
% acabou o contamos mesmo assim)
number_of_seen_samples = 0; % Conta a quantidade de amostras vistas
finished = 0; % Controle de finaliza��o da fun��o
total_number_of_bits = ceil((sum(channel)*sampleTime)/Tbit); % Quantidade
% de bits contidos no canal (quantidade de amostras*vezes a quantidade de
% bits em uma amostra);
total_number_of_packages = ceil(total_number_of_bits/N_bits); % Conta a
% a quantidade de pacotes contidos no canal
Packages1 = zeros(total_number_of_packages,N_bits);% Inicializa
% a vari�vel de sa�da como uma matriz de zeros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

% Parte 1: Contar o n�mero de bits que est�o em IDLE, visando achar o final
% do bit corrompido(Quantidade de amostras em 1 bit = Tbit/sampleTime)

%bit_index = 1;
while(keep_seeking)
    if (channel(index)/(2*half_bit_sample_counter)) >= N_bits_idle && current_bit == idle
        keep_seeking = 0;
    else
        index = (index + 2);
    end
end
%%

%%%%%%%%%%%%% Parte 2: Pegar os bits e coloc�-los nos arrays %%%%%%%%%%%%%%

% Procedimento da Parte 2:
% Conto a quantidade de bits em um elemento do channel (fazendo a divis�o),
% se a quantidade for igual a N, iremos colocar N bits no vetor.
current_bit = ~current_bit;
output_vector = []; %Vetor que vai receber o canal
channel_index = index + 1; %Conta o �ndice do canal
initial_part2_index = index + 1;
output_index = 1; %Conta o �ndice do vetor de sa�da
la = channel(index) - half_bit_sample_counter;% Iremos retirar

on_first_half_bit = 1; % Indica se est� a procura do primeiro bit ou n�o,
% uma vez que a medi��o de n�vel l�gico � feita na 
% metade de um bit, na primeira medi��o deve ser olhado at� o equivalente
% a meio bit em amostras.

for channel_index = initial_part2_index:size(channel,1)
    % Vai verificar se no primeiro elemento do channel h� a metade de um
    % bit, se houver, coloca o valor do current_value no vetor de sa�da, e
    % ent�o retira a quantitade de amostras da metade de um bit do channel
    
    % Se ele j� achou o primeiro (meio) bit, vai dividir o elemento do canal em um
    % bit inteiro, i.e., vai ver quantos bits h� no restante do elemento. Por�m, se ele
    % n�o achou um bit ainda vai dividir o elemento do canal por um bit
    
    % Quantidade de bits dentro de um elemento do channel, se estamos
    % procutando um bit inteiro, dividimos o canal por duas vezes meio bit
    quociente = ((channel(channel_index))/((half_bit_sample_counter*(1 + (~on_first_half_bit))))); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Se estamos procurando um 
    
    resto = rem(channel(channel_index), (half_bit_sample_counter*(1 + on_first_half_bit)));
    %resto = double(double(channel(channel_index))/double(half_bit_sample_counter*(1 + (~on_first_half_bit))) - quociente);
    
    % Se houver meio bit dentro do canal:
    if on_first_half_bit ==1 && quociente >= 1%Estava a procura do primeiro
        % bit e acabou de encontrar-lo dentro do elemento, i.e.
        
        on_first_half_bit = 0; % Sinaliza que encontrou a metade de um bit
        output_vector(output_index) = current_bit; % Coloca o valor do bit no vetor de sa�da
        output_index = output_index + 1; % Incrementa o �ndice do vetor de sa�da
        channel(channel_index)=channel(channel_index)-half_bit_sample_counter;%Retiro a quantidade de meio bit do elemento atual
        quociente = ((channel(channel_index))/((half_bit_sample_counter*(1 + (~on_first_half_bit)))));%Mede a quantidade de bits inteitos contidos no elemento do canal
        resto = (rem(channel(channel_index), (half_bit_sample_counter*(1 + (~on_first_half_bit)))));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Conta quantas amostras sobraram no elemento do canal, que n�o
        % formaram um bit inteiro, este valor ser� somado ao pr�ximo
        % elemento, i.e., channel(index + 1)
    
    elseif on_first_half_bit ==1 && quociente < 1
        channel(channel_index+1) = channel(channel_index+1) + resto; % Uma vez que n�o foi encontrado meio bit no elemento atual
        % i.e., channel(index), a quantidade de amostras no channel(index)
        % vai se colocada no channel(index+1). 
    end
    
    if on_first_half_bit == 0 % Se ele j� encontrou o primeiro meio bit
        for i = 1:quociente   % Cada bit encontrado no channel(index)
            % vai ser colocado no output_vector
            output_vector(output_index) = current_bit;
            output_index = output_index + 1;
        end
        % O restante das amostras encontradas no elemento atual vai ser
        % somado �s amostras do pr�ximo elemento
        if channel_index ~= size(channel)
            channel(channel_index+1) = channel(channel_index+1) + resto;
        end
        end
    current_bit = ~current_bit;
end

final_output_vector = output_vector;
N_lines = floor(size(final_output_vector, 2)/N_bits);
output_vector = output_vector(:, 1:N_lines*N_bits);
output = reshape(output_vector, [N_bits,N_lines]);
%  %output = reshape(final_output_vector,[22,19]);
output = output';
% 
%  teste = isequal(packages(2:end,:), output);
end