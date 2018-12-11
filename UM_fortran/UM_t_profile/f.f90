program f
implicit none

real :: log_sigma, p, T_night

print*, 'Please enter the required pressure (Pa)'
read(*,*) p

log_sigma=log10(p/1.0e5)

T_night=(1388.2145+267.66586*log_sigma &
     &  -215.53357*(log_sigma**2.0)    &
     &  +61.814807*(log_sigma**3.0)    &
     &  +135.68661*(log_sigma**4.0)   &
     &  +2.0149044*(log_sigma**5.0)    &
     &  -40.907246*(log_sigma**6.0)    &
     &  -19.015628*(log_sigma**7.0)    &
     &  -3.8771634*(log_sigma**8.0)    &
     &  -0.38413901*(log_sigma**9.0)   &
     &  -0.015089084*(log_sigma**10.0))     
print*, T_night

end program f
