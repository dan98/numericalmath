function [] = println(arrlong, arre)
  str = '';
  for i=1:length(arrlong);
    if i > 1
      str = strcat(str, ' ');
    end
    if arrlong(i) ~= 0
      if (isreal(arrlong(i)) && rem(arrlong(i), 1) == 0)
        str = strcat(str, sprintf('%10s', sprintf(' %d', arrlong(i))));
      else
        str = strcat(str, sprintf('%10s', sprintf(' %.10f', arrlong(i))));
      end
    end
  end

  for i=1:length(arre);
    if (i > 1) || length(arrlong > 0)
      str = strcat(str, sprintf(' '));
    end
    if arre(i) ~= 0
      str = strcat(str, sprintf('%10s', sprintf(' %.3e' , arre(i))));
    end;
  end 
  str = strcat(str, ' \\');
  disp(str);
end
