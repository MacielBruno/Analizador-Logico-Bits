function Packages = GetPackages_(ANTIGO)( channel, initial_bit, sampleRate, N_bits, idle, Tbit, N_bits_idle)
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

sampleTime = 1/sampleRate;
firstBit = Tbit/2; % O primeiro bit do pacote
half_bit_sample_counter = uint32(firstBit/sampleTime);

index = 1; % Marca o �ndice que est� apontando no vetor
current_bit = initial_bit;

% Somo a quantidade total de amostras, multiplico pelo seu per�odo e divido
%pelo per�odo de um bit do pacote, conseguindo, assim, a quantidade de bits
%contidos no canal.
total_number_of_bits = uint32((sum(channel)*sampleTime)/Tbit);

number_of_seen_bits = 0;


Packages = zeros(integer(total_number_of_bits/N_bits),N_bits);

not_finished = 1;
sample_counter = 0;
% Parte 1: Recebemos um canal e analisamos quando acaba a transmiss�o de um
% pacote corrompido
while (1)
    if current_bit == idle && channel(index) >= N_bits_idle
        current_bit = ~current_bit;
        index = index + 1;
        number_of_seen_bits = number_of_seen_bits + channel(index);
        if number_of_seen_bits == total_number_of_bits
            not_finished = 0;
        end
        break;
    else
        current_bit = ~current_bit;
        index = index + 1;
        number_of_seen_bits = number_of_seen_bits + channel(index);
        if number_of_seen_bits == total_number_of_bits
            not_finished = 0;
            break;
        end
    end
end

% Parte 2:
i = 1; % Conta qual pacote est� sendo analisado
package_counter = 0; % Conta quantos bits j� foram contados em um pacote
while not_finished
    level_counter = 0; 
    for level_counter = 1:channel(index)
        Packages(i,level_counter) = current_bit;
    end
    package_counter = package_counter + channel(index);
    number_of_seen_bits = number_of_seen_bits + channel(index);
    current_bit = ~current_bit;
    index = index + 1;
    if number_of_seen_bits == total_number_of_bits
            not_finished = 0;
            break;
    end
    if package_counter == N_bits
        i = i + 1; % Pr�ximo pacote
        package_counter = 0;
    end
end
    