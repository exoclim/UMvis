module iro_temperature
  
  IMPLICIT NONE
  
CONTAINS
  
  REAL FUNCTION iro_HD209458b_temp(pressure_in)
    ! Function which returns the Temperature for the radiative 
    ! equilibrium solution of Iro et al (2005) for HD209458b
    ! (Largely copied from the UM)

    REAL :: pressure_in
    
    ! LOCAL VARIABLES
    REAL :: pressure
    REAL :: log_sigma
    REAL :: P_low, P_high
    ! OUTPUT
    REAL :: T_iro
    
    ! Create a local pressure variable
    pressure=pressure_in

    ! Set validity limits
    ! These are valid from 1microbar (0.1Pa) to 3488 bar (3488e5 Pa)
    P_high=3488.0e5
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
    iro_HD209458b_temp=T_iro
    RETURN
  END FUNCTION iro_HD209458b_temp

end module iro_temperature
