x = linspace(0, 3E+5);
y = cumsum(rand(size(x)));
figure(1)
plot(x, y)
hold on
patch([0 1E+5 1E+5 0], [max(ylim) max(ylim) 0 0], 'r')
patch([1E+5 2E+5 2E+5 1E+5], [max(ylim) max(ylim) 0 0], 'g')
patch([2E+5 3E+5 3E+5 2E+5], [max(ylim) max(ylim) 0 0], 'b')
plot(x, y, 'k', 'LineWidth',1.5)
hold off