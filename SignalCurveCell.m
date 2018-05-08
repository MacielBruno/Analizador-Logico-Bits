function SignalCurve(Signal, file, Nbits, idle, Tbit)

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
    X(i).text = getTextCell(X(i).plot, textArray);
end
%text = getCertainComponents(X, typeOfInput, stringArray);

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*2;
end

ylim([-1 2]);
colors = [ [1 0 0]; [0 1 0]; [0 0 1]; [1 1 0];[1 0 1];[0 1 1];[0 0 0]];
index = 0;
for i = 1:numberOfCurves
    %ylabel(Signal(i).name, 'position', [-0.005 (i-0.5) 0]);
%     ylabel('Difference', 'position',[x y z])
    if i <= size(colors)
        stairs(X((numberOfCurves+1)-i).plot, Y((numberOfCurves+1)-i).plot, 'Color', colors(i,:));
        text(X((numberOfCurves+1)-i).plot, Y((numberOfCurves+1)-i).plot, char(X((numberOfCurves+1)-i).text));
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
zoom on;


% Temos no eixo X valores espaçados de Tbit, pois estamos amostrando cada
% bit, logo precisamos de 
% X = 0:Tbit:Tbit*size(workingChannelVector,1);
% Y = [0,workingChannelVector'];
% stem(X, Y);
% zoom on;

end