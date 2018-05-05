% [channel,packages] = ChannelCreator(22, 0, 10, 100, 12);
% profile on;
% [Packages, time] = GetPackagesAndTime(digital_channel_3, 0, digital_sample_rate_hz, 23, 0, 1/(4.8e6), 23);
% profile viewer;
% PackagesWithNoIdle = getRidOfIdles(Packages, 23, 0);

%%%%%%%% Esta é a minha MAIN que vai controlar a plotagem da curva %%%%%%%%
% Esta região irá agrupar os dados dos canais originados do meu Analizador
% Lógico, vai indexá-los em uma estrutara, juntamente com o tipo de dado
% que ele representa e o nome que queremos dá-lo no momento da plotagem

clc;
Signal = struct; % O sinal é uma estrutura, embora não seja usado nessa
% parte inicial
Signal(1).channel = digital_channel_1(1:50000);
Signal(2).channel = digital_channel_2(1:50000);
Signal(3).channel = digital_channel_3(1:50000);

Signal(1).type = 'TBD';
Signal(2).type = 'TBD';
Signal(3).type = 'TBD';

Signal(1).name = 'Canal 1';
Signal(2).name = 'Canal 2';
Signal(3).name = 'Canal 3';

Tbit = (1/(4.8e6));
NbitsWithStartBit = 23;
IDLE = 0;

file = digital_channel_3(1:50000); % O File vai ser igual ao digital_channel_3
SignalCurve(Signal, file, NbitsWithStartBit, IDLE, Tbit);
