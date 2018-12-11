module heng_night_temperature

  IMPLICIT NONE

CONTAINS

  REAL FUNCTION hot_jup_night_temp(pressure_in, smooth)
    ! Function returning the night side temperature for a given
    ! pressure following Heng et al (2011), including the smoothing
    ! of Mayne et al (2014) if required

    ! Input
    real :: pressure_in
    logical :: smooth

    ! LOCAL VARIABLES
    REAL :: log_sigma, pressure, log_sigma_inactive
    REAL :: P_low, P_high
    REAL :: T_night_active, T_night_inactive
    REAL :: Temp_low, alpha
    ! OUTPUT
    REAL :: T_night

    ! Create a local pressure variable
    pressure=pressure_in

    ! Set constants 
    ! Heng et al (2011) polynomial fits
    ! are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
    ! Switch to inactive region at 10bar (1e6Pa)
    ! Set the pressure limits
    P_high=1.0e6
    P_low=0.1
    IF (smooth) THEN
       Temp_low=250.0
       alpha=0.10
       P_low=100.0
    END IF
    
    ! Calculate the log_sigma required for T_night_active
    IF (pressure >= P_high) THEN
       log_sigma=LOG10(P_high/1.0e5)
    ELSE IF (pressure <= P_low) THEN
       log_sigma=LOG10(P_low/1.0e5)
    ELSE
       log_sigma=LOG10(pressure/1.0e5)
    END IF

    ! Calculate the Temperature in active region
    T_night_active=hd209458b_heng_active_night(log_sigma)
    
    ! Now calculate the Temperature in the inactive Region
    IF (pressure > P_high) THEN
       ! Use a different log_sigma to stop confusion
       log_sigma_inactive=LOG10(pressure/1.0e5)
       T_night_inactive=hd209458b_heng_inactive_night(log_sigma_inactive)
    ELSE 
       T_night_inactive=0.0
    END IF

    ! Now construct the output temperature
    IF (pressure > P_high) THEN
       if (smooth) then
          T_night=T_night_active+100.0*&
               (1.0-EXP(-1.0*(LOG10(pressure)-LOG10(P_high))))
       else
          T_night=T_night_inactive
       END IF
    ELSE IF (pressure < P_low) THEN
       if (smooth) then
          T_night=&
               MAX(T_night_active*&
               EXP(alpha*(LOG10(pressure)-LOG10(P_low))), Temp_low)
       else
          T_night=T_night_active
       END IF
    ELSE
       T_night=T_night_active     
    ENDIF
    hot_jup_night_temp=T_night
    RETURN
  END FUNCTION hot_jup_night_temp

  real function hd209458b_heng_active_night(log_sigma)
    ! The equation for temperature in the active region
    real :: log_sigma

    hd209458b_heng_active_night=(1388.2145+267.66586*log_sigma &
         -215.53357*(log_sigma**2.0)              &
         +61.814807*(log_sigma**3.0)              &
         +135.68661*(log_sigma**4.0)              &
         +2.0149044*(log_sigma**5.0)              &
         -40.907246*(log_sigma**6.0)              &
         -19.015628*(log_sigma**7.0)              &
         -3.8771634*(log_sigma**8.0)              &
         -0.38413901*(log_sigma**9.0)             &
         -0.015089084*(log_sigma**10.0))     
    return
  end function hd209458b_heng_active_night

  real function hd209458b_heng_inactive_night(log_sigma)
    ! The equation for temperature in the inactive region
    real :: log_sigma

    hd209458b_heng_inactive_night=(5529.7168-6869.6504*log_sigma &
         +4142.7231*(log_sigma**2.0)    &
         -936.23053*(log_sigma**3.0)    &
         +87.120975*(log_sigma**4.0))    
    return
  end function hd209458b_heng_inactive_night


end module heng_night_temperature
