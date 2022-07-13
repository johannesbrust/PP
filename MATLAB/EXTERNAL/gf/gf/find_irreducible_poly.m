% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)

function pn=find_irreducible_poly(p,n)

for cid=1:p^(n)
   candidate=num2vec(cid,p,n+1);
   candidate(n+1)=1; 
   candidate=fliplr(candidate);
   
   if (is_irreducible(candidate,p,n)==0)
       continue; % find next one
   else
       pn=candidate;
       return;
   end
end

