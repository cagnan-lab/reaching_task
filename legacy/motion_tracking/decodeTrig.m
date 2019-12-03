function tcode = decodeTrig(tarTrig)
for i = 1:size(tarTrig,2)
    X = tarTrig(:,i);
    if sum(X)>1
        tcode(i) = 1;
    elseif sum(X) == 0
        tcode(i) = 2;
    else
        tcode(i) = find(X)+2;
    end
end