% setup class path for java library
    % avoid java clear warning
   
           warning off;
           if ~exist_java_path('gf.jar')
               clear import
               javarmpath gf.jar
           end
           javaaddpath('./gf.jar');
           warning on;