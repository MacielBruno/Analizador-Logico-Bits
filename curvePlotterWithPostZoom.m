function curvePlotterWithPostZoom(Signal,sampleRate,strt)

spaceBetweenCurves = 4; % O espa�o entre as curvas vai ser igual a este valor
numberOfCurves = size(Signal,2);

X = struct;
Y = struct;

for i = 1:numberOfCurves
    Nbits = Signal(i).NbitsWithStartBit;
    Tbit = Signal(i).Tbit;
    idle = Signal(i).idle;
    initialBit = Signal(i).InitialBitState;
    [X(i).plot,Y(i).plot, X(i).indexMatrix,X(i).colors,X(i).texts] = XandY(Signal(i).channel, Nbits, idle, Tbit, Signal(i).type, sampleRate, initialBit,strt);
end

for i = 1:numberOfCurves
    Y(i).plot = Y(i).plot + (i-1)*spaceBetweenCurves;
end

% Queremos colocar todos os valores de Y em uma mesma matriz para plot�-los
% ao mesmo tempo, por�m o comprimento dos vetores s�o diferentes, logo
% iremos pegar o comprimento m�ximo dos vetores, e fazer com que os
% comprimentos dos outros vetores se adequem ao tamanho maior;
allSizes = zeros(numberOfCurves,1);
for i = 1:numberOfCurves
    allSizes(i) = size(Y(i).plot,2);
end

maximumSize = max(allSizes);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
allTimes = zeros(numberOfCurves,1);
for i = 1:numberOfCurves
    allTimes(i) = X(i).plot(end);
end
for i = 1:numberOfCurves
    if size(Y(i).plot,2) == maximumSize
        theLargestOne = i;
    end
end

maximumTime = max(allTimes);

for i = 1:Signal(theLargestOne).NbitsWithStartBit;
    timeAppendix(i) = (i*(maximumTime-X(theLargestOne).plot(end))/Signal(theLargestOne).NbitsWithStartBit) + X(theLargestOne).plot(end);
    curveAppendix(i) = idle+(theLargestOne-1)*spaceBetweenCurves;
end

X(theLargestOne).plot = [X(theLargestOne).plot,timeAppendix];
Y(theLargestOne).plot = [Y(theLargestOne).plot,curveAppendix];
maximumSize = numel(X(theLargestOne).plot);
appendixLength = zeros(numberOfCurves,1);

for i = 1:numberOfCurves
    appendixSize = maximumSize - numel(X(i).plot);
    lastChannelTime = X(i).plot(end);
    appendix = appendixGenerator(appendixSize,lastChannelTime,maximumTime);
    X(i).plot = [X(i).plot,appendix'];
    if idle == 0
        appendixCurve = zeros(appendixSize,1)+(i-1)*spaceBetweenCurves;
    elseif idle == 1
        appendixCurve = ~zeros(appendixSize,1)+(i-1)*spaceBetweenCurves;
    end
    Y(i).plot = [Y(i).plot,appendixCurve'];
end

yPlot = zeros(maximumSize,numberOfCurves);
xPlot = zeros(maximumSize, numberOfCurves);

for i = 1:numberOfCurves
    yPlot(:,i) = Y(i).plot;
    xPlot(:,i) = X(i).plot;
end

stairs(xPlot, yPlot, 'color', 'k')
curvesNames = cell(numberOfCurves,1);
yAxis = zeros(numberOfCurves,1);
xAxis = zeros(numberOfCurves,1);

for i = 1:numberOfCurves
    curvesNames(i) = {Signal(i).name};
    yAxis(i) = (yPlot(1,i))/((numberOfCurves)*(spaceBetweenCurves));
    xAxis(i) = -1/9;
end

text(xAxis,yAxis,curvesNames,'Units','Normalized');
hold on

% for i = 1:numberOfCurves % Vai passar o patch() atrav�s de todos os canais
%     Nbits = Signal(i).NbitsWithStartBit;
%     [xPatch, yPatch] = patchMatrixMaker(xPlot(:,i)',yPlot(:,i),X(i).indexMatrix, Nbits, 1, Nbits);
%     for j = 1:size(xPatch,2)
%         patch(xPatch(:,j), yPatch(:,j)+(i-1)*spaceBetweenCurves, cell2mat((X(i).colors(j))')/255,'EdgeColor','w');
%     end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOVO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:numberOfCurves % Vai passar o patch() atrav�s de todos os canais
%     Nbits = Signal(i).NbitsWithStartBit;
%     [xPatch, yPatch] = newPatchMatrixMaker(xPlot(:,i)',yPlot(:,i),X(i).indexMatrix, Nbits, cell2mat((X(i).colors)'), Signal(i).idle,spaceBetweenCurves);
%     for j = 1:size(xPatch,2)
%         patch(xPatch(:,j), yPatch(:,j)+(i-1)*spaceBetweenCurves, cell2mat((X(i).colors(j))')/255,'EdgeColor','w');
%     end
% end

for i = 1:numberOfCurves % Vai passar o patch() atrav�s de todos os canais
    Nbits = Signal(i).NbitsWithStartBit;
    if X(i).indexMatrix == 0
        continue;
    end
    [xPatch, yPatch,colorPatch] = newNewPatchMatrixMaker(xPlot(:,i)',yPlot(:,i),X(i).indexMatrix, Nbits, cell2mat((X(i).colors)'),Signal(i).idle,spaceBetweenCurves);
    for j = 1:size(xPatch,2)
        couleur = cell2mat(colorPatch')/255;
        patch(xPatch(:,j), yPatch(:,j)+(i-1)*spaceBetweenCurves, couleur(j,:),'EdgeColor','w');
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:numberOfCurves
%     
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:numberOfCurves
    if X(i).indexMatrix == 0
        continue;
    end
    [X(i).timeOfPack,X(i).indexOfPack] = packTimeAndIndex(X(i).plot, X(i).indexMatrix, Signal(i).NbitsWithStartBit);
end

stairs(xPlot, yPlot, 'color', [0.65 0.65 0.65])

h = zoom;
h.ActionPreCallback = @(obj,evd)myprecallback(obj,evd,xAxis,yAxis,curvesNames);
h.ActionPostCallback = @(obj,evd)myZoomPostCallback(obj,evd,numberOfCurves,X, Signal,spaceBetweenCurves);
h.Motion = 'horizontal';
h.Enable = 'on';

p = pan;
p.ActionPreCallback = @(obj,evd)myprecallback(obj,evd,xAxis,yAxis,curvesNames);
p.ActionPostCallback = @(obj,evd)myZoomPostCallback(obj,evd,numberOfCurves,X, Signal,spaceBetweenCurves);
p.Motion = 'horizontal';
p.Enable = 'on';
hold off

% function demo
% % Listen to zoom events
% plot(1:10);
% h = zoom;
% h.ActionPreCallback = @myprecallback;
% h.ActionPostCallback = @mypostcallback;
% h.Enable = 'on';
% %
function myprecallback(obj,evd,xAxis,yAxis,curvesNames)
    delete(findall(gcf,'Type','text'));
    text(xAxis,yAxis,curvesNames,'Units','Normalized');

function myZoomPostCallback(obj,evd,numberOfCurves,X, Signal,spaceBetweenCurves)
    text_handle = @(x,y,textca)text(x,y,textca,'hittest','off','HorizontalAlignment', 'left','Interpreter','none');
    newLim = evd.Axes.XLim;
    cont = newLim(2)-newLim(1);
    i = 1;
    textHolder = {};
    while i <= numberOfCurves
        textOutput = 0;
        if size(X(i).timeOfPack(find(X(i).timeOfPack > newLim(1))),2) == 0
            i = i+1;
            continue;
        end
        firstPackHolder = X(i).timeOfPack(find(X(i).timeOfPack > newLim(1)));
        firstPack = firstPackHolder(1);
        firstIndexX = find(X(i).plot == firstPack); % X
        lastPackHolder = X(i).timeOfPack(find(X(i).timeOfPack < newLim(2)));
        if sum(size(lastPackHolder)) == 0
            i = i+1;
            continue;
        end
        lastPack = lastPackHolder(end);
        lastIndexX = find(X(i).plot == lastPack); % X
        
        lastIndexPack = find(X(i).timeOfPack == lastPack);
        firstIndexPack = find(X(i).timeOfPack == firstPack);
        if lastIndexPack - firstIndexPack  < 10
            %%%%%%%%%%%%%%%%%%%%%%%% Continuar aqui
%             textTime = X(i).plot(firstIndexX:lastIndexX);
            textTime = X(i).timeOfPack(firstIndexPack:lastIndexPack);
            textIndex = X(i).indexMatrix(firstIndexPack:lastIndexPack);
            texts = X(i).texts(firstIndexPack:lastIndexPack)';
            texts = texts;
            for k = 1:size(texts,1)
                for j = 1:size(texts{k},1)
                    texts{k,1}{j,1} = char(texts{k,1}{j,1});
                end
            end
            %texts = texts';
%             [textOnCurve,time] = textsCreator(textTime,textIndex',Signal(i).NbitsWithStartBit,texts);
%             H = cell(size(num2cell(time)));
            H = cell(size(num2cell(textTime)));
            H(:,:) = {(i-1)*spaceBetweenCurves + spaceBetweenCurves/2};
            %cellfun(text_handle, num2cell(textTime),H,textOnCurve);
            %textOutput = cellfun(text_handle, num2cell(textTime),H,texts');
            cellfun(text_handle, num2cell(textTime),H,texts');
        end
        i = i+1;
        %textHolder(i) = textOutput;
    end