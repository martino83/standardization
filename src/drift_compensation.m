function y = drift_compensation(x,varargin)

% drift correction
nframes = size(x,2);

if nargin > 1
    frame_ref = varargin{1};
else
    frame_ref = nframes;
end

y = x - (x(:,frame_ref) - x(:,1))*((1:nframes) - 1)./(nframes-1);