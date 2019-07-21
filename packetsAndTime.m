function [bit] = packetsAndTime(channel, initial_bit, sampleRate, Nbits, idle, Tbit, N_bits_idle)

    %%%%%%%%%%%%%%%%%%%%%%%%%% PART 0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Seeking for the first Start Bit
    index = 1;
    Ts = 1/sampleRate;
    current_bit = initial_bit;
    keep_seeking = 1;
    while(keep_seeking)
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
    
    %%%%%%%%%%%%%%%%%%%%%%% PART 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Montar Tsvec
    Tsvec = 1:Nbits;
    for n = 1:Nbits
        Tsvec(n) = round(((n-1)+0.5)*Tbit/Ts); % Number of samples before each bit initialization
    end
    while(packetCounter <= size(channel,1))
        summation = 0;
        %%%%%%%%%%%%%%%%%%%%%%%% PART 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Montar os pacotes
        n = 1;
        state = current_bit; 
        
        while(n <= Nbits)
            if a >= size(channel,1);
                break;
            end
            summation = summation + channel(a);
            while(summation >= Tsvec(n))
                bit(packetCounter,n) = state;
                n = n+1;
                if n == (Nbits+1)
                    break;
                end
            end
            state = ~state;
            a = a+1;
        end
    packetCounter = packetCounter + 1;
    end    
end