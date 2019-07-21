function appendix = timeAppendixGenerator(sizeOfAppendix, Tbit)
    appendix = zeros(1,sizeOfAppendix);
    for i = 1:sizeOfAppendix
        appendix(i) = i*Tbit;
    end
end