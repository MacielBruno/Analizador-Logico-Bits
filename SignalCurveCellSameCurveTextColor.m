function SignalCurveCellSameCurveTextColor(Signal, Nbits, idle, Tbit)

% Vai armazenar a quantidade de Curvas que deverão ser plotadas
numberOfCurves = size(Signal,2);

X = struct;
Y = struct;

textArray = java_array('java.lang.String',3);
textArray(1) = java.lang.String('one');
textArray(2) = java.lang.String('two');
textArray(3) = java.lang.String('three');
for i = 1:numberOfCurves
    [X(i).plot,Y(i).plot, X(i).indexMatrix] = XandYGeneratorSameCurve(Signal(i).channel, Nbits, idle, Tbit);
end
%text = getCertainComponents(X, typeOfInput, stringArray);

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*2;
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
            appendix = zeros(appendixLength,1)+(i-1)*2;
        else
            appendix = ones(appendixLength,1)+(i-1)*2;
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
    if strcmp(Signal(i).type,'SM2Arm')
        textArray = [];
        textArray(1) = 'PAR ';
        textArray(2) = 'Vcap';
        textArray(3) = 'sinc';
        textArray(4) = 'Vcap';
        textArray(5) = 'T1  ';
        textArray(6) = 'T0  ';
        textArray(7) = 'Err1';
        textArray(8) = 'ERR0';
        textArray(9) = 'ACK ';
        lengthOfEachText = [1,8,2,4,1,1,1,1,1];
        whereNameStarts = [2,2,1]; %Quantos bits cada nome engloba
    elseif strcmp(Signal(i).type,'Arm2CC')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneArm2CC  ');
        textArray(2) = java.lang.String('twoArm2CC  ');
        textArray(3) = java.lang.String('threeArm2CC');
        whereNameStarts = [2,1]; %Quantos bits cada nome engloba
    elseif strcmp(Signal(i).type,'CC2Arm')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneCC2Arm  ');
        textArray(2) = java.lang.String('twoCC2Arm  ');
        textArray(3) = java.lang.String('threeCC2Arm');
        whereNameStarts = [2,1]; %Quantos bits cada nome engloba
    elseif strcmp(Signal(i).type,'Arm2SM')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneArm2SM  ');
        textArray(2) = java.lang.String('twoArm2SM  ');
        textArray(3) = java.lang.String('threeArm2SM');
        whereNameStarts = [2,1]; %Quantos bits cada nome engloba
    end
    X(i).text = getTextCell(X(i).plot, textArray, whereNameStarts);
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

stairs(X(1).plot, yPlot);
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

h = zoom;
set(h,'Motion','horizontal','Enable','on');
datacursormode on;
end