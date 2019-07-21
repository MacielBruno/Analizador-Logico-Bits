function [X,Y,indexMatrix, colors, text] = XandYGeneratorSameCurveShowAndColorOld(file, Nbits, idle, Tbit,type)
% Esta função irá gerar os valores no eixo X e Y, isto é, o tempo que
% ocorre cada bit e seu respectivo valor, a partir de um canal gerado por
% um analizador lógico, tais valores gerados irão ser plotados pela função
% SignalCurve;

% A partir do canal, tomamos os pacotes de bits e então transformamos em um
% vetor, o qual iremos, plotar e pegamos os pontos no tempo em que cada
% pacote se inicia.
[workingChannelwithIdle, packagesTimeWithIdle] = GetPackagesAndTime(file, 0, 24000000, Nbits, idle,  Tbit, Nbits);
% packagesTime apresenta quando começa cada pacote, i.e., o tempo de
% início de cada vetor de um conjunto de bits espaçados em 23, porém
% queremos o valor de tempo que mostra o início de cada bit do pacote, para
% resolver tal problema, usaremos a função packageToBitTime.m;

% Esta parte vai gerar um vetor de tempo que marca o início de cada bit,
% usando como base o vetor que marca o início dos pacotes. Entretanto, este
% vetor apresenta o início de cada bit idle também, o qual iremos retirar
% na função getRidOfIdles.m;
bitTimeVectorWithIdle = packageToBitTime(packagesTimeWithIdle(1:size(packagesTimeWithIdle,2)-1), Nbits, Tbit);
numberOfBitsBeforeFullPackage = ceil(bitTimeVectorWithIdle(1)/Tbit);

% Na função getRidOfIdles iremos tomar apenas os pacotes das matrizes do 
% canal geradas anteriormente pela GetPackagesAndTime, além disso iremos
% arrumar a matriz que marca o tempo de início de cada bit do pacote, isto
% é, como a matriz carrega consigo os tempos de início de cada bit e
% estamos retirando alguns deles, devemos retirar o tempo de início dos 
% bits retirados;

[workingChannelWithNoIdle, bitTimeMatrixWithNoIdle, indexMatrix] = getRidOfIdles(workingChannelwithIdle,bitTimeVectorWithIdle, Nbits, 0);
workingChannelWithNoIdle = workingChannelWithNoIdle;
%[colors,text]=typeIdentifier(workingChannelWithNoIdle,type);
workingChannel = workingChannelwithIdle;
bitTimeMatrix = bitTimeVectorWithIdle;

% Como a função getRidOfIdles retorna matrizes, iremos transfomá-las em
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
indexMatrix = indexMatrix + size(appendix,1);

% Matriz de tempo
bitTimeVectorTool = zeros(numberOfBitsBeforeFullPackage,1);
bitTimeVectorTool(1) = 0;
for i = 2:numberOfBitsBeforeFullPackage
    bitTimeVectorTool(i) = 1*Tbit + bitTimeVectorTool(i-1);
end
bitTimeVector = [bitTimeVectorTool;bitTimeVector];
% 
% 
% 
% numberOfNonFullPackageBits = size(bitTimeVector,1) - size(workingChannelVector,1);
% workingChannelVector = [zeros(numberOfNonFullPackageBits,1);workingChannelVector];

X = [bitTimeVector'];
Y = [workingChannelVector'];

end