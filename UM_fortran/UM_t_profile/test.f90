program test

  implicit none
  integer :: i, j
  real, dimension(8) :: press
  real, dimension(5) :: cos_theta_longitude
  real, dimension(1) :: cos_theta_latitude

  real :: newtonian_timescale, log_sigma, T_night, T_day, T_eq


  press(1)=1.0e1
  press(2)=1.0e2
  press(3)=1.0e3
  press(4)=1.0e4
  press(5)=1.0e5
  press(6)=1.0e6
  press(7)=1.0e7
  press(8)=1.0e8

  !press(1)=9.0e5
  !press(2)=1.0e6
  !press(3)=2.0e6
  !press(4)=3.0e6
  !press(5)=4.0e6
  !press(6)=5.0e6
  !press(7)=1.0e7
  !press(8)=2.0e7

  cos_theta_latitude(1)=1.0
  cos_theta_longitude(1)=1.0
  cos_theta_longitude(2)=-0.70710678118
  cos_theta_longitude(3)=0.0
  cos_theta_longitude(4)=-1.0


do j=1, 4

  do i=1, 8



     log_sigma=log10(press(i)/1.0e5)

     if (press(i) <= 1.0e6) then
        ! If the pressure gets too low cap the temperature
        ! at the temperature for the 0.1Pa point
        if (press(i) < 0.1)       &
             & log_sigma=log10(0.1/1.0e5)
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
        T_day=(2149.9581+4.1395571*(log_sigma) &
             &  -186.24851*(log_sigma**2.0)    &
             &  +135.52524*(log_sigma**3.0)    &
             &  +106.20433*(log_sigma**4.0)    &
             &  -35.851966*(log_sigma**5.0)    &
             &  -50.022826*(log_sigma**6.0)    &
             &  -18.462489*(log_sigma**7.0)    &
             &  -3.3319965*(log_sigma**8.0)    &
             &  -0.30295925*(log_sigma**9.0)   &
             &  -0.011122316*(log_sigma**10.0))
     else
        T_night=(5529.7168-6869.6504*log_sigma &
             &  +4142.7231*(log_sigma**2.0)    &
             &  -936.23053*(log_sigma**3.0)    &
             &  +87.120975*(log_sigma**4.0))  
        T_day=T_night
     end if

     if (cos_theta_longitude(j) <= 0.0) then 
        T_eq=((T_night**4.0 - (T_day**4.0 - T_night**4.0)  &
             & *cos_theta_longitude(j)  &
             & *cos_theta_latitude(1))**0.25)             
     else 
        T_eq=T_night
     end if

     newtonian_timescale=1.0/(10.0**(5.4659686+1.4940124*log_sigma&
          +0.66079196*(log_sigma**2.0)+0.16475329*(log_sigma**3.0)&
          +0.014241552*(log_sigma**4.0)))


   print*,  acos(cos_theta_longitude(j))*360.0/(2.0*3.1415925), press(i)/1.0e5, T_night, T_day, T_eq


  end do
   print*,'-------------------------------------'

end do



end program test
