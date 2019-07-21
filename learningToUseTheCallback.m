function learningToUseTheCallback
X = linspace(0,4*pi,40);
Y = sin(X);

figure
stairs(Y)

h = zoom;
h.Motion = 'Horizontal';
h.Enable = 'On';
set(h,'ActionPreCallback',@brincando);
%h.ActionPostCallback = @brincando;

function brincando(obj,evd)
    newLim = evd.Axes.XLim;
    if newLim < 5
        text(0.5,0.5,'center','Units','Normalized');
    end
