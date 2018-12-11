module iro_timescale
  implicit none

contains
  
  real function recip_iro(pressure_in, active_deep)
    ! A function returning the reciprocal newtonian timescale
    ! given a pressure (largely copied form the UM)
    ! input
    real :: pressure_in
    logical :: active_deep

    ! Local variables
    real :: pressure, log_sigma
    real :: newtonian_timescale
    real :: p_high, p_low

    
    ! Create a local pressure variable
    pressure=pressure_in

    ! Active region above ten bar
    p_high=1.0e6
    p_low=1.0

    ! For active deep setups
    if (active_deep) then
       if (pressure > p_high) pressure=p_high
       if (pressure < p_low) pressure=p_low
       log_sigma=log10(pressure/1.0e5)
       newtonian_timescale=1.0/iro_rt(log_sigma)
    else
       if (pressure < p_high) then
          if (pressure < p_low) pressure=p_low
          log_sigma=log10(pressure/1.0e5)
          newtonian_timescale=1.0/iro_rt(log_sigma)
       else
          newtonian_timescale=0.0
       end if
    endif
    recip_iro=newtonian_timescale
    return
  end function recip_iro

  real function iro_rt(log_sigma)
    ! Equation for the timescale itself
    real :: log_sigma
    
    iro_rt=(10.0**(5.4659686+1.4940124*log_sigma                       &
         & +0.66079196*(log_sigma**2.0)+0.16475329*(log_sigma**3.0)    &
         & +0.014241552*(log_sigma**4.0)))
    return
  end function iro_rt
    
end module iro_timescale
