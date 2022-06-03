function amp = SphHarmonic(n,dir,coef)
    theta=dir(:,2);
    phi=dir(:,1);
    index=1;
    amp=0;
    for l=0:2:n
        P=legendre(l,cos(theta));
        for m=-l:l
            temp=sqrt((2*l+1)/(4*pi) * factorial(l-abs(m))/factorial(l+abs(m))); %* exp(1i*m*phi);
            if (m==0)
                amp=amp+coef(index)*temp* P(m+1);
                index=index+1;
            end
            if (m>0)
                amp=amp+sqrt(2)*coef(index)*temp * P(m+1)*cos(m*phi);
                index=index+1;
            end
            if (m<0)
                fm=-m;
                amp=amp+sqrt(2)*coef(index)*temp * P(fm+1)*sin(fm*phi);
                index=index+1;
            end
        end
    end