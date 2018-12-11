MODULE non_um_eg_idl_theta_forcing_mod

USE constants
IMPLICIT NONE

CONTAINS

SUBROUTINE eg_idl_theta_forcing(                                  &
! in data fields.
  theta, exner_theta_levels, exner,                               &
! in/out
  theta_star,                                                     &
! Profile switches
  tforce_number, trelax_number,                                   &
  t_surface,                                                      &
! error information
  error_code,                                                     &
! Additional arguments for diagnosis
  theta_eq, newtonian_timescale)
!
! Description: This forces the potential temperature towards
!              a selected (tforce_number) temperature profile
!              using a specified newtonian timescale scheme 
!              (trelax_number)
!  
!
! Method:
!  
!
! Code Owner: See Unified Model Code Owner's HTML page
! This file belongs in section: Control
!
! Code description:
!   Language: Fortran 90.
!   This code is written to UM programming standards version 8.3.

! Subroutine arguments


! Data arrays
REAL, INTENT (INOUT) ::                                               &
  theta(             tdims_s%i_start:tdims_s%i_end,                   &
                     tdims_s%j_start:tdims_s%j_end,                   &
                     tdims_s%k_start:tdims_s%k_end )

REAL, INTENT (INOUT) ::                                               &
  theta_star(        tdims_s%i_start:tdims_s%i_end,                   &
                     tdims_s%j_start:tdims_s%j_end,                   &
                     tdims_s%k_start:tdims_s%k_end),                  &
  exner_theta_levels(tdims_s%i_start:tdims_s%i_end,                   &
                     tdims_s%j_start:tdims_s%j_end,                   &
                     tdims_s%k_start:tdims_s%k_end),                  &
  exner(             pdims_s%i_start:pdims_s%i_end,                   &
                     pdims_s%j_start:pdims_s%j_end,                   &
                     pdims_s%k_start:pdims_s%k_end+1)

INTEGER :: tforce_number, trelax_number
REAL    :: t_surface

INTEGER error_code

! Local Variables for the temperature profile settings
! and the relaxation
INTEGER :: i, j,k

REAL    ::                                                            &
           theta_eq(tdims_s%i_start:tdims_s%i_end,                    &
                    tdims_s%j_start:tdims_s%j_end,                    &
                    tdims_s%k_start:tdims_s%k_end),                   &
           newtonian_timescale(tdims_s%i_start:tdims_s%i_end,         &
                    tdims_s%j_start:tdims_s%j_end,                    &
                    tdims_s%k_start:tdims_s%k_end)

! ----------------------------------------------------------------------
! Section 1. Create the Equlibrium Theta and Newtonian Timescale
! ----------------------------------------------------------------------
! Initialise the forcing variables
newtonian_timescale=0.0
theta_eq=theta
! If we are not forcing do nothing
IF (tforce_number == tf_none .OR. trelax_number == tr_none) THEN
   ! No forcing 
   theta_eq=theta
   newtonian_timescale=0.0
ELSE
   ! Set the equilibrium theta and newtonian timescale
   DO k = tdims%k_start, tdims%k_end 
      DO j = tdims%j_start, tdims%j_end 
         DO i = tdims%i_start, tdims%i_end 
            theta_eq(i,j,k)=equilibrium_theta(tforce_number, i, j, k, &
                 exner_theta_levels, t_surface)
            newtonian_timescale(i,j,k)=recip_relaxation_tscale(       &
                 trelax_number, i, j, k, exner_theta_levels, theta)
            ! ----------------------------------------------------------------------
            ! Section 1.2 Perform Relaxation
            ! ----------------------------------------------------------------------
            ! Check we do not over-correct
            IF (timestep * newtonian_timescale(i,j,k) > 1.0)          &
                 newtonian_timescale(i,j,k)=1.0/timestep
            ! Apply parameterised heating/cooling
            theta_star(i,j,k) = theta_star(i,j,k)                     &
                 - timestep * newtonian_timescale(i,j,k) *            &
                 (theta(i,j,k) - theta_eq(i,j,k))
         END DO
      END DO
   END DO
ENDIF
END SUBROUTINE eg_idl_theta_forcing

! ----------------------------------------------------------------------
! FUNCTIONS: 1. Derive equilibrium potential temperature
! ----------------------------------------------------------------------

REAL FUNCTION equilibrium_theta(tforce_number, i, j, k,              &
     exner_theta_levels, t_surface)
! This function returns the equilibrium
! potential temperature from the
! profile=tforce_number, at position
! i,j,k
! INPUT
INTEGER :: tforce_number 
INTEGER :: i,j,k
REAL    :: t_surface
REAL    ::   exner_theta_levels(tdims_s%i_start:tdims_s%i_end,       &
                     tdims_s%j_start:tdims_s%j_end,                  &
                     tdims_s%k_start:tdims_s%k_end) 
! LOCAL VARIABLES
REAL :: T_min, T_surf  ! Minimum/Stratospheric & surface temperature
REAL :: DT_eq_pole     ! Equator-Pole Temp diff
REAL :: Static_Stab    ! Static Stability temperature
REAL :: theta1, theta2 ! Potential temperatures
REAL :: z_strat        ! Height (m) of Stratosphere
REAL :: gamma_trop     ! Lapse Rate
INTEGER :: strat_loc   ! The location of the Stratosphere (index)
REAL :: sigma_strat    ! Sigma value of the Stratosphere
REAL :: sigma          ! The relative pressure of the level
REAL :: T_vert         ! Stratospheric Temperature profile
REAL :: beta_trop      ! Horizontal temperature gradient in troposphere
REAL :: T_day, T_night ! The day/night side temperatures of Hot Jupiters
REAL :: theta_out

! Set the required potential temperature
IF (tforce_number == tf_isothermal) THEN
   ! Isothermal Sphere
   theta_out=t_surface/exner_theta_levels(i,j,k)
ELSE IF (tforce_number == tf_HeldSuarez) THEN
   ! Held-Suarez Temperature profile (Held & Suarez, 1995)
   Static_Stab=10.0
   DT_eq_pole=60.0
   T_min=200.0
   T_surf=315.0
   theta1 = T_min / exner_theta_levels(i,j,k)
   theta2 = T_surf                                         &
        - DT_eq_pole * Snxi2_p(j) * Snxi2_p(j)             &
        - Static_Stab * recip_kappa                        &
        * LOG(exner_theta_levels(i,j,k))                   &
        * Csxi2_p(j) * Csxi2_p(j)
   theta_out = MAX(theta1, theta2)
ELSE IF (tforce_number == tf_TLE) THEN
   ! Tidally-Locked Earth (Merlis & Schneider, 2010)
   Static_Stab=10.0
   DT_eq_pole=60.0
   T_min=200.0
   T_surf=315.0
   ! Used cos(x-180)=-cos(x)
   ! Missing Final pressure term as using 
   ! potential temperature
   theta1 = T_min / exner_theta_levels(i,j,k)
   theta2 = T_surf - DT_eq_pole                            &
        * Csxi1_p(i)                                       &
        * Csxi2_p(j)                                       &
        - Static_Stab                                      &
        * LOG(exner_theta_levels(i,j,k))                   &
        * recip_kappa                                      &
        * Csxi2_p(j)                                       &
        * Csxi2_p(j)          
   theta_out = MAX(theta1, theta2)
ELSE IF (tforce_number == tf_EL .or. tforce_number == tf_SHJ) THEN
   ! Earth-Like and Shallow-Hot-Jupiter Profiles have same format
   ! Set parameters
   IF (tforce_number == tf_EL) THEN
      ! Tidally-Locked Earth (Merlis & Schneider, 2010)
      z_strat=1.2e4
      gamma_trop=6.5e-3
      Static_Stab=2.0
      T_min=212.0
      T_surf=288.0
      DT_eq_pole=60.0
   ELSE IF (tforce_number == tf_SHJ) THEN
      ! Shallow-Hot-Jupiter (Menou & Rauscher, 2009)
      z_strat=2.0e6
      gamma_trop=2.0e-4
      Static_Stab=10.0
      T_min=1210.0
      T_surf=1600.0
      DT_eq_pole=300.0
   END IF
   ! Find location and sigma at the stratosphere
   strat_loc=MINLOC(ABS(r_theta_levels(i,j,:)-Earth_radius-z_strat),1)
   ! Exner=(P/P_0)**kappa
   ! Sigma=(Exner/Exner_surf)**(1.0/kappa)
   sigma_strat=(exner_theta_levels(i,j,strat_loc)/&
        exner_theta_levels(i,j,0))**recip_kappa
   ! sigma_strat should be ~0.22 for Earth and ~0.12 for Shallow Hot Jupiter
   ! We require Sigma coordinates for this forcing
   ! NOTE: Exner=(P/P0)**1/kappa /= Sigma = P/P_surf!
   sigma=(exner_theta_levels(i,j,k)/&
        exner_theta_levels(i,j,0))**recip_kappa
   IF (r_theta_levels(i,j,k)-Earth_radius <= z_strat) THEN
      ! In the Stratosphere
      beta_trop=SIN(pi*(sigma-sigma_strat)/(2.0*(1.0-sigma_strat)))
      T_vert=T_surf-gamma_trop*                                             &
           (z_strat+(r_theta_levels(i,j,k)-Earth_radius-z_strat)*0.5) +     &
           ((gamma_trop*(r_theta_levels(i,j,k)-                             &
           Earth_radius-z_strat)*0.5)**2.0+Static_Stab**2.0)**0.5
   ELSE
      ! Above Stratosphere
      beta_trop=0.0
      T_vert=T_surf-gamma_trop*z_strat+Static_Stab
   END IF
   ! Recall Using Potential TEMPERATURE
   ! Therefore, must convert the temperature to potential 
   ! temperature using the exner function (exner*theta=Temp)
   IF (tforce_number == tf_EL) THEN
      theta1         = (T_vert + beta_trop * DT_eq_pole                    &
           * ((1.0/3.0)-Snxi2_p(j)*Snxi2_p(j)))                  &
           / exner_theta_levels(i,j,k)
   ELSE IF (tforce_number == tf_SHJ) THEN
      ! Used cos(x-180)=-cos(x)
      theta1         = (T_vert - beta_trop * DT_eq_pole                    &
           * Csxi1_p(i)                                          &
           * Csxi2_p(j))                                         &
           / exner_theta_levels(i,j,k)
   END IF
   theta_out = theta1
ELSE IF (tforce_number == tf_HD209458b_Heng .OR. &
     tforce_number == tf_HD209458b_Heng_smooth) THEN
   ! HD209458b Model (Heng et al, 2011)
   ! Or the smoothed profile 
   ! Set the Night and Day side temperatures
   T_night=hot_jup_night_temp(exner_theta_levels(i,j,k),   &
        tforce_number)   
   T_day=hot_jup_day_temp(exner_theta_levels(i,j,k),     &
        tforce_number)     
   ! Now apply the temperature, dependent on the location
   ! Note there is an error in Heng et al (2011) Eqn 26
   ! 90<phi<270 should be 90<theta<270
   ! Day side is 90<theta(longitude)<270
   ! Therefore, cos_theta_longitude <=0.0 
   ! Again using potential temperature so convert by /exner
   IF (Csxi1_p(i) <= 0.0) THEN
      theta1=((T_night**4.0 -                             &
           (T_day**4.0 - T_night**4.0)                    &
           * Csxi1_p(i) * Csxi2_p(j))**0.25)              &
           / exner_theta_levels(i,j,k) 
   ELSE
      theta1=T_night / exner_theta_levels(i,j,k)
   END IF
   theta_out=theta1
ELSE IF (tforce_number == tf_HD189733b_Showman) THEN
   ! HD189733b Model (Showman & Fortney, 2009)
   ! This profile may well be the same AS HD209458b
   ! But just call T_night and T_day differently
   ! Therefore include it with an AND in clause above
   WRITE(6,*) 'HD189733b T-P PROFILE NOT YET INCLUDED'
   STOP
ELSE IF (tforce_number == tf_Jupiter) THEN
   ! Simple Jupiter Profile
   WRITE(6,*) 'JUPITER T-P PROFILE NOT YET INCLUDED'
   STOP
ELSE
   WRITE(6,*) 'Temperature Profile for Forcing not known:', tforce_number
   STOP
ENDIF
equilibrium_theta=theta_out
RETURN
END FUNCTION equilibrium_theta

! ----------------------------------------------------------------------
! FUNCTIONS: 2. Derive relaxation timescale
! ----------------------------------------------------------------------

REAL FUNCTION recip_relaxation_tscale(trelax_number, i, j, k,       &
     exner_theta_levels, theta)
! This function returns the relaxation timescale
! for the trelax_number, at position
! i,j,k
! INPUT
INTEGER :: trelax_number 
INTEGER :: i,j,k
REAL    :: exner_theta_levels(tdims_s%i_start:tdims_s%i_end,        &
                     tdims_s%j_start:tdims_s%j_end,                 &
                     tdims_s%k_start:tdims_s%k_end) 
REAL    :: theta(tdims_s%i_start:tdims_s%i_end,                     &
                     tdims_s%j_start:tdims_s%j_end,                 &
                     tdims_s%k_start:tdims_s%k_end )
! LOCAL VARIABLES
! The level weighting for Held-Suarez Relaxation scheme
REAL :: sigma          ! The relative pressure of the level
REAL :: SuHe_level_weight, temp_weight
REAL :: SuHe_sigma_cutoff
REAL :: SuHe_newtonian_timescale_ka, SuHe_newtonian_timescale_ks
REAL :: recip_tscale_out


IF (trelax_number == tr_HeldSuarez) THEN
   ! Held-Suarez (Held & Suarez, 1995)
   !     sigma_b
   SuHe_sigma_cutoff = 0.7
   
   ! 1/40 day**-1 = 1/(40*86400) 1/s
   SuHe_newtonian_timescale_ka = 1./(40.*86400.)
   SuHe_newtonian_timescale_ks = 1./(4.*86400.)
   ! Derive sigma level
   sigma=(exner_theta_levels(i,j,k) /                        &
        exner_theta_levels(i,j,0))**recip_kappa
   ! Create the level weighting
   temp_weight = ( sigma - SuHe_sigma_cutoff)  /             &
        ( 1.0   - SuHe_sigma_cutoff)            
   SuHe_level_weight = MAX(0.0, temp_weight)
   ! Calculate the timescale
   recip_tscale_out = SuHe_newtonian_timescale_ka            &
        + ( SuHe_newtonian_timescale_ks -                    &
        SuHe_newtonian_timescale_ka )                        &
        * Csxi2_p(j) ** 4                                    &
        * SuHe_level_weight
ELSE IF (trelax_number == tr_EL .or. trelax_number == tr_SHJ) THEN
   ! Tidally-Locked Earth (Merlis & Schneider, 2010)
   ! Heng et al (2011) use constant tau_rad
   ! of 15 days, therefore  1.296e6 seconds
   ! Reciprocate
   IF (trelax_number == tr_EL)  recip_tscale_out=1.0/1.296e6
   ! Shallow-Hot-Jupiter (Menou & Rauscher, 2009)
   ! Heng et al (2011) use pi/Rotation period~1.731 days, 
   ! therefore 1.49558e5 seconds
   ! Again reciprocate
   IF (trelax_number == tr_SHJ)  recip_tscale_out=1.0/1.49558e5
ELSE IF (trelax_number == tr_Jupiter) THEN
   WRITE(6,*) 'JUPITER RELAXATION PROFILE NOT YET INCLUDED'
   STOP
ELSE IF (trelax_number == tr_HD209458b_Iro) THEN
   ! Relaxation timescale computed by Iro et al (2005)
   ! used in Heng et al (2011)
   ! Derive the radiative timescale at
   ! this pressure
   recip_tscale_out=recip_newt_tscale_iro(                &
        exner_theta_levels(i,j,k)) 
ELSE IF (trelax_number == tr_HD209458b_Showman .or.       &
     trelax_number == tr_HD189733b_Showman) THEN
   ! Tabulated Relaxation timescale from Showman et al (2008)
   ! for HD209458b or HD1899733b Calculated by a function
   recip_tscale_out=recip_newt_tscale_showman(            &
        exner_theta_levels(i,j,k),                           &
        theta(i,j,k), trelax_number) 
ELSE
   WRITE(6,*) 'Temperature Relaxation Scheme not known ', trelax_number
   STOP
ENDIF

recip_relaxation_tscale=recip_tscale_out
RETURN
END FUNCTION recip_relaxation_tscale

! ----------------------------------------------------------------------
! FUNCTIONS: 3. Derive Hot Jupiter Night-Side Temperature
! ----------------------------------------------------------------------

REAL FUNCTION hot_jup_night_temp(exner_theta_levels, tforce_number)
! Function which returns the night side equilibrium temperature
! for the Hot Jupiter denoted by number (tforce_number) at pressure
! of exner_theta_levels

  REAL, INTENT (INOUT) :: exner_theta_levels
  INTEGER :: tforce_number

  ! LOCAL VARIABLES
  REAL :: log_sigma, pressure
  REAL :: P_low, P_high
  REAL :: T_night_active, T_night_inactive
  REAL :: Temp_low, alpha
  ! OUTPUT
  REAL :: T_night

  ! First construct the pressure variable
  pressure=(exner_theta_levels**recip_kappa)*p_zero
  ! Set some constants for the smoothing
  IF (tforce_number ==  tf_HD209458b_Heng_smooth) THEN
     Temp_low=250.0
     alpha=0.10
  END IF

  ! Now derive night side temperature
  IF (tforce_number == tf_HD209458b_Heng .OR. &
       tforce_number == tf_HD209458b_Heng_smooth) THEN
     ! From Heng et al (2011)
     ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
     ! Switch to inactive region at 10bar (1e6Pa)
     ! Set the pressure limits
     P_high=1.0e6
     P_low=0.1
     IF (tforce_number == tf_HD209458b_Heng_smooth) &
          P_low=100.0
     ! Calculate the log_sigma required for T_night_active
     IF (pressure >= P_high) THEN
        log_sigma=LOG10(P_high/1.0e5)
     ELSE IF (pressure <= P_low) THEN
        log_sigma=LOG10(P_low/1.0e5)
     ELSE
        log_sigma=LOG10(pressure/1.0e5)
     END IF
     T_night_active=(1388.2145+267.66586*log_sigma &
          -215.53357*(log_sigma**2.0)              &
          +61.814807*(log_sigma**3.0)              &
          +135.68661*(log_sigma**4.0)              &
          +2.0149044*(log_sigma**5.0)              &
          -40.907246*(log_sigma**6.0)              &
          -19.015628*(log_sigma**7.0)              &
          -3.8771634*(log_sigma**8.0)              &
          -0.38413901*(log_sigma**9.0)             &
          -0.015089084*(log_sigma**10.0))     
     ! Now calculate the Inactive Region
     IF (pressure > P_high) THEN
        log_sigma=LOG10(pressure/1.0e5)
        T_night_inactive=                          & 
             (5529.7168-6869.6504*log_sigma        &
             +4142.7231*(log_sigma**2.0)           &
             -936.23053*(log_sigma**3.0)           &
             +87.120975*(log_sigma**4.0))  
     ELSE 
        T_night_inactive=0.0
     END IF
     ! Now construct the output temperature
     IF (pressure > P_high) THEN
        IF (tforce_number == tf_HD209458b_Heng) THEN
           T_night=T_night_inactive
        ELSE IF (tforce_number == tf_HD209458b_Heng_smooth) THEN
           T_night=T_night_active+100.0*&
                (1.0-EXP(-1.0*(LOG10(pressure)-LOG10(P_high))))
        END IF
     ELSE IF (pressure < P_low) THEN
        IF (tforce_number == tf_HD209458b_Heng) THEN
           T_night=T_night_active
        ELSE IF (tforce_number == tf_HD209458b_Heng_smooth) THEN
           T_night=&
                MAX(T_night_active*&
                EXP(alpha*(LOG10(pressure)-LOG10(P_low))), Temp_low)
        END IF
     ELSE
        T_night=T_night_active     
     ENDIF
  ELSE
     WRITE(6,*) 'Hot Jupiter Night Profile not Supported:', tforce_number     
     STOP
  END IF
  hot_jup_night_temp=T_night
  RETURN
END FUNCTION hot_jup_night_temp

! ----------------------------------------------------------------------
! FUNCTIONS: 4. Derive Hot Jupiter Day-Side Temperature
! ----------------------------------------------------------------------

REAL FUNCTION hot_jup_day_temp(exner_theta_levels, tforce_number)
! Function which returns the day side equilibrium temperature
! for the Hot Jupiter denoted by number (tforce_number) at pressure
! of exner_theta_levels (at the hot spot)

  REAL, INTENT (INOUT) :: exner_theta_levels
  INTEGER :: tforce_number  
  
  ! LOCAL VARIABLES
  REAL :: log_sigma, pressure
  REAL :: T_day_active, T_day_inactive
  REAL :: P_low, P_high
  REAL :: Temp_low, alpha
  ! OUTPUT
  REAL :: T_day

  ! First construct the pressure variable
  pressure=(exner_theta_levels**recip_kappa)*p_zero
  ! Set some constants for the smoothing
  IF (tforce_number ==  tf_HD209458b_Heng_smooth) THEN
     Temp_low=1000.0
     alpha=0.015
  END IF

  ! Now derive day side temperature
  IF (tforce_number == tf_HD209458b_Heng .OR. &
       tforce_number ==  tf_HD209458b_Heng_smooth) THEN
     ! From Heng et al (2011)
     ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
     ! Switch to inactive region at 10bar (1e6Pa)
     ! Set the pressure limits
     P_high=1.0e6
     P_low=0.1
     IF (tforce_number == tf_HD209458b_Heng_smooth) &
          P_low=100.0
     ! Calculate the log_sigma required for T_day_active
     IF (pressure >= P_high) THEN
        log_sigma=LOG10(P_high/1.0e5)
     ELSE IF (pressure <= P_low) THEN
        log_sigma=LOG10(P_low/1.0e5)
     ELSE
        log_sigma=LOG10(pressure/1.0e5)
     END IF
     T_day_active=(2149.9581+4.1395571*(log_sigma) &
          -186.24851*(log_sigma**2.0)              &
          +135.52524*(log_sigma**3.0)              &
          +106.20433*(log_sigma**4.0)              &
          -35.851966*(log_sigma**5.0)              &
          -50.022826*(log_sigma**6.0)              &
          -18.462489*(log_sigma**7.0)              &
          -3.3319965*(log_sigma**8.0)              &
          -0.30295925*(log_sigma**9.0)             &
          -0.011122316*(log_sigma**10.0))  
     ! Now calculate the Inactive Region
     IF (pressure > P_high) THEN
        log_sigma=LOG10(pressure/1.0e5)
        T_day_inactive=                            &
             (5529.7168-6869.6504*log_sigma        &
             +4142.7231*(log_sigma**2.0)           &
             -936.23053*(log_sigma**3.0)           &
             +87.120975*(log_sigma**4.0))  
     ELSE 
        T_day_inactive=0.0
     END IF
     ! Now construct the output temperature
     IF (pressure > P_high) THEN
        IF (tforce_number == tf_HD209458b_Heng) THEN
           T_day=T_day_inactive
        ELSE IF (tforce_number == tf_HD209458b_Heng_smooth) THEN
           T_day=T_day_active-120.0*&
                (1.0-EXP(-1.0*(LOG10(pressure)-LOG10(P_high))))
        END IF
     ELSE IF (pressure < P_low) THEN
        IF (tforce_number == tf_HD209458b_Heng) THEN
           T_day=T_day_active
        ELSE IF (tforce_number == tf_HD209458b_Heng_smooth) THEN
           T_day=&
                max(T_day_active*&
                EXP(alpha*(LOG10(pressure)-LOG10(P_low))), Temp_low)
        END IF
     ELSE
        T_day=T_day_active     
     ENDIF
  ELSE
     WRITE(6,*) 'Hot Jupiter Day Profile not Supported:', tforce_number     
     STOP
  END IF
  hot_jup_day_temp=T_day
  RETURN
END FUNCTION hot_jup_day_temp


! ----------------------------------------------------------------------
! FUNCTIONS: 5. IRO Temp HD209458b
! ----------------------------------------------------------------------

REAL FUNCTION iro_HD209458b_temp(exner_theta_levels, tforce_number)
! Function which returns the Temperature for the radiative 
! equilibrium solution of Iro et al (2005) for HD209458b

  REAL, INTENT (INOUT) :: exner_theta_levels
  INTEGER :: tforce_number  
  
  ! LOCAL VARIABLES
  REAL :: log_sigma, pressure
  REAL :: P_low, P_high
  ! OUTPUT
  REAL :: T_iro

  ! IF WE USE THIS IT WILL NEED TO BE SMOOTHED****

  ! First construct the pressure variable
  pressure=(exner_theta_levels**recip_kappa)*p_zero
  IF (tforce_number == tf_HD209458b_iro) THEN
     ! Now set validity limits
     ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
     P_high=3488e5
     P_low=0.1
     IF (pressure >= P_high) THEN
        log_sigma=LOG10(P_high/1.0e5)
     ELSE IF (pressure <= P_low) THEN
        log_sigma=LOG10(P_low/1.0e5)
     ELSE
        log_sigma=LOG10(pressure/1.0e5)
     END IF
     ! Now calculate the Iro Temperature
     T_iro=(1696.6986+132.23180*(log_sigma)        &
          -174.30459*(log_sigma**2.0)              &
          +12.579612*(log_sigma**3.0)              &
          +59.513639*(log_sigma**4.0)              &
          +9.6706522*(log_sigma**5.0)              &
          -4.1136048*(log_sigma**6.0)              &
          -1.0632301*(log_sigma**7.0)              &
          +0.064400203*(log_sigma**8.0)            &
          +0.035974396*(log_sigma**9.0)            &
          +0.0025740066*(log_sigma**10.0))  
  ELSE
     WRITE(6,*) 'HD209458b IRO profile not Supported:', tforce_number     
     STOP
  END IF
  iro_HD209458b_temp=T_iro
  RETURN
END FUNCTION iro_HD209458b_temp

! ----------------------------------------------------------------------
! FUNCTIONS: 6. Derive Hot Jupiter Relaxation Timescale Iro et al (2005)
! ----------------------------------------------------------------------

REAL FUNCTION recip_newt_tscale_iro(exner_theta_levels)
! Function which returns the reciprocal of the relaxation timescale
! or radiative timescale at the pressure (exner_theta_levels) for
! the profile of Iro et al (2005) for HD209458b

  REAL, INTENT (INOUT) :: exner_theta_levels

  ! LOCAL VARIABLES
  REAL :: log_sigma, pressure
  ! OUTPUT
  REAL :: recip_newt_tscale

  ! 1.0 Start of function code: perform the calculation.
  ! First construct the pressure variable
  pressure=(exner_theta_levels**recip_kappa)*p_zero

  ! P>10bar, inactive core
  ! Heng et al (2011) gives log(tau_rad)
  ! We need 1/T_rad, s**-1 (so conversion included)
  ! Heng et al (2011) States that the fit for relaxation time
  ! is valid for 10 microbar (1Pa) <P<8.5bar (8.5e5Pa)
  ! I am not sure what this means you should do between 
  ! 8.5 and 10 bar
  IF (pressure < 1.0e6) THEN
     ! If the pressure gets to low cap the relaxation time
     ! at the value at 10microbar
     IF (pressure < 1.0) pressure=1.0
     ! Construct the pressure variable
     ! From Heng et al (2011) =log(P/1bar) (1bar=1.0e5 pa)
     log_sigma=LOG10(pressure/1.0e5)
     recip_newt_tscale=1.0/(10.0**(5.4659686+1.4940124*log_sigma    &
          +0.66079196*(log_sigma**2.0)+0.16475329*(log_sigma**3.0)    &
          +0.014241552*(log_sigma**4.0)))
  ELSE
     recip_newt_tscale=0.0
  END IF
  recip_newt_tscale_iro=recip_newt_tscale
  RETURN
END FUNCTION recip_newt_tscale_iro

! ----------------------------------------------------------------------
! FUNCTIONS: 7. Derive Hot Jupiter Relaxation Timescale Showman et al (2008)
! ----------------------------------------------------------------------

REAL FUNCTION recip_newt_tscale_showman(exner_theta_levels, theta_star, &
     trelax_number)
! Function which returns the reciprocal of the relaxation timescale
! or radiative timescale at the pressure (exner_theta_levels)
! and temperature (from theta_star) 
! interpolated from the tables of Showman et al (2008)

  REAL, INTENT (INOUT) :: exner_theta_levels, theta_star
  INTEGER :: trelax_number

  ! LOCAL VARIABLES
  REAL :: log_sigma, pressure, temperature
  ! TABLE HOLDING VARIABLES
  INTEGER :: n_press
  REAL, DIMENSION(:), ALLOCATABLE :: p_bar
  INTEGER :: n_temp
  REAL, DIMENSION(:), ALLOCATABLE  :: T_kelvin
  REAL, DIMENSION(:,:), ALLOCATABLE  :: recip_tau_rad
  ! INTERPOLATION VARIABLES
  INTEGER :: i
  REAL :: diff_p, diff_T, eta_T, eta_p
  REAL  :: p_bot, p_top, T_bot, T_top
  INTEGER :: p_loc, p_inc, T_loc, T_inc
  REAL, DIMENSION(2) :: interp_T
  ! OUTPUT
  REAL :: recip_newt_tscale

  ! First construct the pressure
  ! and temperature variables
  pressure=(exner_theta_levels**recip_kappa)*p_zero
  temperature=exner_theta_levels*theta_star

  ! WHICH PLANET/PROFILE
  ! Set up tables
  IF (trelax_number == tr_HD209458b_Showman) THEN
     n_press=21
     n_temp=10
     allocate(T_kelvin(n_temp),p_bar(n_press),&
          recip_tau_rad(n_temp,n_press))
     ! Initialise
     recip_tau_rad(:,:)=0.0
     ! The timescale table from Showman et al (2008)
     p_bar(1)=0.00066
     p_bar(2)=0.00110
     p_bar(3)=0.00182
     p_bar(4)=0.00302
     p_bar(5)=0.00501
     p_bar(6)=0.00832
     p_bar(7)=0.01380
     p_bar(8)=0.02291
     p_bar(9)=0.03802
     p_bar(10)=0.06310
     p_bar(11)=0.10471
     p_bar(12)=0.17378
     p_bar(13)=0.28840
     p_bar(14)=0.47863
     p_bar(15)=0.79433
     p_bar(16)=1.31826
     p_bar(17)=2.18776
     p_bar(18)=3.63078
     p_bar(19)=6.02560
     p_bar(20)=10.00000
     p_bar(21)=16.59590
     do i=1, n_temp
        T_kelvin(i)=400.0+(i-1)*200.0
     end do
     !400K
     recip_tau_rad(1,1)=1.0/6.05e5
     recip_tau_rad(1,2)=1.0/6.16e5
     recip_tau_rad(1,3)=1.0/5.99e5
     recip_tau_rad(1,4)=1.0/5.20e5
     recip_tau_rad(1,5)=1.0/4.49e5
     recip_tau_rad(1,6)=1.0/4.20e5
     recip_tau_rad(1,7)=1.0/4.21e5
     recip_tau_rad(1,8)=1.0/4.57e5
     recip_tau_rad(1,9)=1.0/5.49e5
     recip_tau_rad(1,10)=1.0/6.72e5
     recip_tau_rad(1,11)=1.0/7.98e5
     recip_tau_rad(1,12)=1.0/8.85e5
     recip_tau_rad(1,13)=1.0/9.35e5
     recip_tau_rad(1,14)=1.0/9.14e5
     !600K
     recip_tau_rad(2,1)=1.0/1.16e4
     recip_tau_rad(2,2)=1.0/1.51e4
     recip_tau_rad(2,3)=1.0/1.99e4
     recip_tau_rad(2,4)=1.0/2.69e4
     recip_tau_rad(2,5)=1.0/3.51e4
     recip_tau_rad(2,6)=1.0/4.75e4
     recip_tau_rad(2,7)=1.0/6.34e4
     recip_tau_rad(2,8)=1.0/8.48e4
     recip_tau_rad(2,9)=1.0/1.16e5
     recip_tau_rad(2,10)=1.0/2.45e5
     recip_tau_rad(2,11)=1.0/4.16e5
     recip_tau_rad(2,12)=1.0/5.81e5
     recip_tau_rad(2,13)=1.0/7.01e5
     recip_tau_rad(2,14)=1.0/7.71e5
     !800K
     recip_tau_rad(3,1)=1.0/6.36e3
     recip_tau_rad(3,2)=1.0/8.24e3
     recip_tau_rad(3,3)=1.0/1.03e4
     recip_tau_rad(3,4)=1.0/1.30e4
     recip_tau_rad(3,5)=1.0/1.56e4
     recip_tau_rad(3,6)=1.0/1.97e4
     recip_tau_rad(3,7)=1.0/2.59e4
     recip_tau_rad(3,8)=1.0/3.37e4
     recip_tau_rad(3,9)=1.0/4.72e4
     recip_tau_rad(3,10)=1.0/8.12e4
     recip_tau_rad(3,11)=1.0/1.45e5
     recip_tau_rad(3,12)=1.0/2.76e5
     recip_tau_rad(3,13)=1.0/4.67e5
     recip_tau_rad(3,14)=1.0/6.28e5
     recip_tau_rad(3,15)=1.0/1.02e6
     !1000K
     recip_tau_rad(4,1)=1.0/4.85e3
     recip_tau_rad(4,2)=1.0/6.50e3
     recip_tau_rad(4,3)=1.0/8.10e3
     recip_tau_rad(4,4)=1.0/1.05e4
     recip_tau_rad(4,5)=1.0/1.21e4
     recip_tau_rad(4,6)=1.0/1.50e4
     recip_tau_rad(4,7)=1.0/1.78e4
     recip_tau_rad(4,8)=1.0/2.29e4
     recip_tau_rad(4,9)=1.0/2.84e4
     recip_tau_rad(4,10)=1.0/3.52e4
     recip_tau_rad(4,11)=1.0/5.89e4
     recip_tau_rad(4,12)=1.0/1.33e5
     recip_tau_rad(4,13)=1.0/2.51e5
     recip_tau_rad(4,14)=1.0/4.84e5
     recip_tau_rad(4,15)=1.0/9.15e5
     recip_tau_rad(4,16)=1.0/1.63e6
     recip_tau_rad(4,17)=1.0/3.02e6
     !1200K
     recip_tau_rad(5,1)=1.0/2.33e3
     recip_tau_rad(5,2)=1.0/2.99e3
     recip_tau_rad(5,3)=1.0/3.90e3
     recip_tau_rad(5,4)=1.0/5.12e3
     recip_tau_rad(5,5)=1.0/6.36e3
     recip_tau_rad(5,6)=1.0/8.58e3
     recip_tau_rad(5,7)=1.0/1.07e4
     recip_tau_rad(5,8)=1.0/1.52e4
     recip_tau_rad(5,9)=1.0/1.82e4
     recip_tau_rad(5,10)=1.0/2.49e4
     recip_tau_rad(5,11)=1.0/3.45e4
     recip_tau_rad(5,12)=1.0/5.60e4
     recip_tau_rad(5,13)=1.0/1.04e5
     recip_tau_rad(5,14)=1.0/2.40e5
     recip_tau_rad(5,15)=1.0/6.17e5
     recip_tau_rad(5,16)=1.0/1.50e6
     recip_tau_rad(5,17)=1.0/2.99e6
     recip_tau_rad(5,18)=1.0/5.79e6
     !1400K
     recip_tau_rad(6,1)=1.0/1.19e3
     recip_tau_rad(6,2)=1.0/1.56e3
     recip_tau_rad(6,3)=1.0/2.03e3
     recip_tau_rad(6,4)=1.0/2.76e3
     recip_tau_rad(6,5)=1.0/3.49e3
     recip_tau_rad(6,6)=1.0/4.80e3
     recip_tau_rad(6,7)=1.0/6.39e3
     recip_tau_rad(6,8)=1.0/9.13e3
     recip_tau_rad(6,9)=1.0/1.26e4
     recip_tau_rad(6,10)=1.0/1.77e4
     recip_tau_rad(6,11)=1.0/2.61e4
     recip_tau_rad(6,12)=1.0/4.03e4
     recip_tau_rad(6,13)=1.0/6.93e4
     recip_tau_rad(6,14)=1.0/1.30e5
     recip_tau_rad(6,15)=1.0/2.91e5
     recip_tau_rad(6,16)=1.0/6.82e5
     recip_tau_rad(6,17)=1.0/1.76e6
     recip_tau_rad(6,18)=1.0/4.59e6
     recip_tau_rad(6,19)=1.0/8.87e6
     !1600K
     recip_tau_rad(7,1)=1.0/7.38e2
     recip_tau_rad(7,2)=1.0/9.47e2
     recip_tau_rad(7,3)=1.0/1.24e3
     recip_tau_rad(7,4)=1.0/1.68e3
     recip_tau_rad(7,5)=1.0/2.14e3
     recip_tau_rad(7,6)=1.0/2.89e3
     recip_tau_rad(7,7)=1.0/3.96e3
     recip_tau_rad(7,8)=1.0/5.57e3
     recip_tau_rad(7,9)=1.0/7.14e3
     recip_tau_rad(7,10)=1.0/1.03e4
     recip_tau_rad(7,11)=1.0/1.61e4
     recip_tau_rad(7,12)=1.0/2.69e4
     recip_tau_rad(7,13)=1.0/4.76e4
     recip_tau_rad(7,14)=1.0/9.06e4
     recip_tau_rad(7,15)=1.0/1.82e5
     recip_tau_rad(7,16)=1.0/4.03e5
     recip_tau_rad(7,17)=1.0/1.00e6
     recip_tau_rad(7,18)=1.0/2.61e6
     recip_tau_rad(7,19)=1.0/8.06e6
     !1800K
     recip_tau_rad(8,1)=1.0/5.40e2
     recip_tau_rad(8,2)=1.0/6.60e2
     recip_tau_rad(8,3)=1.0/8.52e2
     recip_tau_rad(8,4)=1.0/1.15e3
     recip_tau_rad(8,5)=1.0/1.52e3
     recip_tau_rad(8,6)=1.0/2.12e3
     recip_tau_rad(8,7)=1.0/2.85e3
     recip_tau_rad(8,8)=1.0/3.93e3
     recip_tau_rad(8,9)=1.0/5.39e3
     recip_tau_rad(8,10)=1.0/7.87e3
     recip_tau_rad(8,11)=1.0/1.17e4
     recip_tau_rad(8,12)=1.0/1.92e4
     recip_tau_rad(8,13)=1.0/3.52e4
     recip_tau_rad(8,14)=1.0/6.68e4
     recip_tau_rad(8,15)=1.0/1.32e5
     recip_tau_rad(8,16)=1.0/3.00e5
     recip_tau_rad(8,17)=1.0/7.67e5
     recip_tau_rad(8,18)=1.0/2.06e6
     recip_tau_rad(8,19)=1.0/6.51e6
     recip_tau_rad(8,20)=1.0/2.21e7
     !2000K
     recip_tau_rad(9,1)=1.0/4.38e2
     recip_tau_rad(9,2)=1.0/5.04e2
     recip_tau_rad(9,3)=1.0/6.47e2
     recip_tau_rad(9,4)=1.0/8.72e2
     recip_tau_rad(9,5)=1.0/1.21e3
     recip_tau_rad(9,6)=1.0/1.85e3
     recip_tau_rad(9,7)=1.0/2.59e3
     recip_tau_rad(9,8)=1.0/3.49e3
     recip_tau_rad(9,9)=1.0/4.79e3
     recip_tau_rad(9,10)=1.0/6.97e3
     recip_tau_rad(9,11)=1.0/1.01e4
     recip_tau_rad(9,12)=1.0/1.69e4
     recip_tau_rad(9,13)=1.0/2.67e4
     recip_tau_rad(9,14)=1.0/4.92e4
     recip_tau_rad(9,15)=1.0/1.03e5
     recip_tau_rad(9,16)=1.0/2.43e5
     recip_tau_rad(9,17)=1.0/6.93e5
     recip_tau_rad(9,18)=1.0/1.70e6
     recip_tau_rad(9,19)=1.0/6.19e6
     recip_tau_rad(9,20)=1.0/2.17e7
     recip_tau_rad(9,21)=1.0/7.01e7
     !2200K
     recip_tau_rad(10,1)=1.0/3.83e2
     recip_tau_rad(10,2)=1.0/4.11e2
     recip_tau_rad(10,3)=1.0/5.25e2
     recip_tau_rad(10,4)=1.0/7.11e2
     recip_tau_rad(10,5)=1.0/1.04e3
     recip_tau_rad(10,6)=1.0/1.82e3
     recip_tau_rad(10,7)=1.0/2.72e3
     recip_tau_rad(10,8)=1.0/3.66e3
     recip_tau_rad(10,9)=1.0/5.06e3
     recip_tau_rad(10,10)=1.0/7.42e3
     recip_tau_rad(10,11)=1.0/1.09e4
     recip_tau_rad(10,12)=1.0/1.77e4
     recip_tau_rad(10,13)=1.0/2.89e4
     recip_tau_rad(10,14)=1.0/4.82e4
     recip_tau_rad(10,15)=1.0/1.28e5
     recip_tau_rad(10,16)=1.0/5.90e5
     recip_tau_rad(10,17)=1.0/7.37e5
     recip_tau_rad(10,18)=1.0/1.66e6
     recip_tau_rad(10,19)=1.0/8.65e6
     recip_tau_rad(10,20)=1.0/3.60e7
     recip_tau_rad(10,21)=1.0/9.39e7
  ELSE IF (trelax_number == tr_HD189733b_Showman) THEN
     n_press=28
     n_temp=9
     allocate(T_kelvin(n_temp),p_bar(n_press),&
          recip_tau_rad(n_temp,n_press))
     ! Initialise
     recip_tau_rad(:,:)=0.0
     ! Setup up data from Table in Showman et al (2008)
     p_bar(1)=0.00066
     p_bar(2)=0.00110
     p_bar(3)=0.00182
     p_bar(4)=0.00302
     p_bar(5)=0.00501
     p_bar(6)=0.00832
     p_bar(7)=0.01380
     p_bar(8)=0.02291
     p_bar(9)=0.03802
     p_bar(10)=0.06310
     p_bar(11)=0.10471
     p_bar(12)=0.17378
     p_bar(13)=0.28840
     p_bar(14)=0.47863
     p_bar(15)=0.79433
     p_bar(16)=1.31826
     p_bar(17)=2.18776
     p_bar(18)=3.63078
     p_bar(19)=6.02560
     p_bar(20)=10.00000
     p_bar(21)=16.59590
     p_bar(22)=27.54230
     p_bar(23)=45.70880
     p_bar(24)=75.85780
     p_bar(25)=125.89300
     p_bar(26)=208.92999
     p_bar(27)=346.73700
     p_bar(28)=575.44000
     do i=1, n_temp
        T_kelvin(i)=400.0+(i-1)*200.0
     end do
     ! 400K
     recip_tau_rad(1,1)=1.0/2.58e6
     recip_tau_rad(1,2)=1.0/1.87e6
     recip_tau_rad(1,3)=1.0/1.53e6
     recip_tau_rad(1,4)=1.0/1.11e6
     recip_tau_rad(1,5)=1.0/9.54e5 
     recip_tau_rad(1,6)=1.0/1.05e6
     recip_tau_rad(1,7)=1.0/1.34e6
     recip_tau_rad(1,8)=1.0/1.78e6
     recip_tau_rad(1,9)=1.0/1.86e6
     recip_tau_rad(1,10)=1.0/2.22e6
     recip_tau_rad(1,11)=1.0/2.55e6
     recip_tau_rad(1,12)=1.0/3.55e6
     recip_tau_rad(1,13)=1.0/4.55e6
     recip_tau_rad(1,14)=1.0/5.60e6
     recip_tau_rad(1,15)=1.0/6.64e6
     recip_tau_rad(1,16)=1.0/7.61e6
     recip_tau_rad(1,17)=1.0/9.59e6
     recip_tau_rad(1,18)=1.0/2.52e7
     recip_tau_rad(1,19)=1.0/5.96e7
     recip_tau_rad(1,20)=1.0/1.67e8
     ! 600K
     recip_tau_rad(2,1)=1.0/7.40e3
     recip_tau_rad(2,2)=1.0/9.32e3
     recip_tau_rad(2,3)=1.0/1.19e4
     recip_tau_rad(2,4)=1.0/1.54e4
     recip_tau_rad(2,5)=1.0/1.94e4
     recip_tau_rad(2,6)=1.0/2.54e4
     recip_tau_rad(2,7)=1.0/3.27e4
     recip_tau_rad(2,8)=1.0/4.30e4
     recip_tau_rad(2,9)=1.0/5.77e4
     recip_tau_rad(2,10)=1.0/8.71e4
     recip_tau_rad(2,11)=1.0/1.44e5
     recip_tau_rad(2,12)=1.0/2.43e5
     recip_tau_rad(2,13)=1.0/7.25e5
     recip_tau_rad(2,14)=1.0/2.17e6
     recip_tau_rad(2,15)=1.0/3.78e6
     recip_tau_rad(2,16)=1.0/5.50e6
     recip_tau_rad(2,17)=1.0/7.73e6
     recip_tau_rad(2,18)=1.0/2.03e7
     recip_tau_rad(2,19)=1.0/5.22e7
     recip_tau_rad(2,20)=1.0/1.61e8
     recip_tau_rad(2,21)=1.0/4.91e8
     recip_tau_rad(2,22)=1.0/1.80e9
     ! 800K
     recip_tau_rad(3,1)=1.0/4.84e3
     recip_tau_rad(3,2)=1.0/6.48e3
     recip_tau_rad(3,3)=1.0/8.42e3
     recip_tau_rad(3,4)=1.0/1.07e4
     recip_tau_rad(3,5)=1.0/1.22e4
     recip_tau_rad(3,6)=1.0/1.42e4
     recip_tau_rad(3,7)=1.0/1.69e4
     recip_tau_rad(3,8)=1.0/2.05e4
     recip_tau_rad(3,9)=1.0/2.56e4
     recip_tau_rad(3,10)=1.0/3.64e4
     recip_tau_rad(3,11)=1.0/5.11e4
     recip_tau_rad(3,12)=1.0/1.03e5
     recip_tau_rad(3,13)=1.0/2.40e5
     recip_tau_rad(3,14)=1.0/4.30e5
     recip_tau_rad(3,15)=1.0/9.20e5
     recip_tau_rad(3,16)=1.0/3.39e6
     recip_tau_rad(3,17)=1.0/5.87e6
     recip_tau_rad(3,18)=1.0/1.47e7
     recip_tau_rad(3,19)=1.0/3.82e7
     recip_tau_rad(3,20)=1.0/1.15e8
     recip_tau_rad(3,21)=1.0/3.83e8
     recip_tau_rad(3,22)=1.0/1.70e9
     recip_tau_rad(3,23)=1.0/4.97e9
     ! 1000K
     recip_tau_rad(4,1)=1.0/3.33e3
     recip_tau_rad(4,2)=1.0/4.25e3
     recip_tau_rad(4,3)=1.0/5.44e3
     recip_tau_rad(4,4)=1.0/7.13e3
     recip_tau_rad(4,5)=1.0/8.34e3
     recip_tau_rad(4,6)=1.0/1.01e4
     recip_tau_rad(4,7)=1.0/1.14e4
     recip_tau_rad(4,8)=1.0/1.27e4
     recip_tau_rad(4,9)=1.0/1.44e4
     recip_tau_rad(4,10)=1.0/2.08e4
     recip_tau_rad(4,11)=1.0/3.02e4
     recip_tau_rad(4,12)=1.0/5.55e4
     recip_tau_rad(4,13)=1.0/1.00e5
     recip_tau_rad(4,14)=1.0/2.33e5
     recip_tau_rad(4,15)=1.0/5.28e5
     recip_tau_rad(4,16)=1.0/1.47e6
     recip_tau_rad(4,17)=1.0/4.02e6
     recip_tau_rad(4,18)=1.0/9.04e6
     recip_tau_rad(4,19)=1.0/2.42e7
     recip_tau_rad(4,20)=1.0/6.87e7
     recip_tau_rad(4,21)=1.0/2.20e8
     recip_tau_rad(4,22)=1.0/8.98e8
     recip_tau_rad(4,23)=1.0/3.54e9
     recip_tau_rad(4,24)=1.0/9.04e9
     recip_tau_rad(4,25)=1.0/1.02e10
     ! 1200K
     recip_tau_rad(5,1)=1.0/1.61e3
     recip_tau_rad(5,2)=1.0/2.08e3
     recip_tau_rad(5,3)=1.0/2.65e3
     recip_tau_rad(5,4)=1.0/3.43e3
     recip_tau_rad(5,5)=1.0/4.26e3
     recip_tau_rad(5,6)=1.0/5.50e3
     recip_tau_rad(5,7)=1.0/6.79e3
     recip_tau_rad(5,8)=1.0/8.95e3
     recip_tau_rad(5,9)=1.0/1.12e4
     recip_tau_rad(5,10)=1.0/1.39e4
     recip_tau_rad(5,11)=1.0/1.76e4
     recip_tau_rad(5,12)=1.0/2.74e4
     recip_tau_rad(5,13)=1.0/5.43e4
     recip_tau_rad(5,14)=1.0/9.63e4
     recip_tau_rad(5,15)=1.0/2.15e5
     recip_tau_rad(5,16)=1.0/5.06e5
     recip_tau_rad(5,17)=1.0/1.34e6
     recip_tau_rad(5,18)=1.0/3.74e6
     recip_tau_rad(5,19)=1.0/9.70e6
     recip_tau_rad(5,20)=1.0/2.72e7
     recip_tau_rad(5,21)=1.0/8.97e7
     recip_tau_rad(5,22)=1.0/3.25e8
     recip_tau_rad(5,23)=1.0/1.23e9
     recip_tau_rad(5,24)=1.0/4.69e9
     recip_tau_rad(5,25)=1.0/1.03e10 
     recip_tau_rad(5,26)=1.0/9.10e9
     ! 1400K
     recip_tau_rad(6,1)=1.0/7.84e2
     recip_tau_rad(6,2)=1.0/1.03e3
     recip_tau_rad(6,3)=1.0/1.34e3
     recip_tau_rad(6,4)=1.0/1.78e3
     recip_tau_rad(6,5)=1.0/2.28e3
     recip_tau_rad(6,6)=1.0/3.00e3
     recip_tau_rad(6,7)=1.0/3.82e3
     recip_tau_rad(6,8)=1.0/5.31e3
     recip_tau_rad(6,9)=1.0/7.00e3
     recip_tau_rad(6,10)=1.0/8.90e3
     recip_tau_rad(6,11)=1.0/1.33e4
     recip_tau_rad(6,12)=1.0/1.88e4
     recip_tau_rad(6,13)=1.0/3.01e4
     recip_tau_rad(6,14)=1.0/4.94e4
     recip_tau_rad(6,15)=1.0/1.03e5
     recip_tau_rad(6,16)=1.0/2.58e5
     recip_tau_rad(6,17)=1.0/6.56e5
     recip_tau_rad(6,18)=1.0/1.68e6
     recip_tau_rad(6,19)=1.0/4.37e6
     recip_tau_rad(6,20)=1.0/1.30e7
     recip_tau_rad(6,21)=1.0/4.55e7
     recip_tau_rad(6,22)=1.0/1.70e8
     recip_tau_rad(6,23)=1.0/6.43e8
     recip_tau_rad(6,24)=1.0/2.43e9
     recip_tau_rad(6,25)=1.0/8.99e9
     recip_tau_rad(6,26)=1.0/1.05e10
     ! 1600K
     recip_tau_rad(7,1)=1.0/4.25e2
     recip_tau_rad(7,2)=1.0/5.73e2
     recip_tau_rad(7,3)=1.0/7.58e2
     recip_tau_rad(7,4)=1.0/1.05e3
     recip_tau_rad(7,5)=1.0/1.35e3
     recip_tau_rad(7,6)=1.0/1.77e3
     recip_tau_rad(7,7)=1.0/2.25e3
     recip_tau_rad(7,8)=1.0/2.93e3
     recip_tau_rad(7,9)=1.0/3.94e3
     recip_tau_rad(7,10)=1.0/5.38e3
     recip_tau_rad(7,11)=1.0/7.97e3
     recip_tau_rad(7,12)=1.0/1.23e4
     recip_tau_rad(7,13)=1.0/1.97e4
     recip_tau_rad(7,14)=1.0/3.52e4
     recip_tau_rad(7,15)=1.0/6.57e4
     recip_tau_rad(7,16)=1.0/1.30e5
     recip_tau_rad(7,17)=1.0/2.89e5
     recip_tau_rad(7,18)=1.0/6.95e5
     recip_tau_rad(7,19)=1.0/1.87e6
     recip_tau_rad(7,20)=1.0/5.86e6
     recip_tau_rad(7,21)=1.0/2.18e7
     recip_tau_rad(7,22)=1.0/8.51e7
     recip_tau_rad(7,23)=1.0/3.31e8
     recip_tau_rad(7,24)=1.0/1.30e9
     recip_tau_rad(7,25)=1.0/5.10e9
     recip_tau_rad(7,26)=1.0/1.98e10
     recip_tau_rad(7,27)=1.0/9.19e9
     ! 1800K
     recip_tau_rad(8,1)=1.0/2.45e2
     recip_tau_rad(8,2)=1.0/3.38e2
     recip_tau_rad(8,3)=1.0/4.58e2
     recip_tau_rad(8,4)=1.0/6.66e2
     recip_tau_rad(8,5)=1.0/8.60e2
     recip_tau_rad(8,6)=1.0/1.11e3
     recip_tau_rad(8,7)=1.0/1.39e3
     recip_tau_rad(8,8)=1.0/1.67e3
     recip_tau_rad(8,9)=1.0/2.18e3
     recip_tau_rad(8,10)=1.0/3.12e3
     recip_tau_rad(8,11)=1.0/5.15e3
     recip_tau_rad(8,12)=1.0/8.52e3
     recip_tau_rad(8,13)=1.0/1.42e4
     recip_tau_rad(8,14)=1.0/2.58e4
     recip_tau_rad(8,15)=1.0/4.76e4
     recip_tau_rad(8,16)=1.0/9.42e4
     recip_tau_rad(8,17)=1.0/2.07e5
     recip_tau_rad(8,18)=1.0/5.34e5
     recip_tau_rad(8,19)=1.0/1.52e6
     recip_tau_rad(8,20)=1.0/5.08e6
     recip_tau_rad(8,21)=1.0/1.86e7
     recip_tau_rad(8,22)=1.0/6.80e7
     recip_tau_rad(8,23)=1.0/2.60e8
     recip_tau_rad(8,24)=1.0/1.02e9
     recip_tau_rad(8,25)=1.0/3.98e9
     recip_tau_rad(8,26)=1.0/1.51e10
     recip_tau_rad(8,27)=1.0/5.67e10
     recip_tau_rad(8,28)=1.0/1.54e10
     ! 2000K
     recip_tau_rad(8,1)=1.0/1.49e2
     recip_tau_rad(8,2)=1.0/2.09e2
     recip_tau_rad(8,3)=1.0/2.91e2
     recip_tau_rad(8,4)=1.0/4.48e2
     recip_tau_rad(8,5)=1.0/5.76e2
     recip_tau_rad(8,6)=1.0/7.24e2
     recip_tau_rad(8,7)=1.0/8.95e2
     recip_tau_rad(8,8)=1.0/9.79e2
     recip_tau_rad(8,9)=1.0/1.20e3
     recip_tau_rad(8,10)=1.0/1.80e3
     recip_tau_rad(8,11)=1.0/3.39e3
     recip_tau_rad(8,12)=1.0/6.20e3
     recip_tau_rad(8,13)=1.0/1.07e4
     recip_tau_rad(8,14)=1.0/2.02e4
     recip_tau_rad(8,15)=1.0/3.63e4
     recip_tau_rad(8,16)=1.0/7.01e4
     recip_tau_rad(8,17)=1.0/1.52e5
     recip_tau_rad(8,18)=1.0/4.36e5
     recip_tau_rad(8,19)=1.0/1.40e6
     recip_tau_rad(8,20)=1.0/5.59e6
     recip_tau_rad(8,21)=1.0/1.97e7
     recip_tau_rad(8,22)=1.0/6.68e7
     recip_tau_rad(8,23)=1.0/2.39e8
     recip_tau_rad(8,24)=1.0/8.98e8
     recip_tau_rad(8,25)=1.0/3.41e9
     recip_tau_rad(8,26)=1.0/1.32e10
     recip_tau_rad(8,27)=1.0/5.14e10
     recip_tau_rad(8,28)=1.0/1.30e11     
  ELSE
     WRITE(6,*) 'Relaxation profile not supported:', trelax_number
  END IF
  ! Now perform interpolation ot required values
  ! Find the closest pressure (whilst converting to bar)
  p_loc=MINLOC(ABS(p_bar(:)-pressure),1)
  diff_p=pressure-p_bar(p_loc)
  ! Now the Temperature
  T_loc=MINLOC(ABS(T_kelvin(:)-temperature),1)
  diff_T=temperature-T_kelvin(T_loc)
  ! Now we check if we are at the edges
  ! Pressure Limits First, over top or
  ! under bottom just use top or bottom value
  ! Otherwise Find interpolation point
  IF (diff_p < 0.0) THEN
     IF (p_loc == 1) THEN
        p_inc=0
     ELSE
        p_inc=-1
     ENDIF
  ELSE IF (diff_p > 0.0) THEN
     IF (p_loc == n_press) THEN
        p_inc=0
     ELSE
        p_inc=+1
     ENDIF
  ENDIF
  ! Same for temperature
  IF (diff_T < 0.0) THEN
     IF (T_loc == 1) THEN
        T_inc=0
     ELSE
        T_inc=-1
     ENDIF
  ELSE IF (diff_T > 0.0) THEN
     IF (T_loc == n_temp) THEN
        T_inc=0
     ELSE
        T_inc=+1
     ENDIF
  ENDIF
  ! Now perform the interpolation
  ! First interpolate for the pressure points at both
  ! bounding temperatures
  ! Pressure weighting
  IF (p_inc == 0) THEN
     eta_p=0.5
  ELSE
     IF (p_inc == +1) THEN
        p_bot=p_bar(p_loc)
        p_top=p_bar(p_loc+p_inc)
     ELSE IF (p_inc == -1) THEN
        p_bot=p_bar(p_loc+p_inc)
        p_top=p_bar(p_loc)
     ENDIF
     eta_p=(pressure-p_bot)/&
          (p_top-p_bot)
  ENDIF

  ! Now interpolate for pressure
  IF (p_inc == 0 .or. p_inc == +1) THEN
     interp_T(1)=(1.0-eta_p)*recip_tau_rad(T_loc,p_loc)+&
          eta_p*recip_tau_rad(T_loc,p_loc+p_inc)
     interp_T(2)=(1.0-eta_p)*recip_tau_rad(T_loc+T_inc,p_loc)+&
          eta_p*recip_tau_rad(T_loc+T_inc,p_loc+p_inc)
  ELSE
     interp_T(1)=(1.0-eta_p)*recip_tau_rad(T_loc,p_loc+p_inc)+&
          eta_p*recip_tau_rad(T_loc,p_loc)
     interp_T(2)=(1.0-eta_p)*recip_tau_rad(T_loc+T_inc,p_loc+p_inc)+&
          eta_p*recip_tau_rad(T_loc+T_inc,p_loc)
  ENDIF
  ! Temperature weightings
  IF (T_inc == 0) THEN
     eta_T=0.5
  ELSE
     IF (T_inc == +1) THEN
        T_bot=T_kelvin(T_loc)
        T_top=T_kelvin(T_loc+T_inc)
     ELSE IF (T_inc == -1) THEN
        T_bot=T_kelvin(T_loc+T_inc)
        T_top=T_kelvin(T_loc)
     ENDIF
     eta_T=(temperature-T_bot)/&
          (T_top-T_bot)
  ENDIF
  ! Now interpolate for the Temperature
  IF (T_inc == 0 .or. T_inc == +1) THEN
     recip_newt_tscale=(1.0-eta_T)*interp_T(1)+&
          eta_T*interp_T(2)
  ELSE
     recip_newt_tscale=(1.0-eta_T)*interp_T(2)+&
          eta_T*interp_T(1)
  ENDIF
  DEALLOCATE(T_kelvin,p_bar,recip_tau_rad)
  recip_newt_tscale_showman=recip_newt_tscale
  RETURN
END FUNCTION recip_newt_tscale_showman
END MODULE non_um_eg_idl_theta_forcing_mod
