function SignalCurveCellSameCurveColorful(Signal, idle)
spaceBetweenCurves = 4; % O espaço entre as curvas vai ser igual a este valor

% Vai armazenar a quantidade de Curvas que deverão ser plotadas
numberOfCurves = size(Signal,2);

X = struct;
Y = struct;

for i = 1:numberOfCurves
    Nbits = Signal(i).NbitsWithStartBit;
    Tbit = Signal(i).Tbit;
%    [X(i).plot,Y(i).plot, X(i).indexMatrix] = XandYGeneratorSameCurveShowAndColor(Signal(i).channel, Nbits, idle, Tbit);
    [X(i).plot,Y(i).plot, X(i).indexMatrix,X(i).colors,X(i).texts] = XandYGeneratorSameCurveShowAndColor(Signal(i).channel, Nbits, idle, Tbit, Signal(i).type);
end

%text = getCertainComponents(X, typeOfInput, stringArray);

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*spaceBetweenCurves;
end
ylim([-1 2]);
colors = [ [1 0 0]; [0 1 0]; [0 0 1]; [1 1 0];[1 0 1];[0 1 1];[0 0 0]];

% Queremos colocar todos os valores de Y em uma mesma matriz para plotá-los
% ao mesmo tempo, porém o comprimento dos vetores são diferentes, logo
% iremos pegar o comprimento máximo dos vetores, e fazer com que os
% comprimentos dos outros vetores se adequem ao tamanho maior;
allSizes = zeros(numberOfCurves,1);
for i = 1:numberOfCurves
    allSizes(i) = size(Y(i).plot,2);
end

maximumSize = max(allSizes);

%Vamos fazer o apêndice de idles no final dos pacotes
for i = 1:numberOfCurves
    if size(Y(i).plot,2) == maximumSize
        theLargerOne = i;
    else
        appendixLength = maximumSize-size(Y(i).plot,2);
        if idle == 0
            appendix = zeros(appendixLength,1)+(i-1)*spaceBetweenCurves;
        else
            appendix = ones(appendixLength,1)+(i-1)*spaceBetweenCurves;
        end
        Y(i).plot = [Y(i).plot'; appendix];
    end
end

% Dá a todos os canais de pacotes a mesma escala de tempo, a escala do
% canal maior
for i = 1:numberOfCurves
    X(i).plot = X(theLargerOne).plot;
end

for i = 1:numberOfCurves 
    % Esta região do software vai definir quantos bits de um pacote são
    % representados por um nome, isto é, digamos que tenhamos um pacote dado
    % por [00001111] e os quatro primeiros bits são chamados de "ZERO" e o
    % resto chamado de "UM", logo, associaremos o vetor ["ZERO"; "UM"] a [4,4].
    % Faremos tal associação usando o valor .type de cada canal.
%     if strcmp(Signal(i).type,'SM2Arm')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneSM2Arm  ');
        textArray(2) = java.lang.String('twoSM2Arm  ');
        textArray(3) = java.lang.String('threeSM2Arm');
        whereThisNameStarts = [23]; %Quantos bits cada nome engloba
        whereNameStarts(i) = {whereThisNameStarts};
        colorOfThesePackages = ['r'];
        colorOfPackages(i) = {colorOfThesePackages};
%     elseif strcmp(Signal(i).type,'Arm2CC')
%         textArray = java_array('java.lang.String',3);
%         textArray(1) = java.lang.String('oneArm2CC  ');
%         textArray(2) = java.lang.String('twoArm2CC  ');
%         textArray(3) = java.lang.String('threeArm2CC');
%         whereThisNameStarts = [23]; %Quantos bits cada nome engloba
%         whereNameStarts(i) = {whereThisNameStarts};
%         colorOfThesePackages = ['b'];
%         colorOfPackages(i) = {colorOfThesePackages};
%     elseif strcmp(Signal(i).type,'CC2Arm')
%         textArray = java_array('java.lang.String',3);
%         textArray(1) = java.lang.String('oneCC2Arm  ');
%         textArray(2) = java.lang.String('twoCC2Arm  ');
%         textArray(3) = java.lang.String('threeCC2Arm');
%         whereThisNameStarts = [23]; %Quantos bits cada nome engloba
%         whereNameStarts(i) = {whereThisNameStarts};
%         colorOfThesePackages = ['c'];
%         colorOfPackages(i) = {colorOfThesePackages};
%     elseif strcmp(Signal(i).type,'Arm2SM')
%         textArray = java_array('java.lang.String',3);
%         textArray(1) = java.lang.String('oneArm2SM  ');
%         textArray(2) = java.lang.String('twoArm2SM  ');
%         textArray(3) = java.lang.String('threeArm2SM');
%         whereThisNameStarts = [23]; %Quantos bits cada nome engloba
%         whereNameStarts(i) = {whereThisNameStarts};
%         colorOfThesePackages = ['r'];
%         colorOfPackages(i) = {colorOfThesePackages};
%     end
    X(i).text = getTextCell(X(i).plot, textArray, whereThisNameStarts);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nesta região do código, iremos reunir todos os vetores Y, em uma só
% matriz, visando plotar todas as curvas de uma vez só
yPlot = zeros(maximumSize,numberOfCurves);
yText = cell(numberOfCurves,maximumSize)';

for i = 1:numberOfCurves
    yPlot(:,i) = Y(i).plot;
    yText(:,i) = X(i).text;
end
yText = yText';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:numberOfCurves
%     [X(i).patch, Y(i).patch] = patchMatrixMaker(X(1).plot, yPlot(:,i), X(i).indexMatrix, Nbits);
% end

stairs(X(1).plot, yPlot, 'color', 'k')
curvesNames = {};
yAxis = [];
xAxis = [];
for i = 1:numberOfCurves
    %text(X(1).plot, yPlot(:,i)', yText(i,:),'FontSize',3,'Rotation', -90);
    curvesNames(i) = {Signal(i).name};
%     yAxis(i) = (i-1)*spaceBetweenCurves/((numberOfCurves-1)*2);
    %(numberOfCurves-1)*(spaceBetweenCurves-1) + numberOfCurves
    yAxis(i) = ((i-1)*spaceBetweenCurves)/((numberOfCurves-1)*(spaceBetweenCurves-1) + numberOfCurves);
    xAxis(i) = -1/9;
end
text(xAxis,yAxis,curvesNames,'Units','Normalized');
hold on
for i = 1:numberOfCurves % Vai passar o patch() através de todos os canais
    bitInAnalysis = 1;
    for j = 1:size(whereNameStarts{i},2) % Vai de 1 até a quantidade de pacotes distintos
        Nbits = Signal(i).NbitsWithStartBit;
        [xPatch, yPatch] = patchMatrixMaker(X(i).plot,yPlot(:,i),X(i).indexMatrix, Nbits, bitInAnalysis, whereNameStarts{i}(j));
%         patch(xPatch, yPatch+(i-1)*spaceBetweenCurves, colorOfPackages{i}(j),'EdgeColor','w');
        patch(xPatch, yPatch+(i-1)*spaceBetweenCurves, (X(i).colors{j})/255,'EdgeColor','w');
        bitInAnalysis = bitInAnalysis + whereNameStarts{i}(j);
    end
end

stairs(X(1).plot, yPlot, 'color', [0.65 0.65 0.65])
hold off
h = zoom;
set(h,'Motion','horizontal','Enable','on');
datacursormode on;
end