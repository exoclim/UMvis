program um_t_profile
  implicit none
  ! This program is used to check the temperature forcing in the UM

  ! The number of latitudes, longitudes and model levels
  integer, parameter :: row_length=13, rows=7, model_levels=32
  real  :: Earth_radius
  ! Which benchmark
  ! 1=HS, 2=TLE, 3=EL, 4=SHJ, 5=HD209458b
  integer :: exo_benchmark_switch 
  integer, parameter :: exo_hd=1, exo_tle=2, exo_el=3, exo_shjup=4, exo_hd209458b_bench=5, no_exo=0, me=0
  ! Variables for temperature equations
  real :: temp1, temp2, recip_kappa, kappa
  real, parameter :: SuHe_pole_equ_deltaT=60., SuHe_static_stab=10.
  real, parameter :: pi=3.14159265
  ! Local Variables required for Exo-Planetary Benchmarks
  ! Added by NJM 12/2011
  ! Height of tropopause in pressure (coordinates)
  real :: sigma_strat
  ! Vertical pressure coordinate
  real :: sigma
  ! The horizontal temperature gradient in tropospheric region
  real :: beta_trop
  ! Location of the top of the stratosphere in the Vertical grid
  integer :: strat_loc
  ! Height of tropopause in metres 
  real :: z_strat
  ! The Lapse rate or vertical temperature gradient in troposphere
  ! K /m
  real :: gamma_trop
  ! The Tropopause temperature increment 
  ! K /m
  real :: delta_T_strat
  ! Temperature of the stratosphere, and surface, equator to pole diff and T_vert
  real :: T_strat, T_surf, delta_T_eq_pole, T_Vert
  ! Variables to construct the Temperature profile for HD209458b Benchmark
  ! Night side, day side and the Temperature in Iro et al (2005)
  real :: T_night, T_day, T_iro
  ! The log(P/1bar) variable for polynomial fit
  real :: log_sigma
  ! Loop variables 
  integer :: i,j,k, ios
  ! which type of printout  
  integer :: print_type, nlat, nlon, npres
  real, dimension(row_length) :: longitude
  real, dimension(rows) :: latitude
  ! The fields think row_length=nlong rows =nlat
  real, dimension(row_length,rows, model_levels) :: exner_theta_levels
  real, dimension(row_length,rows) :: sin_theta_latitude     
  real, dimension(row_length,rows) :: cos_theta_longitude
  real, dimension(row_length,rows) :: cos_theta_latitude
  real, dimension(row_length,rows, model_levels) :: theta_eq
  real, dimension(row_length,rows, model_levels) :: p_theta_levels
  real, dimension(row_length,rows, model_levels) :: r_theta_levels
  real, dimension(row_length,rows, model_levels) :: theta, theta_star
  real, dimension(model_levels) :: theta_ref
  real, dimension(row_length,rows) :: p_star
  ! The desired sigma coverage and those for the setup (can't extend to 1.0)
  real, dimension(model_levels) :: sigma_req, sigma_set
  real, dimension(model_levels) :: r_theta_levels_set, eta_rho_out
  real, dimension(model_levels+1) :: eta_theta_out
  character(len=100), dimension(model_levels+1) :: eta_theta_format
  character(len=100), dimension(model_levels) :: eta_rho_format
  ! Testing setup (1) or forcing (2)
  integer :: which
  integer :: iso_int
  ! Variables to check relaxation time
  real :: timestep, newtonian_timescale
  ! Variables for the setup wrapper
  real :: p_surface, theta_surface, exner_surface, minusgoverRTref, p_zero
  real, dimension(model_levels) :: sigma_ref, sigma_to_kappa
  logical :: set_smooth
  character(len=100) :: lev_name, write_string
  real :: sig_step, sig_step_set
  real :: g, R, cp, static_stab
  logical :: L_isothermal
  integer :: max_val, n
  ! Stuff for uneven sigma levels
  real :: A, B, C, eta_hat, eta

  ! The output model levels are smoothed to integers
  set_smooth=.true.

  get_do: do
     print*, 'Would you like to test the UM:'
     print*, '1, Setup'
     print*, '2, Forcing'
     print*, 'Enter 1 or 2'
     read(*,*) which
     if (which ==1 .or. which ==2) exit get_do
  end do get_do
  get_do2: do
     print*, 'Which benchmark temperature forcing would you like to test?'
     print*, '1=HS, 2=TLE, 3=EL, 4=SHJ, 5=HD209458b'
     read(*,*) exo_benchmark_switch
     if (exo_benchmark_switch <1 .or. exo_benchmark_switch >5) cycle get_do2
     exit get_do2
  end do get_do2

  ! Setup the environment parameters
  ! Set in earth_constants and atmos_constants
  ! Check_idealise of dynamically by the UM
  ! Default earth options
  R=287.04
  cp=1004.64
  p_surface=1.0e5
  g=9.80
  theta_surface=264.0
  Earth_radius=6371229.0
  if (exo_benchmark_switch == exo_shjup) then
     cp=13226.5
     R=3779.0
     theta_surface=1800.0
     g=8.0
     Earth_radius=1.0e8
  end if
  if (exo_benchmark_switch == exo_hd209458b_bench) then
     cp=14308.4
     R=4593.0
     p_surface=220.0e5
     theta_surface=1575.0
     g=9.42
     Earth_radius=9.44e7
  end if
  kappa=R/cp
  recip_kappa=1.0/kappa

  p_star=p_surface
  p_zero=p_surface

  ! Setup the fake arrays
  longitude(1)=0.0
  longitude(2)=30.0
  longitude(3)=60.0
  longitude(4)=90.0
  longitude(5)=120.0
  longitude(6)=150.0
  longitude(7)=180.0
  longitude(8)=210.0
  longitude(9)=240.0
  longitude(10)=270.0
  longitude(11)=300.0
  longitude(12)=330.0
  longitude(13)=360.0
  latitude(1)=-90.0
  latitude(2)=-60.0
  latitude(3)=-30.0
  latitude(4)=0.0
  latitude(5)=30.0
  latitude(6)=60.0
  latitude(7)=90.0

  cos_theta_latitude(:,1)=0.0   ! -90
  cos_theta_latitude(:,2)=0.5   ! -60
  cos_theta_latitude(:,3)=0.866 ! -30
  cos_theta_latitude(:,4)=1.0   !  0
  cos_theta_latitude(:,5)=0.866 ! 30
  cos_theta_latitude(:,6)=0.5   ! 60
  cos_theta_latitude(:,7)=0.0   ! 90



  !cos_theta_latitude(:,1)=0.0   ! -90
  !cos_theta_latitude(:,2)=0.034899   ! -88
  !cos_theta_latitude(:,3)=0.069756 ! -86
  !cos_theta_latitude(:,4)=0.10452846  !  84
  !cos_theta_latitude(:,5)=0.139173 ! 82
  !cos_theta_latitude(:,6)=0.173648   ! 80
  !cos_theta_latitude(:,7)=0.207911   ! 78



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
  cos_theta_longitude(13,:)=1.0    ! 360

  sin_theta_latitude(:,1)=-1.0   ! -90
  sin_theta_latitude(:,2)=-0.866 ! -60
  sin_theta_latitude(:,3)=-0.5   ! -30
  sin_theta_latitude(:,4)=0.0    !  0
  sin_theta_latitude(:,5)=0.5    ! 30
  sin_theta_latitude(:,6)=0.866  ! 60
  sin_theta_latitude(:,7)=1.0    ! 90

  ! Setup pressure levels evenly space in sigma space
  ! From 1.0 to 0.001 and 0.99 0.001 for set levels
  ! 0.001 MAYBE TOO HIGH!!!1
  if (exo_benchmark_switch /= exo_hd209458b_bench) then
     sig_step=(1.0-0.001)/(model_levels-1.0)
     sig_step_set=(0.99-0.001)/(model_levels-1.0)
     do k=1, model_levels
        sigma_req(k)=1.0-(k-1.0)*sig_step
        sigma_set(k)=0.99-(k-1.0)*sig_step_set
     end do
  else
     ! Implement uneven vertical spacing in sigma
     print*, 'Setting up uneven vertical levels'
     print*, 'See appendix A in Heng et al (2011)'
     print*, 'Please enter A (0.1):'
     read(*,*) A
     print*, 'Please enter B (3,1,0.3):'
     read(*,*) B
     print*, 'Please enter C (12.7):'
     read(*,*) C
     do k=1, model_levels
        ! First do the required levels
        eta=0.0+(k-1.0)/(model_levels-1.0)
        eta_hat=A*eta+(1.0-A)*(eta**B)
        sigma_req(k)=exp(-eta_hat*C)
        ! Now for the setup
        eta=0.0+(k-0.99)/(model_levels-1.0)
        eta_hat=A*eta+(1.0-A)*(eta**B)
        sigma_set(k)=exp(-eta_hat*C)
     end do
  end if

  ! setup pressure exner pressure and positions of the z levels
  ! Ideal gas, in hydrostatic equilibrium
  ! Also the set r_theta_levels for the UM
  do k=1, model_levels
     Do j = 1, rows
        Do i = 1, row_length
           p_theta_levels(:,:,k)=sigma_req(k)*p_surface
           r_theta_levels(i,j,k)=-1.0*(log(p_theta_levels(i,j,k)/p_star(i,j))*R*theta_surface)/g
           if (r_theta_levels(i,j,k) <0.0) r_theta_levels(i,j,k)=0.0
           exner_theta_levels(i,j,k)=(p_theta_levels(i,j,k)/p_star(i,j))**(kappa)
        end do
     end do
  end do

  ! Add the Earth's Radius to the R
  r_theta_levels=r_theta_levels+Earth_radius 

  if (which==2) then

     get_type_do: do
        print*, 'Which sort of printout would you like?'
        print*, '1: all lattitudes, longitudes, pressures and derived temperatures'
        print*, '2: Temperature over latitudes for set longitude and pressure/height'
        print*, '3: Temperature over longitude for set latitudes and pressure/height'
        print*, '4: Temperature over Pressure for set latitudes and longitude'
        print*, '5: Temperature at one value of Pressure, Latitude and Longitude'
        print*, '6: Temperature over longitude and lattitude at set pressure'
        read(*,*) print_type
        if (print_type >0 .and. print_type < 7) exit get_type_do
     end do get_type_do

     if (print_type==2 .or. print_type==4 .or. print_type==5) then
        get_lon: do
           print*, ' Please choose a longitude-ENTER THE INTEGER INDEX:'
           do i=1, row_length
              print*, i,':',longitude(i)
           end do
           read(*,*) nlon
           if (nlon <1 .or. nlon > row_length) cycle get_lon
           exit get_lon
        end do get_lon
     end if
     if (print_type==3 .or. print_type==4 .or. print_type==5) then
        get_lat: do
           print*, ' Please choose a latitude-ENTER THE INTEGER INDEX:'
           do j=1, rows
              print*, j,':',latitude(j)
           end do
           read(*,*) nlat
           if (nlat <1 .or. nlat > rows) cycle get_lat
           exit get_lat
        end do get_lat
     end if
     if (print_type==2 .or. print_type==3 .or. print_type==5 .or. print_type==6) then
        get_lev: do
           print*, ' Please choose a Pressure (sigma=P/P_surface):'
           do k=1, model_levels
              print*, k,':',p_theta_levels(1,1,k)/p_star(1,1)
           end do
           read(*,*) npres
           if (npres <1 .or. npres > model_levels) cycle get_lev
           exit get_lev
        end do get_lev
     end if

     !************UM CODE*********************
     ! Simple Held-Suarez test
     if (exo_benchmark_switch == exo_hd) then
        T_strat=200.
        T_surf=315.
        delta_T_eq_pole=SuHe_pole_equ_deltaT 
        Do k = 1, model_levels
           Do j = 1, rows
              Do i = 1, row_length
                 ! calculate Theta_eq.
                 temp1 = T_strat / exner_theta_levels(i,j,k)
                 temp2 = T_surf - delta_T_eq_pole                                        &
                      &                    * sin_theta_latitude(i,j)                     &
                      &                    * sin_theta_latitude(i,j)                     &
                      &                    - SuHe_static_stab                            &
                      &                    * log(exner_theta_levels(i,j,k))              &
                      &                    * recip_kappa                                 &
                      &                    * cos_theta_latitude(i,j)                     &
                      &                    * cos_theta_latitude(i,j)
                 theta_eq(i,j,k) = max(temp1, temp2)

                 !******************NON-UM CODE*********************************
                 ! Note want temperature for diagnostic routine
                 if (print_type==1) then
                    print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==2) then
                    if (i==nlon .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==3) then
                    if (j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==4) then
                    if (i==nlon .and. j==nlat) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==5) then
                    if (i==nlon .and. j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==6) then
                    if (k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 end if
                 !*************************************************************



              End Do
           End Do
        End Do
        ! Added by NJM 11/2011 for Tidally-Locked Earth
     else if (exo_benchmark_switch == exo_tle) then
        T_strat=200.
        T_surf=315.
        delta_T_eq_pole=SuHe_pole_equ_deltaT 
        Do k = 1, model_levels
           Do j = 1, rows
              Do i = 1, row_length
                 ! Adjust the Thermal Forcing to that prescribed in
                 ! Merlis & Schneider (2010) and Later Heng et al (2011)
                 ! Used cos(x-180)=-cos(x)
                 ! Missing Final pressure term as using 
                 ! potential temperature
                 temp1 = T_strat / exner_theta_levels(i,j,k)
                 temp2 = T_surf - delta_T_eq_pole                                        &
                      &         * cos_theta_longitude(i,j)                               &
                      &         * cos_theta_latitude(i,j)                                &
                      &         - SuHe_static_stab                                       &
                      &         * log(exner_theta_levels(i,j,k))                         &
                      &         * recip_kappa                                            &
                      &         * cos_theta_latitude(i,j)                                &
                      &         * cos_theta_latitude(i,j)          
                 theta_eq(i,j,k) = max(temp1, temp2)

                 !******************NON-UM CODE*********************************
                 ! Note want temperature for diagnostic routine
                 if (print_type==1) then
                    print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==2) then
                    if (i==nlon .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==3) then
                    if (j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==4) then
                    if (i==nlon .and. j==nlat) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==5) then
                    if (i==nlon .and. j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 end if
                 !*************************************************************


              End Do
           End Do
        End Do
     else if (exo_benchmark_switch == exo_el .or.                              &
          &exo_benchmark_switch == exo_shjup) then
        ! Added by NJM 12/2011 for Menou & Rauscher (2009) Earth-like simulation
        ! And Menou & Rauscher (2009) Shallow Hot Jupiter Forcing
        ! They are put together as they both use similar equations
        ! Adjust the Thermal Forcing to that prescribed in
        ! Menou & Rauscher (2009) and Later Heng et al (2011)
        ! First the forcing is different if above the stratosphere
        ! Now we calculate the horizontal temperature differential (beta_trop)
        ! and vertical temperature profile
        ! The values of the constants is set accordingly
        if (exo_benchmark_switch == exo_el) then
           z_strat=1.2e4
           gamma_trop=6.5e-3
           delta_T_strat=2
           T_strat=212
           T_surf=288
           delta_T_eq_pole=SuHe_pole_equ_deltaT 
        else if (exo_benchmark_switch == exo_shjup) then
           z_strat=2.0e6
           gamma_trop=2.0e-4
           delta_T_strat=10
           T_strat=1210
           T_surf=1600
           delta_T_eq_pole=300
        end if
        Do k = 1, model_levels
           Do j = 1, rows
              Do i = 1, row_length
                 temp1 = T_strat / exner_theta_levels(i,j,k)
                 ! We Need the pressure at the top of the stratosphere, as defined
                 ! by the constant value-Consider changing this to an interpolation
                 ! The r_theta_levels is distance from Centre of the Earth
                 strat_loc=minloc(abs(r_theta_levels(i,j,:)-Earth_radius-z_strat),1)
                 sigma_strat=p_theta_levels(i,j,strat_loc)/p_star(i,j)
                 ! sigma_strat should be ~0.22 for Earth and ~0.12 for Shallow Hot Jupiter
                 ! We require Sigma coordinates for this forcing
                 ! NOTE: Exner=(P/P0)^1/kappa /= Sigma = P/P_surf!
                 sigma=p_theta_levels(i,j,k)/p_star(i,j)
                 if (r_theta_levels(i,j,k)-Earth_radius <= z_strat) then
                    ! In the Stratosphere
                    beta_trop=sin(pi*(sigma-sigma_strat)/(2.0*(1.0-sigma_strat)))
                    T_vert=T_surf-gamma_trop*                                          &
                         & (z_strat+(r_theta_levels(i,j,k)-Earth_radius-z_strat)*0.5) + &
                         & ((gamma_trop*(r_theta_levels(i,j,k)-Earth_radius-z_strat)*0.5)**2.0+ &
                         &  delta_T_strat**2.0)**0.5
                 else
                    ! Above Stratosphere
                    beta_trop=0.0
                    T_vert=T_surf-gamma_trop*z_strat+delta_T_strat
                 end if
                 ! Now set the equilibirum temperature for EL and SHJUP
                 ! Recall Using Potential TEMPERATURE
                 ! Therefore, must convert the temperature to potential 
                 ! temperature using the exner function (exner*theta=Temp)
                 if (exo_benchmark_switch == exo_el) then
                    temp2          = (T_vert + beta_trop * delta_T_eq_pole                    &
                         &         * ((1.0/3.0)-sin_theta_latitude(i,j)*sin_theta_latitude(i,j))) &
                         &         / exner_theta_levels(i,j,k)
                 else if (exo_benchmark_switch == exo_shjup) then
                    ! Used cos(x-180)=-cos(x)
                    temp2          = (T_vert - beta_trop * delta_T_eq_pole                    &
                         &         * cos_theta_longitude(i,j)                                 &
                         &         * cos_theta_latitude(i,j))                                 &
                         &         / exner_theta_levels(i,j,k)
                 end if
                 theta_eq(i,j,k) = temp2

                 !******************NON-UM CODE*********************************
                 ! Note want temperature for diagnostic routine
                 if (print_type==1) then
                    print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==2) then
                    if (i==nlon .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==3) then
                    if (j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==4) then
                    if (i==nlon .and. j==nlat) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==5) then
                    if (i==nlon .and. j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==6) then
                    if (k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 end if
                 !*************************************************************



              End Do
           End Do
        End Do
     else if (exo_benchmark_switch == exo_hd209458b_bench) then
        ! Set the temperature profile and relaxation timescale
        Do k = 1, model_levels
           Do j = 1, rows
              Do i = 1, row_length
                 ! First construct the pressure variable
                 ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
                 log_sigma=log10(p_theta_levels(i,j,k)/1.0e5)
                 ! The night and day side temperature profile polynomial fits
                 ! from Heng et al (2011)
                 ! P<=10bar, is 1.0e6 pascals
                 if (p_theta_levels(i,j,k) <= 1.0e6) then
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
                 if (cos_theta_longitude(i,j) <= 0.0) then 
                    temp2=((T_night**4.0 - (T_day**4.0 - T_night**4.0)  &
                         *cos_theta_longitude(i,j)  &
                         *cos_theta_latitude(i,j))**0.25)&
                         /exner_theta_levels(i,j,k)
                 else 
                    temp2=T_night /exner_theta_levels(i,j,k)
                 end if
                 theta_eq(i,j,k) = temp2 

                 !******************NON-UM CODE*********************************
                 ! Note want temperature for diagnostic routine
                 if (print_type==1) then
                    print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==2) then
                    if (i==nlon .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==3) then
                    if (j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==4) then
                    if (i==nlon .and. j==nlat) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==5) then
                    if (i==nlon .and. j==nlat .and. k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 else if (print_type==6) then
                    if (k==npres) &
                         print*, 'Longitude:',longitude(i), ' Latitude:', latitude(j), &
                         'sigma:',p_theta_levels(i,j,k)/p_star(i,j),' Z:',r_theta_levels(i,j,k)-Earth_radius,&
                         ' Temperature:',theta_eq(i,j,k)*exner_theta_levels(i,j,k)
                 end if
                 !*************************************************************

                 !************************UM CODE*****************************
                 ! First construct the pressure variable
                 ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
                 log_sigma=log10(p_theta_levels(i,j,k)/1.0e5)
                 ! Different for P<10bar i.e 1.0e6 Pa
                 ! Recall variable given as log(T_rad) in Heng et al (2011)
                 ! Also we need 1/T_rad, s^-1
                 if (p_theta_levels(i,j,k) < 1.0e6) then
                    newtonian_timescale=1.0/(10.0**(5.4659686+1.4940124*log_sigma        &
                         & +0.66079196*(log_sigma**2.0)+0.16475329*(log_sigma**3.0) &
                         & +0.014241552*(log_sigma**4.0)))
                 else
                    newtonian_timescale=0.0
                 end if
                 ! calculate relaxation term.
                 ! temp1 is SuHe_level_weight(k)
                 theta_star(i,j,k) = theta_star(i,j,k) - timestep *        &
                      &                                    newtonian_timescale *         &
                      &                           (theta_star(i,j,k) - theta_eq(i,j,k))
                 !*************************************************************
                 ! ********************NON UM CODE******************************
                 if (i==1 .and. j==1) &
                      write(90,*), k, p_theta_levels(i,j,k), log_sigma, newtonian_timescale, &
                      (1.0/newtonian_timescale)/(60.0*60.0*24.0)
                 ! *************************************************************

              End Do
           End Do
        End Do
     end if

  else if (which==1) then

     L_isothermal=.false.
     get_iso: do
        print*, 'Would you like to test:'
        print*, '1, Isothermal setup'
        print*, '2, Non-isothermal setup'
        print*, 'Enter 1 or 2'
        read(*,*) iso_int
        if (iso_int <1 .or. iso_int >2) cycle get_iso
        if (iso_int == 1) L_isothermal=.true.
        exit get_iso
     end do get_iso


     !************UM CODE*********************
     recip_kappa=1.0/kappa 
     exner_surface = (p_surface/p_zero) ** kappa
     minusgoverRTref = - g / ( R * theta_surface)   
     !-----------------------------------------------------------------
     ! Section 1.1  Setup the Pressure Sigma Levels based on height
     !-------------------------------------------------------------------
     do k= 1, model_levels
        sigma_ref(k) = exp( minusgoverRTref *                           &
             &                       (r_theta_levels(1,1,k) -  Earth_radius ) )
        sigma_to_kappa(k) =  sigma_ref(k) ** kappa
     end do


     !-----------------------------------------------------------------
     ! Section 2  Force Temperature Profile
     !-------------------------------------------------------------------

     if (exo_benchmark_switch == no_exo) then
        if (me == 0) print*, 'EXO: Benchmark Not Required-Error'
        stop

        !-----------------------------------------------------------------
        ! Section 2.1  Zonally symmetric initial data based on dynamical core
        !              set up (Held-Suarez)
        ! Also applies to
        ! Section 2.2   Hypothetical Tidally-Locked Earth
        !                (Merlis & Schneider, 2010)              
        ! Section 2.3    'Shallow' Earth, or Earth-Like 
        !                (Menou & Rauscher, 2009)
        !-------------------------------------------------------------------

     elseif  (exo_benchmark_switch == exo_hd .or.                                       &
          &     exo_benchmark_switch == exo_tle .or.                                      &
          &     exo_benchmark_switch == exo_el .or.                                       &
          &     exo_benchmark_switch == exo_shjup .or.                                  &
          &     exo_benchmark_switch == exo_hd209458b_bench) then
        ! Set the default stratospheric temperature for Held-Suarez
        T_strat=200.0
        static_stab=SuHe_static_stab
        if (exo_benchmark_switch == exo_el) T_strat=212.0
        ! Stability parameter of 10.0 (i.e. HS is OK for this)
        if (exo_benchmark_switch == exo_shjup) T_strat=1210.0
        if (exo_benchmark_switch == exo_hd209458b_bench) then
           ! The static stability profile is estimated from 
           ! a linear fit to the night side profile in Figure 7
           ! of Heng et al (2011).
           T_strat=0.0
           static_stab=800.0
        end if

        if (L_isothermal .and. me ==0) print*, 'EXO: Using initially isothermal atmosphere'
        ! NOTE theta and theta_ref, contain temperature at the moment
        if (L_isothermal) then
           ! If we are setting up an isothermal atmosphere
           ! set temperature to surface temperature everywhere
           theta(:,:,:)=theta_surface
           theta_ref(:)=theta_surface
        else
           Do k = 1, model_levels
              ! For HD209458b-have an inactive isothermal region P>10 bar
              ! Then need smooth structure above
              if (exo_benchmark_switch == exo_hd209458b_bench .and. &
                   & sigma_ref(k)*p_surface > 1.0e6 ) then
                 theta(:,:,k)=theta_surface
                 theta_ref(k)=theta_surface
              else
                 ! Set up a smooth zonally symmetric temperature structure                 
                 temp1 = (theta_surface - static_stab * log(sigma_ref(k)))       &
                      &   * sigma_to_kappa(k)
                 theta(:,:,k) = max(T_strat, temp1)
                 ! NB  theta currently holds temperature
                 theta_ref(k) = max(T_strat, temp1)
              end if
           End Do
        end if

        !******************NON-UM CODE*********************************
        do k=1, model_levels
           print*,'sigma(ref):',sigma_ref(k),' Z:',r_theta_levels(1,1,k)-Earth_radius,&
                ' Temperature:',theta(1,1,k),&
                '(Temp-ref):', theta_ref(k)
        end do
        !*************************************************************


     end if

     !******************NON-UM CODE*********************************
     ! Write out the suggested r_theta_levels
     ! First we take the reference temperature
     ! required sigma profile and construct the required vertical theta_levels
     ! assuming ideal gas and hydrostatic balance.
     do k=1, model_levels
        r_theta_levels_set(k)=-1.0*(log(sigma_set(k))*R*theta_surface)/g
        if (r_theta_levels_set(k) <0.0) r_theta_levels_set(k)=0.0
        if (set_smooth) r_theta_levels_set(k)=nint(r_theta_levels_set(k))
     end do
     ! Now  calculate the eta_theta and eta_rho values (and print them)
     ! The first eta theta and rho values 
     eta_theta_out(1)=0.0
     eta_rho_out(1)=0.5*r_theta_levels_set(1)/r_theta_levels_set(model_levels)
     ! Theta Levels
     do k=1, model_levels
        eta_theta_out(k+1)=r_theta_levels_set(k)/r_theta_levels_set(model_levels)
     end do
     ! Eta Levels
     do k=1, model_levels
        eta_rho_out(k)=0.5*(eta_theta_out(k)+eta_theta_out(k+1))
     end do
     ! Now print them out
     print*, 'The suggested Sigma Levels based on the'
     print*, 'initial temperature, hydrostatic equb and ideal gas are'
     print*, 'RECALL THESE ARE ONLY SUGGESTED THE FARTHER FROM HYDROSTASY'
     print*, 'THE MODELS THE WORSE THESE WILL BE IT IS BETTER TO DERIVE THESE'
     print*, 'FROM A COMPLETED RUN'
     print*, 'Level, Theta(m) Rho(m)'

     do k=1, model_levels-1
        if (k==1) then
           print*, k, ' 1.0           ',&
                eta_theta_out(k)*r_theta_levels_set(model_levels),&
                eta_rho_out(k)*r_theta_levels_set(model_levels)
        else
           print*, k, sigma_set(k+1),&
                eta_theta_out(k)*r_theta_levels_set(model_levels),&
                eta_rho_out(k)*r_theta_levels_set(model_levels)
        end if
     end do

     ! Now to create the required output
     print*, 'Please enter the name of the file for the levels'
     read(*,'(a)') lev_name
     open(unit=1, file=trim(lev_name), iostat=ios)
     if (ios<0) then
        print*, 'Problem with this file:',trim(lev_name)
        stop
     end if
     write(1,*) '&VERTLEVS'
     write(1,*)
     write(write_string,*) r_theta_levels_set(model_levels)
     write(1,*) ' z_top_of_model = ', trim(write_string),','
     write(write_string,*) model_levels
     write(1,*) ' first_constant_r_rho_level = ', trim(write_string), ','
     write(1,*) 'eta_theta='
     write(eta_theta_format(1),'(f10.8)') eta_theta_out(1)
     do k=1, model_levels
        write(eta_theta_format(k+1),'(f10.8)') eta_theta_out(k+1)
        write(eta_rho_format(k),'(f10.8)') eta_rho_out(k)
     end do
     write_theta: do k=1, int((model_levels+1)/5)+1
        max_val=5*k
        if (k==int((model_levels+1)/5)+1) max_val=model_levels+1
        write(write_string,*) (trim(eta_theta_format(i)), ',', i=((k-1)*5)+1, max_val)
        write(1,*) trim(write_string)
     end do write_theta
     write(1,*) 'eta_rho='
     write_rho: do k=1, int((model_levels)/5)+1
        max_val=5*k
        if (k==int((model_levels-1)/5)+1) max_val=model_levels
        write(write_string,*) (trim(eta_rho_format(i)), ',', i=((k-1)*5)+1, max_val)
        write(1,*) trim(write_string)
     end do write_rho
     write(1,*) '/'
     close(1)
     !*************************************************************
  end if
end program um_t_profile
