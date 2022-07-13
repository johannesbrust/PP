function java_path_setup_FUNC(external_path)
% java_path_setup_FUNC function to set path to finite field library
%
% Used as part of generating extended pooling matrices
% 
%--------------------------------------------------------------------------
% 01/27/22, J.B., Initial implementation

addpath(external_path);

warning off; %#ok<*WNOFF>
if ~exist_java_path('gf.jar')
    clear import
    javarmpath gf.jar
end
javaaddpath([external_path,'/gf.jar']);
warning on; %#ok<WNON>
end