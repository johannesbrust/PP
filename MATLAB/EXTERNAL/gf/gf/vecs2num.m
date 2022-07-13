% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)

function num=vecs2num(vs,z)

num=zeros(1,size(vs,2));
for id=size(vs,1):-1:2
    num=num+double(vs(id,:));
    num=num*z;
end
num=num+double(vs(1,:));
