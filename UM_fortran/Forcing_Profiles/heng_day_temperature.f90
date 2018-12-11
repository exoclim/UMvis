module heng_day_temperature

  IMPLICIT NONE

CONTAINS

  REAL FUNCTION hot_jup_day_temp(pressure_in, smooth)
    ! Function returning the day side temperature for a given
    ! pressure following Heng et al (2011), including the smoothing
    ! of Mayne et al (2014) if required

    ! Input
    real :: pressure_in
    logical :: smooth

    ! LOCAL VARIABLES
    REAL :: log_sigma, pressure, log_sigma_inactive
    REAL :: T_day_active, T_day_inactive
    REAL :: P_low, P_high
    REAL :: Temp_low, alpha
    ! OUTPUT
    REAL :: T_day

    ! Create a local pressure variable
    pressure=pressure_in

    ! Set some constants
    ! Heng et al (2011) polynomial fits
    ! are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
    ! Switch to inactive region at 10bar (1e6Pa)
    ! Set the pressure limits
    P_high=1.0e6
    P_low=0.1
    IF (smooth) then
       Temp_low=1000.0
       alpha=0.015
       P_low=100.0
    endif

    ! Calculate the log_sigma required for T_day_active
    IF (pressure >= P_high) THEN
       log_sigma=LOG10(P_high/1.0e5)
    ELSE IF (pressure <= P_low) THEN
       log_sigma=LOG10(P_low/1.0e5)
    ELSE
       log_sigma=LOG10(pressure/1.0e5)
    END IF

    ! Calculate the temperature in the active region
    T_day_active=hd209458b_heng_active_day(log_sigma)

    ! Now calculate the Inactive Region
    IF (pressure > P_high) THEN
       ! Use a different log_sigma to stop confusion
       log_sigma_inactive=LOG10(pressure/1.0e5)
       T_day_inactive=hd209458b_heng_inactive_day(log_sigma_inactive)
    ELSE 
       T_day_inactive=0.0
    END IF

    ! Now construct the output temperature
    IF (pressure > P_high) THEN
       if (smooth) then
          T_day=T_day_active-120.0*&
               (1.0-EXP(-1.0*(LOG10(pressure)-LOG10(P_high))))
       else
          T_day=T_day_inactive
       end if
    ELSE IF (pressure < P_low) THEN
       if (smooth) then
          T_day=&
               max(T_day_active*&
               EXP(alpha*(LOG10(pressure)-LOG10(P_low))), Temp_low)
       else
          T_day=T_day_active
       end if
    ELSE
       T_day=T_day_active     
    ENDIF
    hot_jup_day_temp=T_day
    RETURN
  END FUNCTION hot_jup_day_temp

  real function hd209458b_heng_active_day(log_sigma)
    ! The equation for temperature in the active region
    real :: log_sigma

    hd209458b_heng_active_day=(2149.9581+4.1395571*(log_sigma) &
         -186.24851*(log_sigma**2.0)              &
         +135.52524*(log_sigma**3.0)              &
         +106.20433*(log_sigma**4.0)              &
         -35.851966*(log_sigma**5.0)              &
         -50.022826*(log_sigma**6.0)              &
         -18.462489*(log_sigma**7.0)              &
         -3.3319965*(log_sigma**8.0)              &
         -0.30295925*(log_sigma**9.0)             &
         -0.011122316*(log_sigma**10.0)) 
    return
  end function hd209458b_heng_active_day

  real function hd209458b_heng_inactive_day(log_sigma)
    ! The equation for temperature in the inactive region
    real :: log_sigma

    hd209458b_heng_inactive_day=(5529.7168-6869.6504*log_sigma &
         +4142.7231*(log_sigma**2.0)    &
         -936.23053*(log_sigma**3.0)    &
         +87.120975*(log_sigma**4.0))      
    return
  end function hd209458b_heng_inactive_day

end module heng_day_temperature
