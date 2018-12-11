module hd209458b_temperature_spatial

  use iro_temperature
  use heng_night_temperature
  use heng_day_temperature

  IMPLICIT NONE

  integer, parameter :: pi=3.14159265359

CONTAINS  

  REAL FUNCTION hd209458b_temperature(                             &
       pressure_in, longitude, latitude,                           &
       smooth)
    ! Function returning the temperature on HD209458b
    ! at a given latitude & longitude (degrees) and pressure (Pa)
    ! Input 
    real :: pressure_in, longitude, latitude
    logical :: smooth

    ! Local
    real :: longitude_rads, latitude_rads
    real :: T_night, T_day

    ! Equation from Heng et al (2011)
    ! Note there is an error in Heng et al (2011) Eqn 26
    ! 90<phi<270 should be 90<theta<270
    ! Day side is 90<theta(longitude)<270
    ! Therefore, cos(theta_longitude) <=0 

    ! First we convert the degrees to radians
    longitude_rads=longitude*pi/180.0
    latitude_rads=latitude*pi/180.0

    ! Calculate the individual component temperatures
    T_night=hot_jup_night_temp(pressure_in, smooth)
    T_day=hot_jup_day_temp(pressure_in, smooth)

    ! Now the spatial section-Standard setup
    if (cos(longitude_rads) <= 0.0) then 
       hd209458b_temperature =                               &
            ((T_night**4.0 - (T_day**4.0 - T_night**4.0)     &
            & *cos(longitude_rads)                           &
            & *cos(latitude_rads))**0.25)
    else 
       hd209458b_temperature=T_night
    end if
    return
  END FUNCTION hd209458b_temperature

  real function hd209458b_temperature_equator_pole(pressure_in, &
       temperature_in, latitude, T_eq_pole)
    ! Function to add in an equator to pole temperature difference
    ! Input
    real :: pressure_in, latitude, temperature_in
    real :: T_eq_pole

   ! Local variables
    real :: latitude_rads
    
    ! Find the sin of the latitude in radians
    latitude_rads=latitude*pi/180.0
 
    ! Impose equator to pole gradient below ten bar
    IF (pressure_in >= 1.0e6) THEN
        ! Add in Equator to pole difference
       hd209458b_temperature_equator_pole=                    &
            temperature_in + T_eq_pole*                       &
            (sin(latitude_rads)*sin(latitude_rads))
    else
       hd209458b_temperature_equator_pole=temperature_in       
    END IF
    return
  end function hd209458b_temperature_equator_pole
end module hd209458b_temperature_spatial
