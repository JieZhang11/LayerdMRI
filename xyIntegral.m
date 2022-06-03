%% integrate the spherical harmonic function of tangential plane
function amp = xyIntegral(n,coef)
    theta=pi/2;
    index=2;
    amp=0;
    for l=0:2:n
        index=index+2*l-1;
        P=legendre(l,cos(theta));
        m=0;
        temp=sqrt((2*l+1)/(4*pi) * factorial(l-abs(m))/factorial(l+abs(m))); %* exp(1i*m*phi);
        amp=amp+coef(index)*temp* P(m+1);
    end