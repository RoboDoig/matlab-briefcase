function [y] = normalise(x)
%NORMALISE Normalises a vector

y = (x - min(x)) / (max(x) - min(x));

end

