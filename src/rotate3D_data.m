function [x1,y1,z1] = rotate3D_data(x,y,z,theta_x,theta_y,theta_z)

% 3D rotation around the origin
R_x = [1 0 0;...
    0 cos(theta_x) -sin(theta_x);...
    0 sin(theta_x) cos(theta_x)];

R_y = [cos(theta_y) 0 sin(theta_y);...
    0 1 0;...
    -sin(theta_y) 0 cos(theta_y)];

R_z = [cos(theta_z) -sin(theta_z) 0;...
    sin(theta_z) cos(theta_z) 0;...
    0 0 1];

R = R_z * R_y * R_x;
xyz = [x(:)';y(:)';z(:)'];
xyz1 = R * xyz;
x1 = xyz1(1,:)';
y1 = xyz1(2,:)';
z1 = xyz1(3,:)';

x1 = reshape(x1,size(x));
y1 = reshape(y1,size(x));
z1 = reshape(z1,size(x));

% plot3(x1,y1,z1,'b.');
% xlabel('x');
% ylabel('y');
% zlabel('z');
% 
% hold on
% 
% plot3(x,y,z,'r.');
% xlabel('x');
% ylabel('y');
% zlabel('z');
% 
% debug();