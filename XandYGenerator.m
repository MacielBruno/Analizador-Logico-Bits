function [X,Y] = XandYGenerator(file, Nbits, idle, Tbit)
% Esta função irá gerar os valores no eixo X e Y, isto é, o tempo que
% ocorre cada bit e seu respectivo valor, a partir de um canal gerado por
% um analizador lógico, tais valores gerados irão ser plotados pela função
% SignalCurve;

% A partir do canal, tomamos os pacotes de bits e então transformamos em um
% vetor, o qual iremos, plotar e pegamos os pontos no tempo em que cada
% pacote se inicia.
[workingChannelwithIdle, packagesTimeWithIdle] = GetPackagesAndTime(file, 0, 24000000, Nbits, idle,  1/(4.8e6), 23);
% packagesTime apresenta quando começa cada pacote, i.e., o tempo de
% início de cada vetor de um conjunto de bits espaçados em 23, porém
% queremos o valor de tempo que mostra o início de cada bit do pacote, para
% resolver tal problema, usaremos a função packageToBitTime.m;

% Esta parte vai gerar um vetor de tempo que marca o início de cada bit,
% usando como base o vetor que marca o início dos pacotes. Entretanto, este
% vetor apresenta o início de cada bit idle também, o qual iremos retirar
% na função getRidOfIdles.m;
bitTimeVectorWithIdle = packageToBitTime(packagesTimeWithIdle(1:size(packagesTimeWithIdle,2)-1), 23, Tbit);

% Na função getRidOfIdles iremos tomar apenas os pacotes das matrizes do 
% canal geradas anteriormente pela GetPackagesAndTime, além disso iremos
% arrumar a matriz que marca o tempo de início de cada bit do pacote, isto
% é, como a matriz carrega consigo os tempos de início de cada bit e
% estamos retirando alguns deles, devemos retirar o tempo de início dos 
% bits retirados;
[workingChannel, bitTimeMatrix] = getRidOfIdles(workingChannelwithIdle,bitTimeVectorWithIdle, 23, 0);

% Como a função getRidOfIdles retorna matrizes, iremos transfomá-las em
% vetores
workingChannelVectorStep = workingChannel';
workingChannelVector = workingChannelVectorStep(:);

bitTimeVectorStep = bitTimeMatrix';
bitTimeVector = bitTimeVectorStep(:);

numberOfNonFullPackageBits = size(bitTimeVector,1) - size(workingChannelVector,1);
workingChannelVector = [zeros(numberOfNonFullPackageBits,1);workingChannelVector];

X = [0,bitTimeVector'];
Y = [0,workingChannelVector'];

end