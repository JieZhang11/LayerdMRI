%% Convert cartesian coordinates to spherical coordinates
function [az,elev,r] = cart2sph_(x,y,z)

hypotxy = hypot(x,y);
r = hypot(hypotxy,z);
elev = atan2(hypotxy,z);
az = atan2(y,x);
