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
profile on;
Signal = struct; % O sinal é uma estrutura, embora não seja usado nessa
% parte inicial
% Signal(1).channel = digital_channel_1(1:500);
% Signal(2).channe2 = digital_channel_1(1:500);
% Signal(3).channe3 = digital_channel_1(1:500);

% Signal(1).channel = digital_channel_1(1:100);
% Signal(2).channel = digital_channel_1(101:200);
% Signal(3).channel = digital_channel_1(201:300);
% Signal(4).channel = digital_channel_1(301:400);
% Signal(5).channel = digital_channel_1(401:500);
% Signal(6).channel = digital_channel_1(501:600);
% Signal(7).channel = digital_channel_1(601:700);
% Signal(8).channel = digital_channel_1(701:800);

Signal(1).channel = digital_channel_0;
Signal(2).channel = digital_channel_1;
Signal(3).channel = digital_channel_2;
Signal(4).channel = digital_channel_7;


Signal(1).type = 'CC2Arm';
Signal(2).type = 'CC2Arm';
Signal(3).type = 'Arm2CC';
Signal(4).type = 'SM2Arm';

% Signal(1).type = 'SM2Arm';

% Signal(1).name = 'Canal 1';
% Signal(2).name = 'Canal 2';
% Signal(3).name = 'Canal 3';
% Signal(4).name = 'Canal 4';
% Signal(5).name = 'Canal 5';
% Signal(6).name = 'Canal 6';
% Signal(7).name = 'Canal 7';
% Signal(8).name = 'Canal 8';

Signal(1).name = 'Canal 0';
Signal(2).name = 'Canal 1';
Signal(3).name = 'Canal 2';
Signal(4).name = 'Canal 7';

Signal(1).Tbit = 1/(4.8e6);
Signal(2).Tbit = 1/(4.8e6);
Signal(3).Tbit = 1/(4.8e6);
Signal(4).Tbit = 1/(4e6);

Signal(1).NbitsWithStartBit = 11;
Signal(2).NbitsWithStartBit = 11;
Signal(3).NbitsWithStartBit = 27;
Signal(4).NbitsWithStartBit = 20;

% Signal(1).Tbit = (1/(4.8e6));
% NbitsWithStartBit = 23;
% NbitsWithStartBit = 11;
IDLE = 0;
% SignalCurveCellSameCurveColorful(Signal, NbitsWithStartBit, IDLE, Tbit);
SignalCurveCellSameCurveColorful(Signal,IDLE);
profile viewer;

% [channel,packages] = ChannelCreator(22, 0, 10, 100, 12);
% profile on;
% [Packages, time] = GetPackagesAndTime(digital_channel_3, 0, digital_sample_rate_hz, 23, 0, 1/(4.8e6), 23);
% profile viewer;
% PackagesWithNoIdle = getRidOfIdles(Packages, 23, 0);

%%%%%%%% Esta é a minha MAIN que vai controlar a plotagem da curva %%%%%%%%
% Esta região irá agrupar os dados dos canais originados do meu Analizador
% Lógico, vai indexá-los em uma estrutara, juntamente com o tipo de dado
% que ele representa e o nome que queremos dá-lo no momento da plotagem

% clc;
% profile on;
% Signal = struct; % O sinal é uma estrutura, embora não seja usado nessa
% % parte inicial
% Signal(1).channel = digital_channel_1(1:500);
% Signal(2).channel = digital_channel_2(1:500);
% Signal(3).channel = digital_channel_3(1:500);
% 
% Signal(1).type = 'SM2Arm';
% Signal(2).type = 'Arm2CC';
% Signal(3).type = 'CC2Arm';
% 
% Signal(1).name = 'Canal 1';
% Signal(2).name = 'Canal 2';
% Signal(3).name = 'Canal 3';
% 
% Tbit = (1/(4.8e6));
% NbitsWithStartBit = 23;
% IDLE = 0;
% 
% SignalCurveCellSameCurveColorful(Signal, NbitsWithStartBit, IDLE, Tbit);
% profile viewer;