PROGRAM um_force_check
  ! This program is designed to allow the forcing routine
  ! in the UM to be wrapped and tested.
  USE non_um_eg_idl_theta_forcing_mod
  USE constants

  IMPLICIT NONE
  ! Data arrays
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: theta  
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: theta_star 
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: exner_theta_levels
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: exner
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: theta_eq
  REAL, DIMENSION(:,:,:), ALLOCATABLE :: newtonian_timescale
  REAL, DIMENSION(:), ALLOCATABLE :: T_initial
  REAL, DIMENSION(:), ALLOCATABLE :: Long, Lat

  INTEGER :: tforce_number, trelax_number
  REAL    :: t_surface
  INTEGER :: i,j,k
  REAL    :: dz, dtheta_lat, dtheta_long
  REAL    :: radians
  INTEGER :: ios, eq_pos
  CHARACTER(LEN=1000) :: output, temp

  INTEGER error_code

  CALL set_size()
  IF (ALLOCATED(theta)) DEALLOCATE(theta)
  ALLOCATE(theta(tdims_s%i_start:tdims_s%i_END,                    &
       tdims_s%j_start:tdims_s%j_END,                              &
       tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(theta_star)) DEALLOCATE(theta_star)
  ALLOCATE(theta_star(tdims_s%i_start:tdims_s%i_END,               &
       tdims_s%j_start:tdims_s%j_END,                              &
       tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(exner)) DEALLOCATE(exner)
  ALLOCATE(exner(tdims_s%i_start:tdims_s%i_END,                    &
       tdims_s%j_start:tdims_s%j_END,                              &
       tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(exner_theta_levels)) DEALLOCATE(exner_theta_levels)
  ALLOCATE(exner_theta_levels(tdims_s%i_start:tdims_s%i_END,       &
       tdims_s%j_start:tdims_s%j_END,                              &
       tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(theta_eq)) DEALLOCATE(theta_eq)
  ALLOCATE(theta_eq(tdims_s%i_start:tdims_s%i_END,                 &
       tdims_s%j_start:tdims_s%j_END,                              &
       tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(newtonian_timescale)) DEALLOCATE(newtonian_timescale)
  ALLOCATE(newtonian_timescale(tdims_s%i_start:tdims_s%i_END,      &
       tdims_s%j_start:tdims_s%j_END,                              &
       tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(T_initial)) DEALLOCATE(T_initial)
  ALLOCATE(T_initial(tdims_s%k_start:tdims_s%k_END))
  IF (ALLOCATED(Long)) DEALLOCATE(Long)
  ALLOCATE(Long(tdims_s%i_start:tdims_s%i_END))
  IF (ALLOCATED(Lat)) DEALLOCATE(Lat)
  ALLOCATE(Lat(tdims_s%j_start:tdims_s%j_END))

print*, 'WARNING FILENAMES ARE A MIX OF INDEX AND DEGREES!!!'


  print*, 'Please enter the Timestep (s)'
  read(*,*) timestep
  print*, 'Please enter the surface temperature'
  read(*,*) t_surface
  print*, 'Please select the Forcing profile:'
  print*, 'See constants.f90 for choices'
  read(*,*) tforce_number
  print*, 'Please select the Relaxation profile:'
  print*, 'See constants.f90 for choices'
  read(*,*) trelax_number
  print*, 'Please enter grid box size (z) (uniform only)'
  read(*,*) dz
  print*, 'Please enter grid box size in degrees in longitude'
  read(*,*) dtheta_long
  print*, 'Please enter grid box size in degrees in latitude'
  read(*,*) dtheta_lat
   
  ! Create an initial profile
  ! And spatial grid
  exner_theta_levels(:,:,1)=1.0
  T_initial(1)=0.5*(                                                &
       hot_jup_day_temp(exner_theta_levels(1,1,1), tforce_number)+  &
       hot_jup_night_temp(exner_theta_levels(1,1,1), tforce_number))
  theta(:,:,1)=T_initial(1)/exner_theta_levels(:,:,1)
  r_theta_levels(:,:,1)=Earth_radius
  DO k=pdims_s%k_start+1, pdims_s%k_END
     exner_theta_levels(:,:,k)=exner_theta_levels(:,:,k-1)*         &
          EXP(-1.0*g*dz/(Cp*T_initial(k-1)))
     r_theta_levels(:,:,k)=r_theta_levels(:,:,k-1)+dz
     T_initial(k)=0.5*(                                             &
          hot_jup_day_temp(exner_theta_levels(1,1,k), tforce_number)+ &
          hot_jup_night_temp(exner_theta_levels(1,1,k), tforce_number))
     theta(:,:,k)=T_initial(k)/exner_theta_levels(:,:,k)
  END DO
  ! WRITE out the initial T-P profile
  output='T-P_initial.txt'
  open(unit=1, file=trim(output), iostat=ios)
  if (ios<0) then
     print*, 'Problem with this file', trim(output)
     stop
  END if
  ! WRITE out T-P profile
  WRITE(1,*) 'Initial T-P Profile (bar, K)'
  WRITE(1,*) ''
  WRITE(1,*) ''
  DO k=1, 200
     WRITE(1,*) ((exner_theta_levels(1,1,k)**recip_kappa)*p_zero)&
          ! To convert to bar
          /1.0e5,&
          theta(1,1,k)*exner_theta_levels(1,1,k)
  END DO
  CLOSE(1)
  
  ! Cos(longitude)
  DO i=pdims_s%i_start, pdims_s%i_END
     Long(i)=(0.0+(i-1)*dtheta_long)
     radians=long(i)*2.0*pi/360.0
     Csxi1_p(i)=cos(radians)
  END DO
  ! Cos(latitude) and Sin(Latitude)
  DO j=pdims_s%j_start, pdims_s%j_END
     Lat(i)=(-90.0+(j-1)*dtheta_lat)
     radians=Lat(i)*2.0*pi/360.0
     Csxi2_p(j)=cos(radians)
     Snxi2_p(j)=sin(radians)
  END DO
    
  ! Zero the tENDency
  theta_star=0.0
  ! Exner is not used
  exner=0.0

  ! Call the forcing routine
  call eg_idl_theta_forcing(                                      &       
       ! in data fields.
       theta, exner_theta_levels, exner,                          &
       ! in/out
       theta_star,                                                &
       ! Profile switches
       tforce_number, trelax_number,                              &
       t_surface,                                                 &
       ! error information
       error_code,                                                &
       ! Additional arguments for diagnosis
       theta_eq, newtonian_timescale)


  ! Now deal with printout of the answers.
  ! WRITE out T-P profiles at the Equator, around the globe
  eq_pos=int(pdims_s%j_END/2)
  DO i=pdims_s%i_start, pdims_s%i_END
     WRITE(temp,*) i
     output='T-P_LAT=0.0_LON_index='//trim(adjustl(temp))//'.txt'
     open(unit=1, file=trim(output), iostat=ios)
     if (ios<0) then
        print*, 'Problem with this file', trim(output)
      stop
     END if
     ! WRITE out T-P profile
     WRITE(1,*) 'T-P Profile (bar, K) at Equator'
     WRITE(1,*) 'Longitude (degs):', Long(i)
     WRITE(1,*) ''
     DO k=1, 200
        WRITE(1,*) ((exner_theta_levels(i,eq_pos,k)**recip_kappa)*p_zero)&
             ! To convert to bar
             /1.0e5,&
             theta_eq(i,eq_pos,k)*exner_theta_levels(i,eq_pos,k)
     END DO
     CLOSE(1)  
  END DO

  ! Now Hot Spot
  eq_pos=int(pdims_s%i_END/2)
  DO j=pdims_s%j_start, pdims_s%j_END
     WRITE(temp,*) j
     output='T-P_LAT_index='//trim(adjustl(temp))//'_LON=180.0.txt'
     open(unit=1, file=trim(output), iostat=ios)
     if (ios<0) then
        print*, 'Problem with this file', trim(output)
      stop
     END if
     ! WRITE out T-P profile
     WRITE(1,*) 'T-P Profile (bar, K) at Hot Spot'
     WRITE(1,*) 'Latitude (degs):', Lat(i)
     WRITE(1,*) ''
     DO k=1, 200
        WRITE(1,*) ((exner_theta_levels(eq_pos,j,k)**recip_kappa)*p_zero)&
             ! To convert to bar
             /1.0e5,&
             theta_eq(eq_pos,j,k)*exner_theta_levels(eq_pos,j,k)
     END DO
     CLOSE(1)  
  END DO

  ! Anti-Hot Spot
  eq_pos=1
  DO j=pdims_s%j_start, pdims_s%j_END
     WRITE(temp,*) j
     output='T-P_LAT_index='//trim(adjustl(temp))//'_LON=0.0.txt'
     open(unit=1, file=trim(output), iostat=ios)
     if (ios<0) then
        print*, 'Problem with this file', trim(output)
        stop
     END if
     ! WRITE out T-P profile
     WRITE(1,*) 'T-P Profile (bar, K) at Anti Hot Spot'
     WRITE(1,*) 'Latitude (degs):', Lat(i)
     WRITE(1,*) ''
     DO k=1, 200
        WRITE(1,*) ((exner_theta_levels(eq_pos,j,k)**recip_kappa)*p_zero)&
             ! To convert to bar
             /1.0e5,&
             theta_eq(eq_pos,j,k)*exner_theta_levels(eq_pos,j,k)
     END DO
     CLOSE(1)  
  END DO
  
  ! Terminator
  eq_pos=int(pdims_s%i_END/4)+1
  DO j=pdims_s%j_start, pdims_s%j_END
     WRITE(temp,*) j
     output='T-P_LAT_index='//trim(adjustl(temp))//'_LON=92.5.txt'
     open(unit=1, file=trim(output), iostat=ios)
     if (ios<0) then
        print*, 'Problem with this file', trim(output)
        stop
     END if
     ! WRITE out T-P profile
     WRITE(1,*) 'T-P Profile (bar, K) at Terminator'
     WRITE(1,*) 'Latitude (degs):', Lat(i)
     WRITE(1,*) ''
     DO k=1, 200
        WRITE(1,*) ((exner_theta_levels(eq_pos,j,k)**recip_kappa)*p_zero)&
             ! To convert to bar
             /1.0e5,&
             theta_eq(eq_pos,j,k)*exner_theta_levels(eq_pos,j,k)
     END DO
     CLOSE(1)  
  END DO
  
  ! Now write out newtonian-Timescale
  ! It is just a function of pressure
  output='tau_rad.txt'
  open(unit=1, file=trim(output), iostat=ios)
  if (ios<0) then
     print*, 'Problem with this file', trim(output)
     stop
  END if
  ! WRITE out T-P profile
  WRITE(1,*) 'Pressure (bar) & Newtonian Timescale (seconds, Earth days)'
  WRITE(1,*) 'Infinite values set at 1e9'
  WRITE(1,*) ''
  DO k=1, 200
     IF (newtonian_timescale(1,1,k) >0.0) THEN
        WRITE(1,*) ((exner_theta_levels(1,1,k)**recip_kappa)*p_zero)&
             ! To convert to bar
             /1.0e5,&
             1.0/newtonian_timescale(1,1,k), &
             1.0/newtonian_timescale(1,1,k)/(24.0*60.0*60.0)          
     ELSE
        WRITE(1,*) ((exner_theta_levels(1,1,k)**recip_kappa)*p_zero)&
             ! To convert to bar
             /1.0e5,&
             1.0e9, 1.0e9
     END IF
  END DO
  CLOSE(1)  


  ! Now Temperature-Pressure Surfaces
  !****TODO*** GOT HERE
  


!----------------------------------------------------
!WARNING FILENAMES ARE A MIX OF INDEX AND DEGREES!!!'
!----------------------------------------------------
END PROGRAM um_force_check
