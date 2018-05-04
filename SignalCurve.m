function SignalCurve(Signal, file, Nbits, idle, Tbit)

% Vai armazenar a quantidade de Curvas que deverão ser plotadas
numberOfCurves = size(Signal,2);

X = struct;
Y = struct;

for i = 1:numberOfCurves
    [X(i).plot,Y(i).plot] = XandYGenerator(Signal(i).channel, Nbits, idle, Tbit);
end
%text = getCertainComponents(X, typeOfInput, stringArray);

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*2;
end

ylim([-1 2]);
for i = 1:numberOfCurves
    stairs(X(i).plot, Y(i).plot);
    hold on;
end
zoom on;


% Temos no eixo X valores espaçados de Tbit, pois estamos amostrando cada
% bit, logo precisamos de 
% X = 0:Tbit:Tbit*size(workingChannelVector,1);
% Y = [0,workingChannelVector'];
% stem(X, Y);
% zoom on;

end