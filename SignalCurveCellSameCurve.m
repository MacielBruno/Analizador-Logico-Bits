function SignalCurveCellSameCurve(Signal, Nbits, idle, Tbit)

% Vai armazenar a quantidade de Curvas que dever�o ser plotadas
numberOfCurves = size(Signal,2);

X = struct;
Y = struct;

for i = 1:numberOfCurves
    [X(i).plot,Y(i).plot, X(i).indexMatrix] = XandYGeneratorSameCurve(Signal(i).channel, Nbits, idle, Tbit);
end
%text = getCertainComponents(X, typeOfInput, stringArray);

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*2;
end
ylim([-1 2]);
colors = [ [1 0 0]; [0 1 0]; [0 0 1]; [1 1 0];[1 0 1];[0 1 1];[0 0 0]];

% Queremos colocar todos os valores de Y em uma mesma matriz para plot�-los
% ao mesmo tempo, por�m o comprimento dos vetores s�o diferentes, logo
% iremos pegar o comprimento m�ximo dos vetores, e fazer com que os
% comprimentos dos outros vetores se adequem ao tamanho maior;
allSizes = zeros(numberOfCurves,1);
for i = 1:numberOfCurves
    allSizes(i) = size(Y(i).plot,2);
end

maximumSize = max(allSizes);

%Vamos fazer o ap�ndice de idles no final dos pacotes
for i = 1:numberOfCurves
    if size(Y(i).plot,2) == maximumSize
        theLargerOne = i;
    else
        appendixLength = maximumSize-size(Y(i).plot,2);
        if idle == 0
            appendix = zeros(appendixLength,1)+(i-1)*2;
        else
            appendix = ones(appendixLength,1)+(i-1)*2;
        end
        Y(i).plot = [Y(i).plot'; appendix];
    end
end

% D� a todos os canais de pacotes a mesma escala de tempo, a escala do
% canal maior
for i = 1:numberOfCurves
    X(i).plot = X(theLargerOne).plot;
end

for i = 1:numberOfCurves 
    % Esta regi�o do software vai definir quantos bits de um pacote s�o
    % representados por um nome, isto �, digamos que tenhamos um pacote dado
    % por [00001111] e os quatro primeiros bits s�o chamados de "ZERO" e o
    % resto chamado de "UM", logo, associaremos o vetor ["ZERO"; "UM"] a [4,4].
    % Faremos tal associa��o usando o valor .type de cada canal.
    if strcmp(Signal(i).type,'SM2Arm')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneSM2Arm  ');
        textArray(2) = java.lang.String('twoSM2Arm  ');
        textArray(3) = java.lang.String('threeSM2Arm');
        whereThisNameStarts = [10,13]; %Quantos bits cada nome engloba
        whereNameStarts(i) = {whereThisNameStarts};
    elseif strcmp(Signal(i).type,'Arm2CC')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneArm2CC  ');
        textArray(2) = java.lang.String('twoArm2CC  ');
        textArray(3) = java.lang.String('threeArm2CC');
        whereThisNameStarts = [10,13]; %Quantos bits cada nome engloba
        whereNameStarts(i) = {whereThisNameStarts};
    elseif strcmp(Signal(i).type,'CC2Arm')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneCC2Arm  ');
        textArray(2) = java.lang.String('twoCC2Arm  ');
        textArray(3) = java.lang.String('threeCC2Arm');
        whereThisNameStarts = [10,13]; %Quantos bits cada nome engloba
        whereNameStarts(i) = {whereThisNameStarts};
    elseif strcmp(Signal(i).type,'Arm2SM')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneArm2SM  ');
        textArray(2) = java.lang.String('twoArm2SM  ');
        textArray(3) = java.lang.String('threeArm2SM');
        whereThisNameStarts = [10,13]; %Quantos bits cada nome engloba
        whereNameStarts(i) = {whereThisNameStarts};
    end
    X(i).text = getTextCell(X(i).plot, textArray, whereThisNameStarts);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nesta regi�o do c�digo, iremos reunir todos os vetores Y, em uma s�
% matriz, visando plotar todas as curvas de uma vez s�
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

stairs(X(1).plot, yPlot)
curvesNames = {};
yAxis = [];
xAxis = [];
for i = 1:numberOfCurves
    text(X(1).plot, yPlot(:,i)', yText(i,:),'FontSize',3,'Rotation', -90);
    curvesNames(i) = {Signal(i).name};
    yAxis(i) = (i-1)*2/((numberOfCurves-1)*2);
    xAxis(i) = -0.125;
end
text(xAxis, yAxis, curvesNames, 'Units', 'Normalized', 'fontsize', 10);
hold on
patch([0 0 X(1).plot(size(X(1).plot,2)) X(1).plot(size(X(1).plot,2))], [0 4 4 0], 'green')
patch([0 0 X(1).plot(size(X(1).plot,2)) X(1).plot(size(X(1).plot,2))], [4 5 5 4], 'blue')
stairs(X(1).plot, yPlot)
hold off
h = zoom;
set(h,'Motion','horizontal','Enable','on');
datacursormode on;
end