function SignalCurve(Signal, file, strt_cfg)
Tbit = (1/(4.8e6));
Nbits = 23;
idle = 0;
numberOfCurves = 1;

[X,Y] = XandYGenerator(file, Nbits, idle, Tbit);
%text = getCertainComponents(X, typeOfInput, stringArray);

ylim([-1 2]);
stairs(X, Y);
zoom on;


% Temos no eixo X valores espaçados de Tbit, pois estamos amostrando cada
% bit, logo precisamos de 
% X = 0:Tbit:Tbit*size(workingChannelVector,1);
% Y = [0,workingChannelVector'];
% stem(X, Y);
% zoom on;


end
% packagesCurve = figure; % Cria uma janela onde os gráficos serão plotados
% set(packagesCurve, 'Color', 'w'); % Cor de fundo da janela
% 
% % Muda o nome da janela de plotagem
% set(packagesCurve, 'Name', 'Signal Curve'); 
% set(packagesCurve, 'NumberTitle', 'off');
% 
% % Pega o canal em que iremos trabalhar a partir do file e o tempo que se
% % inicia cada pacote do canal
% [workingChannel, packagesTime] = GetPackagesAndTime(file.digital_channel_3, 0, file.digital_sample_rate_hz, 22, 0,  1/(4.8e6), 22);
% 
% % Cria uma escala na abscissa, discretizada em Tbit
% Tbit = 1/(4.8e6);
% x = linspace(0,packagesTime(end)+Tbit,Tbit);
% y = workingChannel;
% plot(x,y);
% 
% 
% end
% 
