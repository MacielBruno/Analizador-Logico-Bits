function demo2
% Listen to pan events
plot(1:10);
h = pan;
h.ActionPreCallback = @myprecallback;
h.Enable = 'on';
%
function myprecallback(obj,evd)
disp('A pan is about to occur.');
%
function mypostcallback(obj,evd)
disp('The new X-Limits are');