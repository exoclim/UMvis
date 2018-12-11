program test
  real :: temp, press
  integer :: planet
  character(len=100) :: which
  real :: tau_rad

  print*, "Please enter a temperature (K) and pressure (Pa)"
  read(*,*) temp, press
  get_do: do
     print*, 'Choose a planet:'
     print*, '(1): HD209458b'
     print*, '(2): HD189733b'
     read(*,*) planet
     if (planet ==1) then
        which='HD209458b'
        exit get_do
     else if (planet==2) then
        which='HD189733b'
        exit get_do
     endif
  end do get_do

  tau_rad=recip_tau_rad_showman(temp,press,which)
  print*, 'Resulting tau_rad:', 1.0/tau_rad

end program test
