program forcing_profiles

  use iro_timescale
  use iro_temperature
  use heng_night_temperature
  use heng_day_temperature
  use hd209458b_temperature_spatial

  implicit none

  ! Input variables
  real :: pressure_min, pressure_max
  integer :: n_press
  logical :: active_deep, smooth
  real :: latitude, longitude
  real :: T_eq_pole

  ! Local/Outputs
  integer, parameter :: n_types=10
  character(len=1000), dimension(n_types) :: profile_types
  integer :: ipress, choice, choice_smooth, iprofile, npress
  real :: step
  real, dimension(:), allocatable :: pressure, temperature, log_tscale
  real :: temperature_one, temperature_two
  integer :: ios
  character(len=10000) :: output

  ! Select profile type:
  profile_types(1)='HD209458b Night side (longitude=0.0, latitude=0.0)'
  profile_types(2)='HD209458b Day side (longitude=180.0, latitude=0.0)'
  profile_types(3)='HD209458b Iro (hemispherical average)'
  profile_types(4)='HD209458b Midway (=0.5*option(1)+0.5*option(2))'
  profile_types(5)='HD209458b Contrast (option(2)-option(1))'
  profile_types(6)='HD209458b Standard Profile'
  profile_types(7)='HD209458b Active Deep Atm (p>10bar)'
  profile_types(8)='HD209458b Active Deep Atm Iro Temperature (p>10bar)'
  profile_types(9)='HD209458b Active Deep Atm Equator-Pole gradient (p>10bar)'
  profile_types(n_types)='EXIT'
  create_profile: do
     ! Initialise logicals
     active_deep=.true.
     smooth=.false.
     profile_choice: do
        print*, 'What sort of HD209458b profile do you require?'
        print*, 'Please choose:'
        do iprofile=1, n_types
           print*, iprofile, trim(profile_types(iprofile))
        end do
        read(*,*) choice
        if (choice == n_types) exit create_profile
        if (choice >= 1 .and. choice <= 9) exit profile_choice
     end do profile_choice

     ! Choose the smoothed or not
     if (choice /= 3) then
        smooth_choice: do
           print*, '(1) Use original Heng et al (2011) profiles'
           print*, '(2) Use smoothed Mayne et al (2014) profiles'
           read(*,*) choice_smooth
           if (choice_smooth == 1) exit smooth_choice
           if (choice_smooth == 2) then
              smooth=.true. 
              exit smooth_choice
           endif
        end do smooth_choice
     endif

     ! If required get the latitude and longitude
     latitude=0.0
     longitude=0.0
     if (choice == 2) longitude=180.0
     if (choice == 4 .or. choice == 5) then
        print*, 'Please enter the required Latitude (degrees)'
        read(*,*) latitude
     else if (choice == 6 .or. choice == 7 .or. choice == 8  &
          .or. choice == 9) then
        print*, 'Please enter the required Longitude (degrees):'
        read(*,*) longitude
        print*, 'Please enter the required Latitude (degrees):'
        read(*,*) latitude
     endif
     ! No T_eq_pole
     T_eq_pole=0.0
     if (choice == 9) then
        print*, 'Please enter the T_eq to T_pole difference (K)'
        read(*,*) T_eq_pole
     endif

     ! Setup the Pressure Environment
     print*, 'Please enter the maximum pressure (Pa) for the profile'
     read(*,*) pressure_max
     print*, 'Now the minimum pressure (Pa)'
     read(*,*) pressure_min
     print*, 'And a number of pressure points(distributed in log space)'
     read(*,*) npress
     ! Allocate arrays
     if (allocated(pressure)) deallocate(pressure)
     if (allocated(temperature)) deallocate(temperature)
     if (allocated(log_tscale)) deallocate(log_tscale)
     allocate(pressure(npress), temperature(npress), log_tscale(npress))

     print*, 'Enter a filename to store the Profile output'
     read(*,'(a)') output
     open(unit=1, file=trim(output), iostat=ios)
     if (ios<0) then
        print*, 'Problem with this file'
        stop
     end if

     ! Write some header
     write(1,*) '#', trim(profile_types(choice))
     write(1,*) 'Level, Pressure(Pa), Temperature(K), Log_10(Timescale)'

     ! Now to construct the pressure, calculate the outputs 
     ! (temperature and timescale) and write it out
     step=(log10(pressure_max)-log10(pressure_min))/(npress-1)
     do ipress=1, npress
        pressure(ipress)=10.0**(log10(pressure_max)-(ipress-1.0)*step)
        ! First no matter what the option we calculate the timescale
        ! at the position prescribed
        log_tscale(ipress)=LOG10(1.0/(recip_iro(pressure(ipress), active_deep)))
        ! Then we calculate the temperature dependent on the option
        if (choice == 1) then
           temperature(ipress)=hot_jup_night_temp(pressure(ipress), smooth)
        else if (choice == 2) then
           temperature(ipress)=hot_jup_day_temp(pressure(ipress), smooth)
        else if (choice == 3) then
           temperature(ipress)=iro_hd209458b_temp(pressure(ipress))
        else if (choice == 4) then
           temperature_one=hd209458b_temperature(pressure(ipress), &
                180.0, latitude, smooth)
           temperature_two=hd209458b_temperature(pressure(ipress), &
                0.0, latitude, smooth)
           temperature(ipress)=0.5*(temperature_one+temperature_two)
        else  if (choice == 5) then
           temperature_one=hd209458b_temperature(pressure(ipress), &
                180.0, latitude, smooth)
           temperature_two=hd209458b_temperature(pressure(ipress), &
                0.0, latitude, smooth)
           temperature(ipress)=temperature_one-temperature_two
        else  if (choice == 6) then
           temperature(ipress)=hd209458b_temperature(pressure(ipress), &
                longitude, latitude, smooth)
        else  if (choice == 7) then
           temperature(ipress)=hd209458b_temperature(pressure(ipress), &
                longitude, latitude, smooth)        
        else  if (choice == 8) then
           if (pressure(ipress) > 1.0e6) then
              temperature(ipress)=iro_hd209458b_temp(pressure(ipress))
           else
              temperature(ipress)=hd209458b_temperature(pressure(ipress), &
                   longitude, latitude, smooth)
           endif
        else  if (choice == 9) then
           temperature(ipress)=hd209458b_temperature(pressure(ipress), &
                longitude, latitude, smooth)
           if (pressure(ipress) >= 1.0e6) then 
              temperature_one=temperature(ipress)
              temperature(ipress)=hd209458b_temperature_equator_pole(pressure(ipress), &
                   temperature_one, latitude, T_eq_pole)
           endif
        endif
        ! Write it out
        write(1,*) ipress, pressure(ipress), temperature(ipress), &
             log_tscale(ipress)
     end do
     close(1)
  end do create_profile
end program forcing_profiles
