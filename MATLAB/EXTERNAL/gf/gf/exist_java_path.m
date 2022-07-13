% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)

function flag=exist_java_path(p)
           s=javaclasspath;
           x=strvcat(s)';
           s=x(:)';
           
           if isempty(findstr(s,p))
               flag=0;
           else
               flag=1;
           end
       end
