% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)

function num=vec2num(v,z)

num=0;
for id=length(v):-1:2
    num=num+v(id);
    num=num*z;
end
num=num+v(1);
