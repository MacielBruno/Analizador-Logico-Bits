function plot_test(time_vector, initial_state)

temp = 0.5*(-1).^(1:length(time_vector));
vec = [1 logical(temp + 0.5)];
if initial_state == 0
    vec = ~vec;
end
time_vector = cumsum([0; time_vector]);
stairs(time_vector,vec)
