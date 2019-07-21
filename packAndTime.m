function [bit, time] = packAndTime(channel, initial_bit, sampleRate, Nbits, idle, Tbit, N_bits_idle)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Como vamos construir a matriz time:
% Os tempos do primeiro pacote � igual a, sendo A = sum(channel(1:index))*Ts,
% TsvecTime = Tsvec*Ts + A
% A = A + sum(channel(1:index))*Ts
% TsvecTime = Tsvec*Ts + A

%%%%%%%%%%%%%%%%%%%%%%%%%% PART 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Seeking for the first Start Bit
index = 1;
Ts = 1/sampleRate;
current_bit = initial_bit;
keep_seeking = 1;
while(keep_seeking)
    if index > size(channel,1)
        break;
    end
    if (channel(index)/(Tbit/Ts)) >= N_bits_idle && current_bit == idle
        keep_seeking = 0;
        current_bit = ~current_bit;
        index = index + 1;
    elseif current_bit == ~idle
        index = index + 1;
        current_bit = ~current_bit;
    else
        index = (index + 2);
    end
end

% Nbits = Number of bits in a packet with start bit
packetCounter = 1;
bit = [];
a = index;
holder = sum(channel(1:index-1))*Ts;

%%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Montar Tsvec
Tsvec = 1:Nbits;
for n = 1:Nbits
    Tsvec(n) = round(((n-1)+0.5)*Tbit/Ts); % Number of samples before each bit initialization
end
TsvecTime = Tsvec*Ts;

%     while(packetCounter*Nbits <= size(channel,1))
channelTime = channel*Ts;
holder = sum(channelTime(1:a-1));
stop = a-1;
summation = 0;
state = current_bit;
while(packetCounter*Nbits <= sum(channel)/(Tbit/Ts))
%     if a <= size(channel,1)
%         summation = summation + channel(a);
%     end



%      if (abs(summation-channel(a-1) - Tsvec(end)) > Tbit/Ts) && (a <= size(channel,1)) && (holder ~=sum(channelTime(1:a-1)))
%          a = a + 1;
%          holder = holder + channelTime(a-1);
%      end
    
    
    
    
%     if state ~= current_bit
%         skfnnfsjdfnsj = 1;
%     end
    summation = 0;
    %%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Montar os pacotes
    n = 1;
    state = current_bit;
    if a ~= index
        holder = holder + channelTime(a-1);
    end
    while(n <= Nbits)
        if a > size(channel,1)
            break;
        end
        summation = summation + channel(a);
        while(summation > Tsvec(n))
            bit(packetCounter,n) = state;
            %                 time(packetCounter,n) = TsvecTime(n) + sum(channel(1:a-1))*Ts;
            time(packetCounter,n) = holder+Tbit;
            holder = time(packetCounter,n);
            if n ~=1
                if time(packetCounter,n) < time(packetCounter,n-1)
                    teste = 1;
                end
            elseif n == 1 && packetCounter  ~= 1
                if time(packetCounter,n) < time(packetCounter-1,n)
                    teste = 1;
                end
            end
            n = n+1;
            if n == (Nbits+1)
                break;
            end
        end
        state = ~state;
        a = a+1;
        %holder = holder + sum(channelTime(stop+1:a-1));
        %holder = holder + (Ts/Tbit)*Ts;
        stop = a-1;
        if a-1 > size(channelTime,1)
            break;
        end
    end
%     if state == idle
%        a = a+1;
%        state = ~state;
%     end
    if a <= size(channel,1)
        if(state == idle)
            holder = holder + channelTime(a-1);
            a = a+1;
            state = ~state;
            %holder = holder + sum(channelTime(stop+1:a-1));
            stop = a-1;
        end
    end
    packetCounter = packetCounter + 1;
end
bit = bit(1:end-1,:);
bit = [bit(:,1),fliplr(bit(:,2:end))];
time = time(1:end-1,:);
end