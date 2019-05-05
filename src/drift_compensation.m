<<<<<<< HEAD
function y = drift_compensation(x,varargin)

% drift correction
nframes = size(x,2);

if nargin > 1
    frame_ref = varargin{1};
else
    frame_ref = nframes;
end

y = x - (x(:,frame_ref) - x(:,1))*((1:nframes) - 1)./(nframes-1);
=======
function y = drift_compensation(x)

% drift correction
nframes = size(x,2);
y = x - x(:,end)*((1:nframes) - 1)./(nframes-1);
>>>>>>> 8702a620ad45dbd2b911877a9a2e2521418ded74
