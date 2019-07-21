function [X,Y,indexMatrix, colors, text] = XandY(file, Nbits, idle, Tbit,type,sampleRate,initialBit,strt)
% Esta fun��o ir� gerar os valores no eixo X e Y, isto �, o tempo que
% ocorre cada bit e seu respectivo valor, a partir de um canal gerado por
% um analizador l�gico, tais valores gerados ir�o ser plotados pela fun��o
% SignalCurve;

% A partir do canal, tomamos os pacotes de bits e ent�o transformamos em um
% vetor, o qual iremos, plotar e pegamos os pontos no tempo em que cada
% pacote se inicia.
[workingChannelwithNoIdle, packagesTimeWithNoIdle] = packAndTime(file, initialBit, sampleRate, Nbits, idle,  Tbit, Nbits*0.7);

% bitTimeVectorWithIdle = packageToBitTime(packagesTimeWithIdle(1:size(packagesTimeWithIdle,2)-1), Nbits, Tbit);
if size(workingChannelwithNoIdle,1) == 0
    colors = {[255,255,255]};
    text = {'Pacote Incompleto'};
    X = [0];
    Y = [1];
    indexMatrix = [0];
else
    numberOfBitsBeforeFullPackage = ceil(packagesTimeWithNoIdle(1)/Tbit);
    [colors,text]=typeIdentifier(workingChannelwithNoIdle,type,strt);
    workingChannel = workingChannelwithNoIdle;
    bitTimeMatrix = packagesTimeWithNoIdle;
% Iremos adicionar uma coluna de idle no workingChannel e uma matriz do
% tempo de in�cio de cada idle

% workingChannel
if idle == 0
    appendix = zeros(size(workingChannel,1),1);
elseif idle == 1
    appendix = ~zeros(size(workingChannel,1),1);
end
workingChannel = [workingChannel,appendix];

% time
appendix = bitTimeMatrix(:,end) + Tbit;
bitTimeMatrix = [bitTimeMatrix, appendix];

bitTimeMatrixStep = bitTimeMatrix';
bitTimeVectorWithIdle = bitTimeMatrixStep(:);
[workingChannelWithNoIdle, bitTimeMatrixWithNoIdle, indexMatrix] = getRidOfIdles(workingChannel,bitTimeMatrix, Nbits, idle);

% Vetor de bits
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


end