function [X,Y] = XandYGeneratorSameCurve(file, Nbits, idle, Tbit)
% Esta fun��o ir� gerar os valores no eixo X e Y, isto �, o tempo que
% ocorre cada bit e seu respectivo valor, a partir de um canal gerado por
% um analizador l�gico, tais valores gerados ir�o ser plotados pela fun��o
% SignalCurve;

% A partir do canal, tomamos os pacotes de bits e ent�o transformamos em um
% vetor, o qual iremos, plotar e pegamos os pontos no tempo em que cada
% pacote se inicia.
[workingChannelwithIdle, packagesTimeWithIdle] = GetPackagesAndTime(file, 0, 24000000, Nbits, idle,  1/(4.8e6), 23);
% packagesTime apresenta quando come�a cada pacote, i.e., o tempo de
% in�cio de cada vetor de um conjunto de bits espa�ados em 23, por�m
% queremos o valor de tempo que mostra o in�cio de cada bit do pacote, para
% resolver tal problema, usaremos a fun��o packageToBitTime.m;

% Esta parte vai gerar um vetor de tempo que marca o in�cio de cada bit,
% usando como base o vetor que marca o in�cio dos pacotes. Entretanto, este
% vetor apresenta o in�cio de cada bit idle tamb�m, o qual iremos retirar
% na fun��o getRidOfIdles.m;
bitTimeVectorWithIdle = packageToBitTime(packagesTimeWithIdle(1:size(packagesTimeWithIdle,2)-1), 23, Tbit);
numberOfBitsBeforeFullPackage = ceil(bitTimeVectorWithIdle(1)/Tbit);

% Na fun��o getRidOfIdles iremos tomar apenas os pacotes das matrizes do 
% canal geradas anteriormente pela GetPackagesAndTime, al�m disso iremos
% arrumar a matriz que marca o tempo de in�cio de cada bit do pacote, isto
% �, como a matriz carrega consigo os tempos de in�cio de cada bit e
% estamos retirando alguns deles, devemos retirar o tempo de in�cio dos 
% bits retirados;

%[workingChannel, bitTimeMatrix] = getRidOfIdles(workingChannelwithIdle,bitTimeVectorWithIdle, 23, 0);
workingChannel = workingChannelwithIdle;
bitTimeMatrix = bitTimeVectorWithIdle;

% Como a fun��o getRidOfIdles retorna matrizes, iremos transfom�-las em
% vetores


% Matriz de bits
workingChannelVectorStep = workingChannel';
workingChannelVectorStep = workingChannelVectorStep(:);
if idle == 0
    appendix = zeros(numberOfBitsBeforeFullPackage,1);
elseif idle == 1
    appendix = ones(numberOfBitsBeforeFullPackage,1);
end
workingChannelVector = [appendix;workingChannelVectorStep];
bitTimeVectorStep = bitTimeMatrix';
bitTimeVector = bitTimeVectorStep(:);

% Matriz de tempo
bitTimeVectorTool = zeros(numberOfBitsBeforeFullPackage,1);
bitTimeVectorTool(1) = 0;
for i = 2:numberOfBitsBeforeFullPackage
    bitTimeVectorTool(i) = 1*Tbit + bitTimeVectorTool(i-1);
end
bitTimeVector = [bitTimeVectorTool;bitTimeVector];



numberOfNonFullPackageBits = size(bitTimeVector,1) - size(workingChannelVector,1);
workingChannelVector = [zeros(numberOfNonFullPackageBits,1);workingChannelVector];

X = [bitTimeVector'];
Y = [workingChannelVector'];

end