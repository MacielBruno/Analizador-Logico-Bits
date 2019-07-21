function SignalCurveCell(Signal, Nbits, idle, Tbit)

% Vai armazenar a quantidade de Curvas que deverão ser plotadas
numberOfCurves = size(Signal,2);

X = struct;
Y = struct;

textArray = java_array('java.lang.String',3);
textArray(1) = java.lang.String('one');
textArray(2) = java.lang.String('two');
textArray(3) = java.lang.String('three');

for i = 1:numberOfCurves
    [X(i).plot,Y(i).plot] = XandYGenerator(Signal(i).channel, Nbits, idle, Tbit);
    
% Esta região do software vai definir quantos bits de um pacote são
% representados por um nome, isto é, digamos que tenhamos um pacote dado
% por [00001111] e os quatro primeiros bits são chamados de "ZERO" e o
% resto chamado de "UM", logo, associaremos o vetor ["ZERO"; "UM"] a [4,4].
% Faremos tal associação usando o valor .type de cada canal.
    
    if strcmp(Signal(i).type,'SM2Arm')
        textArray = java_array('java.lang.String',3);
        textArray(1) = java.lang.String('oneSM2Arm  ');
        textArray(2) = java.lang.String('twoSM2Arm  ');
        textArray(3) = java.lang.String('threeSM2Arm');
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
%text = getCertainComponents(X, typeOfInput, stringArray);

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*2;
end

ylim([-1 2]);
colors = [ [1 0 0]; [0 1 0]; [0 0 1]; [1 1 0];[1 0 1];[0 1 1];[0 0 0]];
for i = 1:numberOfCurves
    %ylabel(Signal(i).name, 'position', [-0.005 (i-0.5) 0]);
%     ylabel('Difference', 'position',[x y z])
    if i <= size(colors)
        stairs(X((numberOfCurves+1)-i).plot, Y((numberOfCurves+1)-i).plot, 'Color', colors(i,:));
        text(X((numberOfCurves+1)-i).plot, Y((numberOfCurves+1)-i).plot, char(X((numberOfCurves+1)-i).text),'FontSize',3,'Rotation', -90);
    else
        cor = rand(1,3);
        stairs(X((numberOfCurves+1)-i).plot, Y((numberOfCurves+1)-i).plot, 'Color', cor);
    end
    hold on;
    %stairs(X(i).plot, Y(i).plot, 'DisplayName', Signal(i).name);
    
    %text(0,(i)*2,Signal(i).name, 'Color', 'blue');
    hold on;  
    
end
legend(Signal(:).name, 'Position', 'northeast');
h = zoom;
set(h,'Motion','horizontal','Enable','on');
datacursormode on;
end