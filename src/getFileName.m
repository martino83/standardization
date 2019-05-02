function fname = getFileName(InPrefix,kk,varargin)
if nargin < 3 || isempty(varargin{1})
    format = '.mhd'; else format = varargin{1}; end

fList = getFileList(InPrefix,format);
fname = fList(kk,:);