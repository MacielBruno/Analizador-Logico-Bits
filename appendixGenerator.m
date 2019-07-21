function appendix = appendixGenerator(appendixSize,lastChannelTime,maximumTime)
    appendix = zeros(appendixSize,1);
    for i = 1:appendixSize
        appendix(i) = i;
    end
    appendix = appendix*(maximumTime - lastChannelTime)/(appendixSize)+lastChannelTime;
end