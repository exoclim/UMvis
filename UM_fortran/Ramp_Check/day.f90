module day
use constants
IMPLICIT NONE

CONTAINS

  REAL FUNCTION hot_jup_day_temp(exner_theta_levels, smooth)
    ! Function which returns the day side equilibrium temperature

    REAL, INTENT (INOUT) :: exner_theta_levels

    ! LOCAL VARIABLES
    REAL :: log_sigma, pressure
    REAL :: alpha, p_low, p_high
    INTEGER :: SMOOTH
    ! OUTPUT
    REAL :: T_day
    ! First construct the pressure variable
    pressure=(exner_theta_levels**recip_kappa)*p_zero

    ! Now derive night side temperature
    ! From Heng et al (2011)
    ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
    ! P<=10bar, (1.0e6 pascals). Switch at 10bar (1.0e6Pa)
    ! This profile must be smoothed
    ! Set limiting pressures
    IF (SMOOTH==0) THEN
       p_high=1.0e6
       p_low=0.1
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
    ! Derive T_day
    IF (pressure > p_high) THEN
       log_sigma=LOG10(p_high/1.0e5)
    ELSE IF (pressure < p_low) THEN
       log_sigma=LOG10(p_low/1.0e5)
    ELSE
       log_sigma=LOG10(pressure/1.0e5)
    END IF
    T_day=(2149.9581+4.1395571*(log_sigma) &
         -186.24851*(log_sigma**2.0)       &
         +135.52524*(log_sigma**3.0)       &
         +106.20433*(log_sigma**4.0)       &
         -35.851966*(log_sigma**5.0)       &
         -50.022826*(log_sigma**6.0)       &
         -18.462489*(log_sigma**7.0)       &
         -3.3319965*(log_sigma**8.0)       &
         -0.30295925*(log_sigma**9.0)      &
         -0.011122316*(log_sigma**10.0))  
    
    ! Now perform smoothing if required
    IF (SMOOTH==1 .OR. SMOOTH==2 .OR. SMOOTH==3 .OR. &
         SMOOTH==4) THEN
       ! THIS ONE IS USED IN THE CODE**
       ! Now we smooth the relationship if required
       IF (pressure >p_high) THEN
          ! Exponentially decay the temperature to
          ! into the core
          T_day=T_day-120.0*&
               (1.0-EXP(-1.0*(LOG10(pressure)-LOG10(p_high))))
       ELSE IF (pressure < p_low) THEN
          ! For lower pressures an exponential 
          ! decay in
          ! space to a minimum temperature of 10K
          ! Decaying from 0.1Pa of 1e-6 Bar (hence +1)
          alpha=0.015
          ! Decay from 100 bar
          T_day=max(T_day*&
               EXP(alpha*(log10(pressure)-LOG10(p_low))),&
               100.0)
       END IF
    END IF

    hot_jup_day_temp=T_day
    RETURN
  END FUNCTION hot_jup_day_temp

end module day
