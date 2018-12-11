program hd209_test

  implicit none

  integer :: k, j, i
  integer, parameter :: model_levels=15, rows=7, row_length=12
  real :: log_sigma, T_night, T_day, temp2, newtonian_timescale
  real, dimension(row_length,rows,model_levels) :: p_theta_levels,exner_theta_levels, theta_star, theta_eq
  real, dimension(row_length, rows) :: cos_theta_longitude, cos_theta_latitude
  logical :: implicit
  real :: timestep ! In seconds
  integer :: timestep_number
  real :: days
  ! The minimum timescales for day and night
  ! therefore the max 1.0/time_rad
  real :: t_rad_max_night, t_rad_max_day, newt_raw
! Contrast between day and night side
  real :: contrast
  real, parameter :: kappa=0.321
  real :: dummy

  print*, 'This program is used to explore the temperature forcing for HD209458b'
  print*, 'The UM code must be copied from force_exo.F90'

  print*, 'Please enter the number of days into the simulation you want'
  read(*,*) days
  ! Assume 120s timestep
  timestep=120
  ! Calculate timestep_number
  timestep_number=int(days*24.0*60.0*60.0/timestep)
  !  print*, 'Please enter the timestep? (s) of the simulation'
  !  read(*,*) timestep


  ! Setup a dummy enviroment
  cos_theta_latitude(:,1)=0.0   ! -90
  cos_theta_latitude(:,2)=0.5   ! -60
  cos_theta_latitude(:,3)=0.866 ! -30
  cos_theta_latitude(:,4)=1.0   !  0
  cos_theta_latitude(:,5)=0.866 ! 30
  cos_theta_latitude(:,6)=0.5   ! 60
  cos_theta_latitude(:,7)=0.0   ! 90




  cos_theta_longitude(1,:)=1.0     ! 0
  cos_theta_longitude(2,:)=0.866   ! 30
  cos_theta_longitude(3,:)=0.5     ! 60
  cos_theta_longitude(4,:)=0.0     ! 90
  cos_theta_longitude(5,:)=-0.5    ! 120
  cos_theta_longitude(6,:)=-0.866  ! 150
  cos_theta_longitude(7,:)=-1.0    ! 180
  cos_theta_longitude(8,:)=-0.866  ! 210
  cos_theta_longitude(9,:)=-0.5    ! 240
  cos_theta_longitude(10,:)=0.0    ! 270
  cos_theta_longitude(11,:)=0.5    ! 300
  cos_theta_longitude(12,:)=0.866  ! 330

  p_theta_levels(:,:,1)=220.0e5  ! 220 bar
  p_theta_levels(:,:,2)=100.0e5  ! 100 bar
  p_theta_levels(:,:,3)=10.0e5   ! 10 bar
  p_theta_levels(:,:,4)=1.0e5    ! 1 bar
  p_theta_levels(:,:,5)=1.0e4    ! 0.1 bar
  p_theta_levels(:,:,6)=1.0e3    ! 10 millibar
  p_theta_levels(:,:,7)=1.0e2    ! 1 millibar
  p_theta_levels(:,:,8)=10.0     ! 100 micro bar
  p_theta_levels(:,:,9)=1.0      ! 10 micro bar
  p_theta_levels(:,:,10)=0.1     ! 1 micro bar
  p_theta_levels(:,:,11)=0.01    ! 0.1 micro bar
  p_theta_levels(:,:,12)=0.001   ! 0.001 micro bar
  p_theta_levels(:,:,13)=0.0001  ! 0.0001 micro bar
  p_theta_levels(:,:,14)=0.00001 ! 0.00001 micro bar
  p_theta_levels(:,:,15)=0.000001! 0.000001 micro bar

  write(89,*)  '220.0e5 = 220 bar'
  write(89,*)  '100.0e5 = 100 bar'
  write(89,*)  '10.0e5  = 10 bar'
  write(89,*)  '1.0e5   = 1 bar'
  write(89,*)  '1.0e4   = 0.1 bar'
  write(89,*)  '1.0e3   = 10 millibar'
  write(89,*)  '1.0e2   = 1 millibar'
  write(89,*)  '10.0    = 100 micro bar'
  write(89,*)  '1.0     = 10 micro bar'
  write(89,*)  '0.1     = 1 micro bar'
  write(89,*)  '0.01    = 0.1 micro bar'
  write(89,*)  '0.001   = 0.001 micro bar'
  write(89,*)  '0.0001  = 0.0001 micro bar'
  write(89,*)  '0.00001 = 0.00001 micro bar'
  write(89,*)  '0.000001= 0.000001 micro bar'


  ! kappa=0.321 for HD209458b and P_o=220bar
  do k=1, model_levels
     do j=1, rows
        do i=1, row_length
           exner_theta_levels(i,j,k)=(p_theta_levels(i,j,k)/220.0e5)**0.321  
           ! Start isothermal
           theta_star(i,j,k)=1575.0/exner_theta_levels(i,j,k)
        end do
     end do
  end do
  
  ! not using time implicit
  implicit=.false.

print*, 'Pressure(Pa), Exner Pressure, P_tilda, T_night, T_day, T_eq'

!*************************************UM_CODE*************************************

  Do k = 1, model_levels
     Do j = 1, rows
        Do i = 1, row_length
           ! First construct the pressure variable
           ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
           log_sigma=log10(p_theta_levels(i,j,k)/1.0e5)
           ! The night and day side temperature profile polynomial fits
           ! from Heng et al (2011)
           ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
           ! P<=10bar, (1.0e6 pascals)
           if (p_theta_levels(i,j,k) <= 1.0e6) then
              ! If the pressure gets too low cap the temperature
              ! at the temperature for the 0.1Pa point
             if (p_theta_levels(i,j,k) < 0.1)       &
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
           ! Now apply the temperature, dependent on the location
           ! Note there is an error in Heng et al (2011) Eqn 26
           ! 90<phi<270 should be 90<theta<270
           ! Day side is 90<theta(longitude)<270
           ! Therefore, cos_theta_longitude <=0 
           ! Again using potential temperature so convert by /exner
           if (cos_theta_longitude(i,j) <= 0.0) then 
              contrast=1
              temp2=((T_night**4.0 - contrast*(T_day**4.0 - T_night**4.0)  &
                   & *cos_theta_longitude(i,j)  &
                   & *cos_theta_latitude(i,j))**0.25) &
                   & / exner_theta_levels(i,j,k) 
 !print*, temp2*exner_theta_levels(i,j,k)

           else 
              temp2=T_night / exner_theta_levels(i,j,k)
           end if
           theta_eq(i,j,k) = temp2 
       End Do
     End Do
! NOT UM!!!
     print*, p_theta_levels(7,1,k), exner_theta_levels(7,1,k), log_sigma, T_night, T_day, theta_eq(7,1,k)*exner_theta_levels(7,1,k)
!!!!!
  End Do

! NOT UM
write(71,*) 'Hot Spot'
write(71,*) 'Pressure(Pa), Exner Pressure, P_tilda, cos_theta_longitude, cos_theta_latitude, t_relax(s)'
write(72,*) 'Terminator'
write(72,*) 'Pressure(Pa), Exner Pressure, P_tilda, cos_theta_longitude, cos_theta_latitude, t_relax(s)'
write(73,*) 'Cool side'
write(73,*) 'Pressure(Pa), Exner Pressure, P_tilda, cos_theta_longitude, cos_theta_latitude, t_relax(s)'
print*, 'Pressure(Pa), Exner Pressure, P_tilda, t_relax(s)'
!!!!!

  Do k = 1, model_levels
     Do j = 1, rows
        Do i = 1, row_length
           ! First construct the pressure variable
           ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
           log_sigma=log10(p_theta_levels(i,j,k)/1.0e5)
           ! Different for P<10bar i.e 1.0e6 Pa
           ! Recall variable given as log(T_rad) in Heng et al (2011)
           ! Also we need 1/T_rad, s^-1
           ! Heng et al (2011) States that the fit for relaxation time
           ! is valid for 10 microbar (1Pa) <P<8.5bar (8.5e5Pa)
           ! I am not sure what this means you should do between 
           ! 8.5 and 10 bar????***
           if (p_theta_levels(i,j,k) <1.0e6) then
              ! If the pressure gets to low cap the relaxation time
              ! at the value at 10microbar
              if (p_theta_levels(i,j,k) < 1.0) &
                   &log_sigma=log10(1.0/1.0e5)
              newtonian_timescale=1.0/(10.0**(5.4659686+1.4940124*log_sigma        &
                   & +0.66079196*(log_sigma**2.0)+0.16475329*(log_sigma**3.0) &
                   & +0.014241552*(log_sigma**4.0)))
           else
              newtonian_timescale=0.0
           end if

           dummy=theta_star(i,j,k)
           theta_star(i,j,k) = theta_star(i,j,k) - timestep *        &
                &                                    newtonian_timescale *         &
                &                           (theta_star(i,j,k) - theta_eq(i,j,k))              
           if (newtonian_timescale /=0.0) write(36,*) dummy-theta_star(i,j,k), p_theta_levels(i,j,k)
           theta_star(i,j,k) = ((theta_star(i,j,k) - timestep *        &
                &                                    newtonian_timescale *         &
                &                           (theta_star(i,j,k) - theta_eq(i,j,k)))/&
                (theta_star(i,j,k)**kappa))**(1.0/(1.0-kappa))
           if (newtonian_timescale /=0.0) write(37,*) dummy-theta_star(i,j,k), p_theta_levels(i,j,k)
           
           
           
    if (cos_theta_longitude(i,j)==-1.0) then
        write(71,*) p_theta_levels(i,j,k), exner_theta_levels(i,j,k), log_sigma,&
             cos_theta_longitude(i,j),cos_theta_latitude(i,j),&
             1.0/newtonian_timescale,(1.0/newtonian_timescale)/(60.0*60.0*24.0)
     else if (cos_theta_longitude(i,j)==0.0) then
        write(72,*) p_theta_levels(i,j,k), exner_theta_levels(i,j,k), log_sigma,&
             cos_theta_longitude(i,j),cos_theta_latitude(i,j),&
             1.0/newtonian_timescale,(1.0/newtonian_timescale)/(60.0*60.0*24.0)
     else if (cos_theta_longitude(i,j)==1.0) then
        write(73,*) p_theta_levels(i,j,k), exner_theta_levels(i,j,k), log_sigma,&
             cos_theta_longitude(i,j),cos_theta_latitude(i,j),&
             1.0/newtonian_timescale,(1.0/newtonian_timescale)/(60.0*60.0*24.0)
     endif
!!!!!
        End Do
     End Do
      !  print*, p_theta_levels(1,1,k), exner_theta_levels(1,1,k), log_sigma,&
      !       1.0/newt_raw,(1.0/newt_raw)/(60.0*60.0*24.0)
     print*, p_theta_levels(1,1,k), exner_theta_levels(1,1,k), log_sigma,&
          1.0/newtonian_timescale,(1.0/newtonian_timescale)/(60.0*60.0*24.0)

  End Do
 

!*************************************UM_CODE*************************************
  
end program hd209_test
