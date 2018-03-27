function [sem] = nansem(input)

if size(input,1) > 1
    sem = nanstd(input) ./ sqrt(size(input,1));
else
    sem = nanstd(input) ./ sqrt(length(input));
end

end

