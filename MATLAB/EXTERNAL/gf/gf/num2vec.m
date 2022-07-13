% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)

function v=num2vec(i,z,n)

res=i;
for id=1:n
    v(id)=mod(res,z);
    res=floor(res/z);
end