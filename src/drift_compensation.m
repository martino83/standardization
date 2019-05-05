function y = drift_compensation(x)

% drift correction
nframes = size(x,2);
y = x - x(:,end)*((1:nframes) - 1)./(nframes-1);