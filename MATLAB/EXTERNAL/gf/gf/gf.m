%
% A GF class for simple GF manipulations
%
% % create gf class of 3^2
% fprintf('Create GF(3^2):');
% gf9=gf(3,2); 
% 
% %%%%
% % Eg. 1
% a=[2 1;1 0]
% 
% % compute rank
% fprintf('\nCompute Rank:');
% fprintf('Rank of a = %d\n',gf9.rank(a)); % return rank
% 
% % compute inverse
% fprintf('\nCompute a inverse:')
% inva = gf9.inv(a)
% 
% % Check inverse
% fprintf('\nCheck inverse (a * inva):');
% a_times_ainva=gf9.mult(a,inva)
% 
% % matrix divide
% fprintf('\nCompute a / a:');
% gf9.div(a,a)
% 
% %%%%%
% % Eg. 2
% b=[1 2 1;1 0 1];
% 
% % compute summation
% fprintf('\nCompute b + b:');
% gf9.add(b,b)
% 
% % compute subtraction
% fprintf('\nCompute b - b:');
% gf9.sub(b,b)
% 
% % compute dot multiplication
% fprintf('\nCompute b .* b:');
% gf9.dmult(b,b)
% 
% % compute dot division
% fprintf('\nCompute b ./ b:');
% gf9.ddiv(b,b)
% 
% 
% Written by Samuel Cheng (Sept 13, 2011)
%
% if you need to contact me, just google :)


classdef gf
   properties
       p=2;
       n=0;
       ply=0;
       gfmt=[];
       gfat=[];
       gfdt=[];
       gfst=[];
       ply_reps=[];
       gf_java=[];
   end
   methods
       function obj=gf(p,n,ply)
           if ~isprime(p)
               error('p needs to be prime');
           end
           obj.p=p;
           obj.n=n;
           if ~exist('ply','var')
               obj.ply=find_irreducible_poly(p,n);
           else
               obj.ply=ply;
               if ~is_irreducible(ply,p,n)
                   error('The input vector is not irreducible');
               end
           end
           [gfat,gfst,gfmt,gfdt,ply_reps]=build_tables(obj);
           obj.gfmt=gfmt;
           obj.gfat=gfat;
           obj.gfdt=gfdt;
           obj.gfst=gfst;
           obj.ply_reps=ply_reps;
           
           import gf.*
           obj.gf_java=GF_java(gfat,gfmt,gfst,gfdt);
       end
       
       function check_error(obj,a)
           if length(size(a))>2
               error('input can only be matrix/vector/scalar');
           end
           if ~isempty([find(a >=obj.p^obj.n) find(a <0)])
               error('input is out of bound')
           end
           b=abs(round(a)-a);
           if sum(b(:)) ~=0
               error('input cannot be fractional');
           end
       end
       
       function r=rank(obj,a)
           check_error(obj,a);
           r=obj.gf_java.rank(a);
       end
       
       function c=mult(obj,a,b)
           check_error(obj,a);
           check_error(obj,b);
           if (size(a,2)~=size(b,1))
               error('number of columns of first input has to be equal to number of rows of second input');
           end
           c=obj.gf_java.mat_mult(a,b);
       end
       
       function c=dmult(obj,a,b)
           check_dim(obj,a,b);
           check_error(obj,a);
           check_error(obj,b);
           c=obj.gf_java.mat_dot(a,b);
       end
       
       function c=ddiv(obj,a,b)
           check_dim(obj,a,b);
           check_error(obj,a);
           check_error(obj,b);
           c=obj.gf_java.mat_dotdiv(a,b);
       end
       
       function c=conv(obj,a,b)
           check_error(obj,a);
           check_error(obj,b);
           c=obj.gf_java.vec_conv(a,b);
           c=c(:)';
       end
       
       function [q,rem]=deconv(obj,b,a);
           check_error(obj,a);
           check_error(obj,b);
           o=obj.gf_java.vec_deconv(b,a);
           q=o(1);
           rem=o(2);
           q=q(:)';
           rem=rem(:)';
       end
       
       
       function c=add(obj,a,b)
           check_dim(obj,a,b);
           check_error(obj,a);
           check_error(obj,b);
           c=obj.gf_java.mat_add(a,b);
       end
       
       function c=sub(obj,a,b)
           check_dim(obj,a,b);
           check_error(obj,a);
           check_error(obj,b);
           c=obj.gf_java.mat_sub(a,b);
       end
       
       function c=div(obj,a,b)
           check_dim(obj,a,b);
           check_error(obj,a);
           check_error(obj,b);
           binv=inv(obj,b);
           if (sum(binv(:))==0)
               error('second argument is not invertible');
           end
           c=obj.gf_java.mat_mult(a,binv);
       end
       
       function p=return_primitive_polynomial(obj)
           p=obj.ply;
       end
       
       function ainv=inv(obj,a)
           check_error(obj,a);
           if (size(a,1)~=size(a,2))
               error('input should be a square matrix');
           end
           ainv=obj.gf_java.inverse(a);
           if (sum(ainv(:))==0)
               error('input is not invertible');
           end
       end
       
       function check_dim(obj,a,b)
          if length(size(a))~=length(size(b))
              error('dimension of input does not match');
          end
          if sum(abs(size(a)-size(b)))~=0
              error('dimension of input does not match');
          end
       end
       function ply=return_poly_representation(obj,i)
           if ~exist('i','var')
               error('Function needs at least one input');
           end
           if (i>=obj.p^obj.n)
               error('Input index is too large');
           end
           if (i <0)
               error('Input index is too small');
           end
           if ((round(i)-i)~=0)
               error('Input index should be integer');
           end
           ply=obj.ply_reps{i+1};
       end
       function [gfat,gfst,gfmt,gfdt,ply_reps]=build_tables(obj)
           p=obj.p;
           n=obj.n;
           gfst=zeros(p^n);
           gfmt=zeros(p^n);
           gfat=zeros(p^n);
           gfdt=zeros(p^n);
           for id1=0:p^n-1
               v1=fliplr(num2vec(id1,p,n));
               ply_reps{id1+1}=v1;
               for id2=id1:p^n-1
                   v2=fliplr(num2vec(id2,p,n));
                   [dummy,rem]=deconv(conv(v1,v2),obj.ply);
                   pd=vec2num(fliplr(mod(rem,p)),p);
                   sm=vec2num(fliplr(mod(v1+v2,p)),p);
                   gfmt(id1+1,id2+1)=pd;
                   gfmt(id2+1,id1+1)=pd;
                   gfat(id1+1,id2+1)=sm;
                   gfat(id2+1,id1+1)=sm;
                   gfdt(pd+1,id1+1)=id2;
                   gfdt(pd+1,id2+1)=id1;
                   gfst(sm+1,id1+1)=id2;
                   gfst(sm+1,id2+1)=id1;
               end
           end
           % rlabel indices 
%            olabels=gfmt(3,:);
%            nlabels=[0 2:p^n-1 1]; % desired labeling (1=1, 2=a 3=a^2,...)
%            gfmt=rlabel(gfmt,olabels,nlabels);
%            gfat=rlabel(gfat,olabels,nlabels);
%            gfdt=rlabel(gfdt,olabels,nlabels);
%            gfst=rlabel(gfst,olabels,nlabels);
           % check tables
           assert(mean(sum(gfat))==sum(1:p^n-1));
           assert(mean(sum(gfst))==sum(1:p^n-1));
           sm=sum(gfmt);
           assert(mean(sm(2:length(sm)))==sum(1:p^n-1));
           sm=sum(gfdt);
           assert(mean(sm(2:length(sm)))==sum(1:p^n-1));
       end
       
   end
end