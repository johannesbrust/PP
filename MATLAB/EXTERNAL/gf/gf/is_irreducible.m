% 
% Check if a polynomial is irreducible
% 
% is_irreducible(poly,p,n) returns 1 if poly is not divisible by any polynomial of the form 
% a1 + a2 x + a3 x^2 ... + an x^(n-1), where a1,a2,...,an is in Z_p,
% otherwise the function returns 0.
%
% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)


function flag=is_irreducible(c,p,n)

flag=1;
for fid=p:p^n-1
    factor=fliplr(num2vec(fid,p,n));
    factor=remove_leading_zeros(factor);
    
    [dummy,rem]=deconv(c,factor);
    if(sum(mod(rem,p))==0)
      flag=0;
      return;
    end
end

function factor=remove_leading_zeros(f)

id=find(f~=0);
factor=f(id(1):length(f));