module night
use constants
IMPLICIT NONE
CONTAINS

  REAL FUNCTION hot_jup_night_temp(exner_theta_levels, smooth)
    ! Function which returns the night side equilibrium temperature
    ! for the Hot Jupiter denoted by number (tforce_number) at pressure
    ! of exner_theta_levels

    REAL, INTENT (INOUT) :: exner_theta_levels

    ! LOCAL VARIABLES
    REAL :: log_sigma, pressure
    ! OUTPUT
    REAL :: T_night
    REAL :: alpha, p_low, p_high
    INTEGER :: SMOOTH
    ! First construct the pressure variable
    pressure=(exner_theta_levels**recip_kappa)*p_zero
    ! Now derive night side temperature
    ! From Heng et al (2011)
    ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
    ! P<=10bar, (1.0e6 pascals). Switch at 10bar (1.0e6Pa)
    ! However the behaviour at >10 bar is odd! (a big spike!)
    ! so as we don't force here we smoothly join to an isothermal
    ! sphere
    ! Set limiting pressures
    IF (SMOOTH==0) THEN
       p_high=1.0e6
       p_low=0.1
       ! THIS VERSION IS IN UM AND WORKING**
    ELSE IF (SMOOTH==1) THEN
       p_high=1.0e6
       p_low=100.0
    ELSE IF (SMOOTH==2) THEN
       p_high=1.0e6
       p_low=10.0
    ELSE IF (SMOOTH==3) THEN
       p_high=1.0e6
       p_low=1.0
    ELSE IF (SMOOTH==4) THEN
       p_high=1.0e6
       p_low=0.1
    END IF
    ! Derive T_night
    IF (pressure > p_high) THEN
       log_sigma=LOG10(p_high/1.0e5)
    ELSE IF (pressure < p_low) THEN
       log_sigma=LOG10(p_low/1.0e5)
    ELSE
       log_sigma=LOG10(pressure/1.0e5)
    END IF
    ! Now derive the Heng Temperature
    T_night=(1388.2145+267.66586*log_sigma &
         -215.53357*(log_sigma**2.0)       &
         +61.814807*(log_sigma**3.0)       &
         +135.68661*(log_sigma**4.0)       &
         +2.0149044*(log_sigma**5.0)       &
         -40.907246*(log_sigma**6.0)       &
         -19.015628*(log_sigma**7.0)       &
         -3.8771634*(log_sigma**8.0)       &
         -0.38413901*(log_sigma**9.0)      &
         -0.015089084*(log_sigma**10.0))    
    ! Now perform smoothing if required
    IF (SMOOTH==1 .OR. SMOOTH==2 .OR. SMOOTH==3 .OR. &
         SMOOTH==4) THEN
       ! THIS ONE IS USED IN THE CODE**
       ! Now we smooth the relationship if required
       IF (pressure >p_high) THEN
          ! Exponentially decay the temperature to
          ! into the core
          T_night=T_night+100.0*&
               (1.0-EXP(-1.0*(LOG10(pressure)-LOG10(p_high))))
       ELSE IF (pressure < p_low) THEN
          ! For lower pressures an exponential 
          ! decay in
          ! space to a minimum temperature of 10K
          ! Decaying from 0.1Pa of 1e-6 Bar (hence +1)
          alpha=0.12
          !          T_night=max(T_night*EXP(alpha*(log10(pressure)+1.0)), 10.0)
          ! Decay from 100 bar
          T_night=max(T_night*&
               EXP(alpha*(log10(pressure)-LOG10(p_low))),&
               100.0)
       END IF
    END IF
     hot_jup_night_temp=T_night
    RETURN
  END FUNCTION hot_jup_night_temp
END module night
